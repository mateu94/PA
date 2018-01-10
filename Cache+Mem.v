`timescale 1ns / 1ps


module Cache_Mem
  #(parameter Word_Size = 32,parameter Block_Size = 4)        
(
         input clk,
         input reset,

         input read_CPU,
         input write_CPU,
         input Bytesel,
         inout [Word_Size-1:0] Data_CPU,
         input [Word_Size-1:0] Addr_CPU,
         output Stall_PC
         
        
);
         wire ready_mem;
         wire [(Word_Size*Block_Size)-1:0] Data_Mem;
         wire [Word_Size-1:0] Addr_Mem;
         wire read_Mem;
         wire write_Mem;
        
         wire CS;
   assign CS = 'd1;
  
    MainMem RAM(.clk(clk), .CS(CS), .OE(read_Mem), .WE(write_Mem), .Addr(Addr_Mem), .Data(Data_Mem), .Ready_Mem(ready_mem));

    Cache Data_Cache (clk, reset, read_CPU, write_CPU, Bytesel, Data_CPU, Addr_CPU, Stall_PC, ready_mem, Data_Mem, Addr_Mem, read_Mem, write_Mem );

   
endmodule
