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
         inout [(Word_Size*Block_Size)-1:0] Data_Mem,
         output reg [Word_Size-1:0] Addr_Mem,
         output reg read_Mem,
         output reg write_Mem
         );


reg [31:0] addr_latch ;
reg [29:0] tag0[1:0];
reg[29:0] tag1 [1:0];
reg[(Word_Size*Block_Size)-1:0] data_cache0 [1:0];
reg[(Word_Size*Block_Size)-1:0] data_cache1 [1:0];
reg [Word_Size-1:0] data_byte;
reg [(Word_Size*Block_Size)-1:0]data_word;
reg [(Word_Size*Block_Size)-1:0]write_word;
reg [127:0]data_block;  // check whether needed 
wire hit0;
wire hit1;
wire hit;
reg [29:0] store_tag0 ;
reg [29:0] store_tag1 ;
reg [Word_Size-1:0] store_data0 ;  // check the size
reg [Word_Size-1:0] store_data1 ;
reg [1:0] counter ;          //haven't used yet 
wire usedbit0;
wire usedbit1;
reg readnotwrite;
//reg word_number;



localparam IDLE		= 3'd0,	
	   READ		= 3'd1,
//	   WRITE	= 3'd2,
	   READMM	= 3'd3,
           WAIT	        = 3'd4,
	   UPDATEMM	= 3'd5,
	   UPDATECACHE	= 3'd6;
       
reg [2:0] state;

assign hit0 = tag0[addr_latch[4]]== addr_latch[31:5];
assign hit1 = tag1[addr_latch[4]]== addr_latch[31:5];
assign hit = hit0 || hit1;

assign usedbit0 = store_tag0[28];    // '0' for recently used 
assign usedbit1 = store_tag1[28];

assign Data_Cpu = read_CPU ? data_word : 8'dZ;
assign Data_Mem = write_Mem ? write_word : 8'dZ;
// Cache Controller 

always@(posedge clk or posedge reset)
begin 
     if (reset==1)
        begin 
              Stall_PC <= 'd0;
              Addr_Mem <= 'd0;
              read_Mem <= 'd0;
              write_Mem <= 'd0;
              
              addr_latch <= 'd0;
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
                            data_byte <= 'd0;
                            data_word <= 'd0;
                            data_block <= 'd0;
                            store_tag0 <= 'd0;
                            store_tag1 <= 'd0;
                            store_data0 <= 'd0;
                            store_data1 <= 'd0;
                            counter <= 'd0;
                            
                            if (read_CPU)
                               begin
                               state <= READ;
                               readnotwrite= 'd1;
                               end
//                            else if ( write_CPU);
//                               state <= WRITE;
//                               readnotwrite= 'd0;
                            else 
                               begin 
                               state <= IDLE;
                               end                           
                            end
                     
                    READ:   begin
                              // hit logic
                              if (hit0)
                                 begin
                                 
                                 data_word= data_cache0[addr_latch[4]][(((addr_latch[1:0]+1)*32)-1):(addr_latch[1:0]*32)];
                                 //Data_CPU= data_word;
                                 //used logic - used bit is the second most significant 
                                 tag0[addr_latch[4]][28]<= 'd0;  //just used
                                 tag1[addr_latch[4]][28]<= 'd1;  
                                 state<= IDLE;
                         
                                 end
                              else if (hit1)
                                 begin
                                 
                                 data_word= data_cache1[addr_latch[4]][(((addr_latch[1:0]+1)*32)-1):(addr_latch[1:0]*32)];
                                 //Data_CPU= data_word;
                                 tag1[addr_latch[4]][28]<= 'd0;  //just used
                                 tag0[addr_latch[4]][28]<= 'd1;                                
                                 state<= IDLE;
                                 end
                             //miss logic
                             if(!hit)
                                begin 
                                store_tag0 = tag0[addr_latch[4]];
                                store_tag1 = tag1[addr_latch[4]];
                                
                                Stall_PC = 'd1;
                               

                                if (ready_mem)
                                    begin
                                    state<= READMM;
                                    end
                                else
                                    begin
                                    state<= state;
                                    end
                        
                                //store data_cache for writeback 
                                end
                             end

                     READMM: begin 
                              read_Mem <= 'd1;
                              Addr_Mem= addr_latch;
                              state <= WAIT;
                             end      
                     WAIT:   begin
                             // NOT DONE YET !!!! UPDATE Memory depending on Write policy 
 

                             //give the Memory data to the CPU
                             data_word= Data_Mem[(((addr_latch[1:0]+1)*32)-1):(addr_latch[1:0]*32)];
                             //Data_CPU= data_word;
                             //Update Cache
                             if (usedbit1 == 0)
                                 begin    
                                 tag0[addr_latch[4]] = addr_latch[31:5];
                                 data_cache0[addr_latch[4]] = Data_Mem;
                                 end
                             else if (usedbit0 == 0)
                                 begin    
                                 tag1[addr_latch[4]] = addr_latch[31:5];
                                 data_cache1[addr_latch[4]] = Data_Mem; 
                                 end  
                             
                             state<= IDLE;       
                             end              
          endcase
          end
end
endmodule

