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
    reg flag;
    
    always@(negedge clk)
    begin
       
        if (reset)
        begin
            PC_hold = 32'd0 - 4;
            next_PC_hold = 32'd0;
            flag = 1'b0;
        end
        else if (stall)
        begin      
        flag = 1'b1;
        end
        else if (!stall)
        begin
           /* if (!flag)
                begin
                flag = 1'b0;
                PC_hold = PCSrc? PC_branch - 4 : PC_hold + 4;
                next_PC_hold = PC_hold + 4;     // blocking operation above, so next_PC will be 4 more than current PC 
                end
           else 
                begin
                if (PCSrc)
                   begin
                   PC_hold = PC_branch - 4;
                   end
                flag = 1'b0;
                end   */
        PC_hold = PCSrc? PC_branch - 4 : PC_hold + 4;        
        end
    end
    
    assign PC = PC_hold;
    assign next_PC = next_PC_hold;

endmodule
