module RegID_EX(
    input clk,
    input reset,
    input write,

    input [13:0] opcode_in,
    input [31:0] rgS1_data_in,
    input [31:0] rgS2_data_in,

    input [3:0] control_in,
    input [4:0] rgD_index_in,
 
    output [13:0] opcode_out,
    output [31:0] rgS1_data_out,
    output [31:0] rgS2_data_out,

    output [3:0] control_out,
    output [4:0] rgD_index_out 
);

    wire [13:0] opcode_hold;
    wire [31:0] rgS1_data_hold;
    wire [31:0] rgS2_data_hold;

    wire [3:0] control_hold;
    wire [4:0] rgD_index_hold;
 

    generate
        genvar i;
        for(i=0; i<13; i = i+1) begin
            FlipFlop r(clk, reset, opcode_in[i], write, opcode_hold[i]);
        end

       
        for(i=0; i<31; i = i+1) begin
            FlipFlop r(clk, reset, rgS1_data_in[i], write, rgS1_data_hold[i]);
        end

        
        for(i=0; i<31; i = i+1) begin
            FlipFlop r(clk, reset, rgS2_data_in[i], write, rgS2_data_hold[i]);
        end
       
       
        for(i=0; i<3; i = i+1) begin
            FlipFlop r(clk, reset, control_in[i], write, control_hold[i]);
        end
 
       
        for(i=0; i<4; i = i+1) begin
            FlipFlop r(clk, reset, rgD_index_in[i], write, rgD_index_hold[i]);
        end
    endgenerate
        
    assign opcode_out = opcode_hold;
    assign rgS1_data_out = rgS1_data_hold;
    assign rgS2_data_out = rgS2_data_hold;
    assign control_out = control_hold;
    assign rdD_index_out = rgD_index_hold;
   
endmodule
