//This is the RAM Chip with 32 address lines



module MainMem (clk, CS, OE, WE, Addr, Data);

//Parameters
parameter Data_Width = 8;
parameter Addr_Width = 32;
parameter RamDepth = 1<<Addr_Width;


  input clk,CS,OE,WE;
  input[Addr_Width-1:0] Addr;
  inout [Data_Width-1:0] Data;
  reg [Data_Width-1:0] Mem[RamDepth-1:0];
  reg [Data_Width-1:0] Data_out;
  reg oe_r;


// When read. In all other situations 
//(even at chip select = 0) Data has high impedence
assign Data = (CS && OE && ! WE ) ? Data_out : 8'bz;
// Memory Write Block 
  // Write Operation : When WE = 1, CS = 1
always @ (posedge clk)
begin
    if ( CS && WE ) begin
        Mem[Addr] = Data;
    end
 end
 
 // Memory Read Block 
 // Read Operation : When WE = 0, OE = 1, CS = 1
 always @ (negedge clk)
 begin 
   if (CS &&  ! WE && OE) begin
     Data_out = Mem[Addr];
     oe_r = 1;
   end else begin
     oe_r = 0;
  end
 end

endmodule 
