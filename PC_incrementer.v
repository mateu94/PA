`timescale 1ns / 1ps

module PC_Incrementer 
        (
         input clk,
         input reset,          
         input stall,
         input PCSrc,
         input [31:0] PC_branch,
         
         output [31:0] PC,
         output [31:0] next_PC                  
         );

    reg [31:0] PC_hold;
    reg [31:0] next_PC_hold;
    
    initial
    begin
        PC_hold = 32'd996;
        next_PC_hold = 32'd0;
    end
    
    always@(posedge clk)
    begin
        if (!stall)
        begin
            PC_hold = PCSrc? PC_branch : PC_hold + 4;
            next_PC_hold = PC_hold + 4;     // blocking operation above, so next_PC will be 4 more than current PC 
        end
    end
    
    assign PC = PC_hold;
    assign next_PC = next_PC_hold;

endmodule
