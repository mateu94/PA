`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/13/2018 08:57:33 PM
// Design Name: 
// Module Name: Forwarding_Unit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Forwarding_Unit(
    input clk, 
    input reset, 
    input [4:0] rgS1_index_ID_EX_OUT, 
    input [4:0] rgS2_index_ID_EX_OUT, 
    input [4:0] rgD_index_EX_M_OUT, 
    input [4:0] rgD_index_M_WB_OUT, 
    input [31:0] rgS1_data_ID_EX_OUT, 
    input [31:0] rgS2_data_ID_EX_OUT, 
    input [31:0] w_out_EX_M_OUT, 
    input [31:0] rgD_data_in, 
    input EX_M_writeRg_OUT, 
    input M_WB_writeRg_OUT,
    
    output [31:0] fwS1_data, 
    output [31:0] fwS2_data
    );
    
    reg [31:0] fwS1_data_sign;
    reg [31:0] fwS2_data_sign;
    
    always @(*) begin
        //Comparing SRC1 and DST of EX/M
        if ((EX_M_writeRg_OUT==1'b1) && (rgS1_index_ID_EX_OUT==rgD_index_EX_M_OUT))
            fwS1_data_sign = w_out_EX_M_OUT;
        else if ((M_WB_writeRg_OUT==1'b1) && (rgS1_index_ID_EX_OUT==rgD_index_M_WB_OUT))
            fwS1_data_sign = rgD_data_in;            
        else
            fwS1_data_sign = rgS1_data_ID_EX_OUT;
            
        //Comparing SRC2 and DST of EX/M
        if ((EX_M_writeRg_OUT==1'b1) && (rgS2_index_ID_EX_OUT==rgD_index_EX_M_OUT))
            fwS2_data_sign = w_out_EX_M_OUT;
        else if ((M_WB_writeRg_OUT==1'b1) && (rgS2_index_ID_EX_OUT==rgD_index_M_WB_OUT))
                        fwS2_data_sign = rgD_data_in;
        else
            fwS2_data_sign = rgS2_data_ID_EX_OUT;
    end
    
    assign fwS1_data = fwS1_data_sign;
    assign fwS2_data = fwS2_data_sign;
    
endmodule
