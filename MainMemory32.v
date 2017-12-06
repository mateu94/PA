//This is the RAM Chip with 32 address lines



module MainMem (clk, CS, OE, WE, Addr, Data, Ready_Mem);

//Parameters
parameter Data_Width = 128;
parameter Addr_Width = 32;
parameter RamDepth =  1<<Addr_Width;


  input clk,CS,OE,WE;
  input[Addr_Width-1:0] Addr;
  inout [Data_Width-1:0] Data;
  output reg Ready_Mem;
  reg [Data_Width-1:0] Mem[RamDepth-1:0];
  reg [Data_Width-1:0] Data_out;
  reg oe_r;
  reg [2:0] count;


// When read. In all other situations 
//(even at chip select = 0) Data has high impedence
assign Data = (CS && OE && ! WE ) ? Data_out : 128'bz;
//  Memory Write Block 
 // Write Operation : When WE = 1, CS = 1
initial
begin
count <= 'd7;
Ready_Mem='b1;
end
 always @ (posedge clk && count ==7)
 begin
    if ( CS && WE ) 
     begin
     Ready_Mem='b0;
     count <= 'd1;
     Mem[Addr] = Data;
     end
 end

always @ (posedge clk && count!=7)
  begin
  count <= count+1;
  if(count==6)
     begin
     Ready_Mem='b1;
     end
  end
 
 // Memory Read Block 
 // Read Operation : When WE = 0, OE = 1, CS = 1
 always @ (negedge clk && count ==7)
 begin 
// Ready_Mem='b0;
   if (CS &&  ! WE && OE)
    begin
    Ready_Mem='b0;
    count <= 'd1;
    Data_out = Mem[Addr];
    oe_r = 1;
    end 
   else
    begin
    oe_r = 0;
    end
 end

endmodule 
