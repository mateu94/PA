`timescale 1ns / 1ps
`include "CONSTANTS.v"
`include "Memory_Constants.v"
///////////////////////
// 2-Way Set Associative Cache
// 4 lines 
// 1 line = 4 words
// 
///////////////////////

// `define Word_Size 32
module Cache
        (
         input clk,
         input reset_pin,

         input read_CPU,
         input write_CPU,
         inout [Word_Size-1:0] Data_CPU,
         input [Word_Size-1:0] Addr_CPU,
         output reg Stall_PC,
        
         input ready_mem,
         inout [Word_Size-1:0] Data_Mem,
         output reg [Word_Size-1:0] Addr_Mem,
         output reg read_Mem,
         output reg write_Mem
         );
parameter Word_Size = 32;
parameter Block_Size = 4;

reg address_latch [31:0];
reg [29:0] tag0[1:0];
reg[29:0] tag1 [1:0];
reg[(Word_Size*Block_Size)-1:0] data_cache0 [1:0];
reg[(Word_Size*Block_Size)-1:0] data_cache1 [1:0];
reg data_byte[Word_Size-1:0];
reg data_word[(Word_Size*Block_Size)-1:0];
reg data_block[127:0];  // check whether needed 
wire hit0;
wire hit1;
wire hit;
reg Store_tag0 [29:0];
reg Store_tag1 [29:0];
reg Store_data0 [Word_Size-1:0];  // check the size
reg Store_data1 [Word_Size-1:0];
reg counter [1:0];
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

assign hit = hit0 || hit1;
// Cache Controller 

always@(posedge clock or posedge reset)
begin 
     if (reset==1)
        begin 
              Stall_PC <= 'd0;
              Addr_Mem <= 'd0;
              read_Mem <= 'd0;
              write_Mem <= 'd0;
              
              address_latch <= 'd0;
              tag0 <= 'd0;
              tag1 <= 'd0;
              data_cache0 <= 'd0;
              data_cache1 <= 'd0;
              data_byte <= 'd0;
              data_word <= 'd0;
              data_block <= 'd0;
              hit0 = 'd0;
              hit1 = 'd0;
              Store_tag0 <= 'd0;
              Store_tag1 <= 'd0;
              Store_data0 <= 'd0;
              Store_data1 <= 'd0;
              counter <= 'd0;
              usedbit0 = 'd0;                    // '0' for recently used 
              usedbit1 = 'd0;                    // '0' for recently used 
              readnotwrite = 'd1;
             
              state <= IDLE;
     else
          begin  
               case (state)
                    IDLE :  begin 
                            address_latch <= Addr_CPU;
                            Stall_PC <= 'd0;
                            Addr_Mem <= 'd0;
                            read_Mem <= 'd0;
                            write_Mem <= 'd0;
                            
                            data_byte <= 'd0;
                            data_word <= 'd0;
                            data_block <= 'd0;
                            hit0 = 'd0;
                            hit1 = 'd0;
                            Store_tag0 <= 'd0;
                            Store_tag1 <= 'd0;
                            Store_data0 <= 'd0;
                            Store_data1 <= 'd0;
                            counter <= 'd0;
                            usedbit0 = 'd0;
                            usedbit1 = 'd0;
                            
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
                              if ( tag0[addr_latch[4]]== addr_latch[31:5] )
                                 begin
                                 hit0<='d1;
                                 data_word= data_cache0[addr_latch[4]][(((addr_latch[1:0]+1)*32)-1):(addr_latch[1:0]*32)];
                                 data_CPU= data_word;
                                 //used logic - used bit is the second most significant 
                                 tag0[addr_latch[4]][28]<= 'd0;  //just used
                                 tag1[addr_latch[4]][28]<= 'd1;  
                                 state<= IDLE;
                         
                                 end
                              else if (tag1[addr_latch[4]]== addr_latch[31:5])
                                 begin
                                 hit1= 'd1;
                                 data_word= data_cache1[addr_latch[4]][(((addr_latch[1:0]+1)*32)-1):(addr_latch[1:0]*32)];
                                 data_CPU= data_word;
                                 tag1[addr_latch[4]][28]<= 'd0;  //just used
                                 tag0[addr_latch[4]][28]<= 'd1;                                
                                 state<= IDLE;
                                 end
                             //miss logic
                             if(!hit)
                                begin 
                                store_tag0 = tag0[addr_latch[4]];
                                store_tag1 = tag1[addr_latch[4]];
                                stall_pc = 'd1;
                               

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
          endcase
endmodule


