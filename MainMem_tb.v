`timescale 1ns / 1ps
module MainMem_testbench();
reg clk,CS,OE,WE;
reg[31:0] Addr;
wire [7:0] Data;
wire [7:0] Data_out;
wire oe_r;

//To make the inout port (Data) testable
wire [7:0] Data_input;
reg [7:0] Data_output;
reg Data_output_valid;
assign Data_input = Data;
assign Data = (Data_output_valid==1)?Data_output: 8'hZZ;

MainMem test(clk, CS, OE, WE, Addr, Data);

//creating clock 
always #10 clk= ~clk; 
initial
  begin
    clk= 1'b0;
 
    CS= 1'b0;
    OE= 1'b0;
    WE= 1'b0; 
    Addr= 32'h0;
    #20
// write 'h5' into address 1
    Data_output_valid=1'b1;
    CS= 1'b1;
    WE= 1'b1;
    Addr= 32'h1;
    Data_output = 8'h5;
    #20
// write 'h6' into address 2
    Data_output_valid=1'b1;
    CS= 1'b1;
    WE= 1'b1;
    Addr= 32'h2;
    Data_output = 8'h76;
    #20
// write 'h76' into address FFFFFFFF
    Data_output_valid=1'b1;
    CS= 1'b1;
    WE= 1'b1;
    Addr= 32'h100;
    Data_output = 8'h76;
    #20
// read from address 1
    Data_output_valid=1'b0;
    WE= 1'b0;
    OE= 1'b1;
    Addr= 32'h1;
    #20
// read from address 2     
    Data_output_valid=1'b0;
    WE= 1'b0;
    OE= 1'b1;
    Addr= 32'h2;
#20
// read from address FFFFFFFF    
    Data_output_valid=1'b0;
    WE= 1'b0;
    OE= 1'b1;
    Addr= 32'h10000000;
    
  end
endmodule

