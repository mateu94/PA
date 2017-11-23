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
reg[1:0] tag0[29:0];
reg[1:0] tag1[29:0];
reg[1:0] data_cache0[(Word_Size*Block_Size)-1:0];
reg[1:0] data_cache1[(Word_Size*Block_Size)-1:0];
reg data_byte[Word_Size-1:0];
reg data_word[(Word_Size*Block_Size)-1:0];
reg data_block[127:0];  // check whether needed 
reg hit0;
reg hit1;
reg hit;
reg Store_tag0 [29:0];
reg Store_tag1 [29:0];
reg Store_data0 [Word_Size-1:0];  // check the size
reg Store_data1 [Word_Size-1:0];
reg counter [1:0];
reg usebit0;
reg usebit1;
       
endmodule


