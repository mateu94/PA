
`timescale 1ns / 1ps
module Cache_Mem_testbench();
//Parameters
 parameter Word_Size = 32;
parameter Block_Size = 4;
reg clk, reset, read_CPU, write_CPU, Bytesel;
wire [Word_Size-1:0] Data_CPU;
reg [Word_Size-1:0] Addr_CPU;
wire Stall_PC;

//To make the inout port (Data) testable
wire [Word_Size-1:0] Data_input;
reg [Word_Size-1:0] Data_output;
reg Data_output_valid;
assign Data_input = Data_CPU;
assign Data_CPU = (Data_output_valid==1)?Data_output: 32'bZ;

Cache_Mem test( clk, reset, read_CPU, write_CPU, Bytesel, Data_CPU, Addr_CPU, Stall_PC);

         

//creating clock 
always #5 clk= ~clk; 
initial
  begin
    clk= 1'b0;
 
    reset= 1'b1;
    read_CPU= 1'b0;
    write_CPU= 1'b0; 
    Addr_CPU= 32'h0;
    #10
 reset= 1'b0;
// write 'hFFFFFFFFFFFFF' into address 4
    Data_output_valid=1'b1;
    write_CPU= 1'b1;
    Addr_CPU= 32'h4;
    Data_output = 32'h55;
    #10
    write_CPU=1'b0;
    Data_output_valid=1'b0;
    #120
//read from address 1
    Bytesel='d1;
    Data_output_valid=1'b0;
    write_CPU= 1'b0;
    read_CPU= 1'b1;
    Addr_CPU= 32'h1;
    #10
    read_CPU= 1'b0;
    #50
    Bytesel='d0;
//read from address 4
    Data_output_valid=1'b0;
    write_CPU= 1'b0;
    read_CPU= 1'b1;
    Addr_CPU= 32'h4;
    #10
    read_CPU= 1'b0;
    #50
// write 'h77' into address ff0
    Data_output_valid=1'b1;
    read_CPU=1'b0;
    write_CPU= 1'b1;
    Addr_CPU= 32'hff0;
    Data_output = 32'h77;
    #10
    write_CPU=1'b0;
    Data_output_valid=1'b0;
    #120
//read from address ff0
    Data_output_valid=1'b0;
    write_CPU= 1'b0;
    read_CPU= 1'b1;
    Addr_CPU= 32'hff0;
    #10
    read_CPU = 1'b0;
    #50

// write 'h88' into address ff0
    Data_output_valid=1'b1;
    read_CPU=1'b0;
    write_CPU= 1'b1;
    Addr_CPU= 32'hff0;
    Data_output = 32'h88;
    #10
    write_CPU=1'b0;
    Data_output_valid=1'b0;
    #50

//read from address ff0
    Data_output_valid=1'b0;
    write_CPU= 1'b0;
    read_CPU= 1'b1;
    Addr_CPU= 32'hff0;
    #10
    read_CPU=1'b0;
    #10
//read from address 1ff0
    Data_output_valid=1'b0;
    write_CPU= 1'b0;
    read_CPU= 1'b1;
    Addr_CPU= 32'h1ff0;
    #10
    read_CPU=1'b0;
    #55
// write 'h11' into address 1ff0
    Data_output_valid=1'b1;
    read_CPU=1'b0;
    write_CPU= 1'b1;
    Addr_CPU= 32'hff0;
    Data_output = 32'h88;
    #10
    write_CPU=1'b0;
    Data_output_valid=1'b0;
    #50

//read from address 7f0
    Data_output_valid=1'b0;
    write_CPU= 1'b0;
    read_CPU= 1'b1;
    Addr_CPU= 32'h7f0;
    #10
    read_CPU=1'b0;
    #90
//read from address ff0
    Data_output_valid=1'b0;
    write_CPU= 1'b0;
    read_CPU= 1'b1;
    Addr_CPU= 32'hff0;
    #10
    read_CPU=1'b0;
    
   
/*
// write 'h76' into address 2
    Data_output_valid=1'b1;
    CS= 1'b1;
    WE= 1'b1;
    Addr= 32'h2;
    Data_output = 128'h76;
    #100
// write 'h555' into address 1FFFFFF
    Data_output_valid=1'b1;
    CS= 1'b1;
    WE= 1'b1;
    Addr= 32'h1FFFFFF;
    Data_output = 128'h555;
    #100
//put WE=0
    WE= 1'b0;
    #50
// read from address 1
    Data_output_valid=1'b0;
    WE= 1'b0;
    OE= 1'b1;
    Addr= 32'h1;
    #110
// read from address 2     
    Data_output_valid=1'b0;
    WE= 1'b0;
    OE= 1'b1;
    Addr= 32'h2;
    #110
// read from address 1FFFFFF    
    Data_output_valid=1'b0;
    WE= 1'b0;
    OE= 1'b1;
    Addr= 32'h1FFFFFF;

    #110
// read from address FFFFFFFF    
    Data_output_valid=1'b0;
    WE= 1'b0;
    OE= 1'b1;
    Addr= 32'hFFFFFFF; 
*/  
    
  end
endmodule
