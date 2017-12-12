`timescale 1ns / 1ps
`include "CONSTANTS.v"
//`include "Memory_Constants.v"
///////////////////////
// 2-Way Set Associative Cache
// 4 lines 
// 1 line = 4 words
// 
///////////////////////

// `define Word_Size 32
module Cache 
        #(parameter Word_Size = 32,parameter Block_Size = 4)
         
        (
         input clk,
         input reset,

         input read_CPU,
         input write_CPU,
         inout [Word_Size-1:0] Data_CPU,
         input [Word_Size-1:0] Addr_CPU,
         output reg Stall_PC,
        
         input ready_mem,
//         input mem_done,
         inout [(Word_Size*Block_Size)-1:0] Data_Mem,
         output reg [Word_Size-1:0] Addr_Mem,
         output reg read_Mem,
         output reg write_Mem,

         output hit,
         output reg [2:0] state,
         output reg state_cycle
         );


reg [31:0] addr_latch ;
reg [31:0] addr_latch1;
reg [31:0] data_latch;
reg [29:0] tag0[1:0];
reg [29:0] tag1[1:0];
reg[(Word_Size*Block_Size)-1:0] data_cache0 [1:0];
reg[(Word_Size*Block_Size)-1:0] data_cache1 [1:0];

reg[(Word_Size)-1:0] buffer_addr[7:0];
reg[(Word_Size)-1:0] buffer_data[7:0];
reg[4:0] head, tail;
wire hit_BUF;
reg[7:0] hit_buf;
reg[4:0] buffer_match;
//reg[4:0] write_head, write_tail;

reg [10:0] i;

reg [Word_Size-1:0] data_byte;
reg [Word_Size-1:0]data_word;
reg [(Word_Size*Block_Size)-1:0]write_word;
reg [127:0]data_block;  // check whether needed 
wire hit0;
wire hit1;
//wire hit;
reg [29:0] store_tag0 ;
reg [29:0] store_tag1 ;
reg [Word_Size-1:0] store_data0 ;  // check the size
reg [Word_Size-1:0] store_data1 ;
reg [1:0] counter ;          //haven't used yet 
wire usedbit0;
wire usedbit1;
reg readnotwrite;
reg from_read;                  // used as a flag to resuse the state for READMM and WAIT for a cache miss (read or write). We are using a write allocate policy 
//reg word_number; 
reg[8:0] temp, temp1, temp2;
reg [127:0] tempstore;

localparam IDLE		= 3'd0,	
	   READ		= 3'd1,
	   WRITE	= 3'd2,
	   READMM	= 3'd3,
           WAIT	        = 3'd4,
	   UPDATEMM	= 3'd5,
	   UPDATECACHE	= 3'd6;
       
//wire [2:0] state;

assign hit_BUF= (hit_buf[0]||hit_buf[1]||hit_buf[2]||hit_buf[3]||hit_buf[4]||hit_buf[5]||hit_buf[6]||hit_buf[7]);

assign hit0 = (tag0[addr_latch[4]][26:0]== addr_latch[31:5])&&(tag0[addr_latch[4]][28]); //  28 is VALID BIT !!!!
assign hit1 = (tag1[addr_latch[4]][26:0]== addr_latch[31:5])&&(tag1[addr_latch[4]][28]);
assign hit = hit0 || hit1;

assign usedbit0 = tag0[addr_latch[4]][27];    // '0' for recently used 
assign usedbit1 = tag1[addr_latch[4]][27];

assign Data_CPU = read_CPU ? data_word : 32'dZ;
assign Data_Mem = write_Mem ? write_word : 128'dZ;
// Cache Controller 

always@(posedge clk or posedge reset or state_cycle)
begin 
     if (reset==1)
        begin 
              Stall_PC <= 'd0;
              Addr_Mem <= 'd0;
              read_Mem <= 'd0;
              write_Mem <= 'd0;
             
              head<='d0;
              tail<='d10;
              hit_buf<='d0;
              i<='d0;
              
              addr_latch <= 'd0;
              data_latch <= 'd0;
              tag0 [0] <= 'd0;
              tag0 [1] <= 'd0;
              tag1 [0] <= 'd0;
              tag1 [1] <= 'd0;
              data_cache0[0] <= 'd0;
              data_cache0[1] <= 'd0;
              data_cache1[0] <= 'd0;
              data_cache1[1] <= 'd0;
              data_byte <= 'd0;
              data_word <= 'd0;
              write_word <= 'd0;
              data_block <= 'd0;
              store_tag0 <= 'd0;
              store_tag1 <= 'd0;
              store_data0 <= 'd0;
              store_data1 <= 'd0;
              counter <= 'd0;
                               
              readnotwrite = 'd1;
             
              state <= IDLE;
              state_cycle<= 'd0;
        end
     else
          begin  
               case (state)
                    IDLE :  begin 
                            addr_latch <= Addr_CPU;
                            Stall_PC <= 'd0;
                            Addr_Mem <= 'd0;
                            read_Mem <= 'd0;
                            write_Mem <= 'd0;
                            write_word <= 'd0;
                            
                            store_tag0 <= 'd0;
                            store_tag1 <= 'd0;
                            store_data0 <= 'd0;
                            store_data1 <= 'd0;
                            counter <= 'd0;
                            
                            if (read_CPU)
                               begin
                               state <= READ;
                               state_cycle<= ~state_cycle;
                               readnotwrite= 'd1;
                               end
                            else if ( write_CPU)
                               begin
                               state <= WRITE;
                               state_cycle<= ~state_cycle;
                               data_latch <= Data_CPU; 
                               readnotwrite= 'd0;
                               end
                            else 
                               begin 
                               state <= IDLE;
                               end                           
                            end
                     
                    READ:   begin #1
                            // checking if buffer has data for this address
                            // first check if the buffer is empty, buffer empty if tail =10
                            if(tail!=10)
                              begin #1
                              state<=IDLE;
                              if(tail-head>=0)
                                 begin
                                 for(i=tail+1; i>=head+1; i=i-1)            // newer to older
                                     begin
                                     if (buffer_addr[i-1]== addr_latch)
                                        begin
                                        hit_buf[i-1]='d1;
                                        data_word=buffer_data[i-1];                                        
                                        i='d1;                                        
                                        end                                            
                                     end          
                                 end
                              else if(head-tail>0)
                                     begin
                                     for(i=tail+1;i>=1; i=i-1)
                                        begin
                                        if (buffer_addr[i-1]== addr_latch)
                                           begin
                                           hit_buf[i-1]='d1;
                                           data_word=buffer_data[i-1];
                                           i='d1;
                                           end
                                        end
                                       
                                     if(!hit_BUF)
                                        begin
                                        for(i='d8;i>=head+1; i=i-1)
                                            begin
                                            if (buffer_addr[i-1]== addr_latch)
                                               begin
                                               hit_buf[i-1]='d1;
                                               data_word=buffer_data[i-1];
                                               i=head+1;
                                               end
                                            end
                                        end
                                      end
                               end
                            // hit logic
                              if (hit0 && !hit_BUF)
                                 begin
                                  // see part selection with variable or indexed part select
                                 data_word= data_cache0[addr_latch[4]][((addr_latch[1:0])*32)+:32];
                                 
                                 //used logic - used bit is the second most significant                                                   
                                 tag0[addr_latch[4]][27]<= 'd0;  //just used
                                 tag1[addr_latch[4]][27]<= 'd1;  
                                 state<= IDLE;
                         
                                 end
                              else if (hit1 && !hit_BUF)
                                 begin
                                 data_word= data_cache1[addr_latch[4]][((addr_latch[1:0])*32)+:32];
            
                                 tag1[addr_latch[4]][27]<= 'd0;  //just used
                                 tag0[addr_latch[4]][27]<= 'd1;                                
                                 state<= IDLE;
                                 end
                             //miss logic
                             if(!hit)
                                begin 
                                //store_tag0 = tag0[addr_latch[4]];
                                //store_tag1 = tag1[addr_latch[4]];
                                
                                Stall_PC <= 'd1; 
                                from_read<= 'd1;                                                     
                                state<= READMM;  
                                state_cycle<= ~state_cycle;                             
                                //store data_cache for writeback or implement STORE or MERGE Buffer 
                                end
                             end

                     READMM: begin #1
                              write_Mem <= 'd0; 
                              if(ready_mem)
                                 begin 
                                 read_Mem <= 'd1;
                                 Addr_Mem= addr_latch;
                                 state <= WAIT;
                                // state_cycle<= ~state_cycle;
                                 end
                              else
                                 state<=READMM;
                             end      
                     WAIT:   begin #1
                             // NOT DONE YET !!!! UPDATE Memory depending on Write policy 
                             // 
 
                             //We call this WAIT because memory will take 5 cycles to complete this
                             //give the Memory data to the CPU
                             //we need to check ready_mem again as when it comes from WRITE, we need to know that the write is done
                             read_Mem<='d0;
                             
                             
                             if(from_read)
                                   begin
                                   data_word= Data_Mem[((addr_latch[1:0])*32)+:32];
                                   end  
                               //Data_CPU= data_word;
                              //check if the buffer has data for this address, if yes, FLUSH!!
                               if(tail-head>=0)
                                 begin
                                 for(i=tail+1; i>=head+1; i=i-1)            // newer to older
                                     begin
                                     if (buffer_addr[i-1]== addr_latch)
                                        begin
                                        hit_buf[i-1]='d1;
                                        buffer_match=i-1;
                                        i=head+1;
                                        end
                                                 
                                     end          
                                 end
                              else if(head-tail>0)
                                     begin
                                     for(i=tail+1;i>=1; i=i-1)
                                        begin
                                        if (buffer_addr[i-1]== addr_latch)
                                           begin
                                           hit_buf[i-1]='d1;
                                           buffer_match=i-1;
                                           i='d1;
                                           end
                                        end
                                       
                                     if(!hit_BUF)
                                        begin
                                        for(i='d8;i>=head+1; i=i-1)
                                            begin
                                            if (buffer_addr[i-1]== addr_latch)
                                               begin
                                               hit_buf[i-1]='d1;
                                               buffer_match=i-1;
                                               i=head+1;
                                               end
                                             end 
                                        end
                                      end
                               //Update Cache
                             if(hit_BUF)
                                begin
                                //FLUSH!!!!!
                                Stall_PC='d1;
                                addr_latch1=addr_latch;
                                if(tail-head>0)
                                  begin          
                                  for(i=head+1;i<=tail+1;i=i+1)
                                      begin
                                      addr_latch=buffer_addr[i-1];
                                      if(hit0)
                                         begin
                                         data_cache0[addr_latch[4]][((addr_latch[1:0])*32)+:32]=buffer_data[i-1];
                                         tag0[addr_latch[4]][29:28]<= 'd1;                                    // dirty bit and valid bit set
                                         end
                                      else if (hit1)
                                         begin
                                         data_cache1[addr_latch[4]][((addr_latch[1:0])*32)+:32]=buffer_data[i-1];
                                         tag1[addr_latch[4]][29:28]<= 'd1;
                                         end
                                      end
                                  end
                                if(head-tail>0)
                                   begin
                                   for(i=head+1;i<=8;i=i+1)
                                      begin
                                      addr_latch=buffer_addr[i-1];
                                      if(hit0)
                                         begin
                                         data_cache0[addr_latch[4]][((addr_latch[1:0])*32)+:32]=buffer_data[i-1];
                                         tag0[addr_latch[4]][29:28]<= 'd1;
                                         end
                                      else if (hit1)
                                         begin
                                         data_cache1[addr_latch[4]][((addr_latch[1:0])*32)+:32]=buffer_data[i-1];
                                         tag1[addr_latch[4]][29:28]<= 'd1;
                                         end
                                      end
                                   for(i=1;i<=tail+1;i=i+1)
                                      begin
                                      addr_latch=buffer_addr[i-1];
                                      if(hit0)
                                         begin
                                         data_cache0[addr_latch[4]][((addr_latch[1:0])*32)+:32]=buffer_data[i-1];
                                         tag0[addr_latch[4]][29:28]<= 'd1;
                                         end
                                      else if (hit1)
                                         begin
                                         data_cache1[addr_latch[4]][((addr_latch[1:0])*32)+:32]=buffer_data[i-1];
                                         tag1[addr_latch[4]][29:28]<= 'd1;
                                         end
                                      end
                                   end
                                addr_latch=addr_latch1;
                                head='d0;
                                tail='d10;
                                #1
                                Stall_PC='d0;
                                end
                             if (usedbit1 == 0)
                                   begin 
                                   if(tag0[addr_latch[4]][29]==1)
                                     begin
                                     // Eviction!!!!
                                     Stall_PC<= 'd1;
                                     if (ready_mem && !write_Mem)
                                        begin
                                        write_Mem<= 'd1;
                                        Addr_Mem <={tag0[addr_latch[4]][26:0],addr_latch[4],2'b00};           // TO BE ADDED!!!!!       
                                        write_word<=data_cache0[addr_latch[4]];
                                        from_read<= 'd0;        
                                        tag0[addr_latch[4]][29]='d0;            //dirty bit=0                                                             
                                        end
                                     state<=READMM;
                                     end   
                                   tag0[addr_latch[4]] = {3'b010,addr_latch[31:5]};        // validbit set, usedbit made zero and rest of tag updated
                                   data_cache0[addr_latch[4]] = Data_Mem;
                                   tag1[addr_latch[4]][27] = 'd1;                          // usedbit of tag1 made 1.
                                   end
                             else if (usedbit0 == 0)
                                   begin    
                                    if(tag1[addr_latch[4]][29]==1)
                                     begin
                                     // Eviction!!!!
                                     Stall_PC<= 'd1;
                                     if (ready_mem && !write_Mem)
                                        begin
                                        write_Mem<= 'd1;
                                        Addr_Mem <={tag1[addr_latch[4]][26:0],addr_latch[4],2'b00};           // TO BE ADDED!!!!!       
                                        write_word<=data_cache1[addr_latch[4]];
                                        from_read<= 'd0;        
                                        tag1[addr_latch[4]][29]='d0;            //dirty bit=0                                                             
                                        end
                                     state<=READMM;
                                     end   
                                   tag1[addr_latch[4]] = {3'b010,addr_latch[31:5]};      // validbit set, usedbit made zero and rest of tag updated
                                   data_cache1[addr_latch[4]] = Data_Mem; 
                                   tag0[addr_latch[4]][27] = 'd1;                        // usedbit of tag0 made 1.
                                   end  
                            //  tempstore= data_cache0[1]; 
                             if (ready_mem)
                               begin
                               state<= IDLE;   
                               end
                             else
                               begin
                               state<= WAIT;
                               end          
                             end     
                             
                     WRITE: begin #1
                            if(hit)
                              // NOT DONE YET !!!! Merge Buffer or Store Buffer logic here 
                              begin
                              if(head-tail==1 || tail-head==7)
                                begin
                              //Buffer full -> Stall PC and Flush 
                                Stall_PC='d1;
                                addr_latch1=addr_latch;
                                if(tail-head>0)
                                  begin          
                                  for(i=head+1;i<=tail+1;i=i+1)
                                      begin
                                      addr_latch=buffer_addr[i-1];
                                      if(hit0)
                                         begin
                                         data_cache0[addr_latch[4]][((addr_latch[1:0])*32)+:32]=buffer_data[i-1];
                                         tag0[addr_latch[4]][29:28]<= 'd1;                                    // dirty bit and valid bit set
                                         end
                                      else if (hit1)
                                         begin
                                         data_cache1[addr_latch[4]][((addr_latch[1:0])*32)+:32]=buffer_data[i-1];
                                         tag1[addr_latch[4]][29:28]<= 'd1;
                                         end
                                      end
                                  end
                                if(head-tail>0)
                                   begin
                                   for(i=head+1;i<=8;i=i+1)
                                      begin
                                      addr_latch=buffer_addr[i-1];
                                      if(hit0)
                                         begin
                                         data_cache0[addr_latch[4]][((addr_latch[1:0])*32)+:32]=buffer_data[i-1];
                                         tag0[addr_latch[4]][29:28]<= 'd1;
                                         end
                                      else if (hit1)
                                         begin
                                         data_cache1[addr_latch[4]][((addr_latch[1:0])*32)+:32]=buffer_data[i-1];
                                         tag1[addr_latch[4]][29:28]<= 'd1;
                                         end
                                      end
                                   for(i=1;i<=tail+1;i=i+1)
                                      begin
                                      addr_latch=buffer_addr[i-1];
                                      if(hit0)
                                         begin
                                         data_cache0[addr_latch[4]][((addr_latch[1:0])*32)+:32]=buffer_data[i-1];
                                         tag0[addr_latch[4]][29:28]<= 'd1;
                                         end
                                      else if (hit1)
                                         begin
                                         data_cache1[addr_latch[4]][((addr_latch[1:0])*32)+:32]=buffer_data[i-1];
                                         tag1[addr_latch[4]][29:28]<= 'd1;
                                         end
                                      end
                                   end
                                addr_latch=addr_latch1;
                                head='d0;
                                tail='d10;
                                #1
                                Stall_PC='d0;
                                end  
                              if(tail==10)
                                begin
                                tail=head;
                                end 
                              else if(tail==7)
                                begin
                                tail='d0;
                                end 
                              else
                                begin 
                                tail=tail+1;
                                end
                              buffer_data[tail]=data_latch;
                              buffer_addr[tail]=addr_latch;
                              
                              state<= IDLE;
                              end
                           /* else if(hit1)
                             // NOT DONE YET !!!! Merge Buffer or Store Buffer logic here 
                              begin
                              state<= IDLE ;
                              end*/
                            if(!hit)
                               begin
                               Stall_PC<= 'd1;
                               if (ready_mem && !write_Mem)
                                   begin
                                   write_Mem<= 'd1;
                                   Addr_Mem <=addr_latch;                   //NOPE!!! a word is being written, memory doesnt support that yet ! what the hell is this ???
                                   write_word<=data_latch;
                                   from_read<= 'd0;
                                   
                                   // notice that we do not wait here as there is no data to be received. We just let the Main memory 'write' at its pace
                                   end
                               
                                    state<=READMM;
                                      
                                
                                
                                                                                
                                                                 
                               end   
                            end 
          endcase    
          end
end
endmodule

