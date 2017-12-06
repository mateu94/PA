`timescale 1ns / 1ps
module MainMem_testbench();
//Parameters
parameter Data_Width = 128;
parameter Addr_Width = 25;
parameter RamDepth =  1<<Addr_Width;

reg clk,CS,OE,WE;
wire Ready_Mem;
reg[Addr_Width-1:0] Addr;
wire [Data_Width-1:0] Data;
wire [Data_Width-1:0] Data_out;
wire oe_r;

//To make the inout port (Data) testable
wire [Data_Width-1:0] Data_input;
reg [Data_Width-1:0] Data_output;
reg Data_output_valid;
assign Data_input = Data;
assign Data = (Data_output_valid==1)?Data_output: 128'bZ;

MainMem test(clk, CS, OE, WE, Addr, Data,Ready_Mem);

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
// write 'hFFFFFFFFFFFFF' into address 1
    Data_output_valid=1'b1;
    CS= 1'b1;
    WE= 1'b1;
    Addr= 32'h1;
    Data_output = 128'hFFFFFFFFFFFFF;
    #100
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
    
  end
endmodule

