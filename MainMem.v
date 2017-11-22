//This is the RAM Chip with only 10 address lines

module MainMem (clk, CS, OE, WE, Addr, Data);
input clk,CS,OE,WE;
input[31:0] Addr;
inout [7:0] Data;
reg [7:0] Mem[2^32:0];
reg [7:0] Data_out;
reg oe_r;

// When read. In all other situations 
//(even at chip select = 0) Data has high impedence
assign Data = (CS && OE && ! WE ) ? Data_out : 8'bz;
// Memory Write Block 
  // Write Operation : When we = 1, cs = 1
always @ (posedge clk)
begin
    if ( CS && WE ) begin
        Mem[Addr] = Data;
    end
 end
 
 // Memory Read Block 
 // Read Operation : When we = 0, oe = 1, cs = 1
 always @ (negedge clk)
 begin 
   if (CS &&  ! WE && OE) begin
     Data_out = Mem[Addr];
     oe_r = 1;
   end else begin
     oe_r = 0;
  end
 end

endmodule // End of Module ram_sp_sr_sw
