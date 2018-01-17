`timescale 1ns / 1ps
//This is the RAM Chip with 25 address lines



module MainMem (clk, CS, OE, WE, Addr, Data_in, Data_out, Ready_Mem);

//Parameters
parameter Data_Width = 128;
parameter Addr_Width = 32;
parameter RamDepth =  1<<Addr_Width;


  input clk,CS,OE,WE;
  input[Addr_Width-1:0] Addr;
  input [Data_Width-1:0] Data_in;
  output [Data_Width-1:0] Data_out;
  output reg Ready_Mem;
  reg [31:0] Mem[20:0];
  reg [Data_Width-1:0] Data_out_hold;
  reg oe_r;
  reg [2:0] count;
  reg read_hold;
  reg write_hold;
  wire [27:0]Addr_block;
  wire [29:0]Addr_word;
  integer file_code;
  integer file_data;

assign Addr_block = Addr[31:4];
assign Addr_word = {Addr_block,2'b00};

  
  reg [31:0] Memorytest [15:0];
    reg [31:0] Memorytest2 [15:0];
// When read. In all other situations 
//(even at chip select = 0) Data has high impedence
//assign Data = (CS && read_hold && ! WE ) ? Data_out : 128'bz;
//  Memory Write Block 
 // Write Operation : When WE = 1, CS = 1
 initial
 begin
       $readmemb("data.dat", Memorytest) ;
 end
 
initial
begin
// signal initialisation
count <= 'd2;
Ready_Mem='b1;
read_hold='d0;
write_hold='d0;

//memory initialisation
  //file_code = $fopen("data.txt") ;
  $readmemb("data.dat", Mem);
//    $readmemb("data.dat", Memorytest2) ;
  //$fdisplay(file_code, "HOLA");
  //$fclose(file_code) ;
/*
  file_data = $fopen("data.txt") ;
  $readmemb("data.bin", Mem, 10000, 2) ;
  $fclose(file_data) ;
*/

end
 always @ (posedge clk && count ==2)
 begin
    if ( CS && WE ) 
     begin
     Ready_Mem='b0;
     count <= 'd1;
     Mem[Addr_word] = Data_in[31:0];
     Mem[Addr_word+1]=Data_in[63:32];
     Mem[Addr_word+2]=Data_in[95:64];
     Mem[Addr_word+3]=Data_in[127:96];
    
     write_hold= 'd1;
     end
 end

always @ (posedge clk && count!=2)
  begin
  count = count+1;
  if(count==2)
     begin
     Ready_Mem='b1;
     read_hold='d0;
     write_hold='d0;
     end
  end
 
 // Memory Read Block 
 // Read Operation : When WE = 0, OE = 1, CS = 1
 always @ (negedge clk && count ==2)
 begin 
// Ready_Mem='b0;
   if (CS &&  ! WE && OE)
    begin
    read_hold='d1;
    Ready_Mem='b0;
    count = 'd1;
    Data_out_hold = {Mem[Addr_word+3],Mem[Addr_word+2],Mem[Addr_word+1],Mem[Addr_word]};
    oe_r = 1;
    end 
   else
    begin
    oe_r = 0;
    end
 end
assign Data_out = Data_out_hold;
endmodule 

