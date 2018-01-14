`timescale 1ns / 1ps
module Cache_Controller(
input read_Mem_data,
input write_Mem_data,
input read_Mem_instr,
input write_Mem_instr,
input [31:0] Addr_Mem_data,
inout [31:0] Data_Mem_data,
input [31:0] Addr_Mem_instr,
inout [31:0] Data_Mem_instr,

input ready_mem,

output read_Mem,
output write_Mem,
output [31:0] Addr_Mem,
inout [31:0] Data_Mem,

output ready_mem_data,
output ready_mem_instr 
);

reg read_Mem_hold;
reg write_Mem_hold;
reg [31:0] Addr_Mem_hold; 
reg [31:0] Data_Mem_hold; 

reg ready_mem_data_hold;
reg ready_mem_instr_hold;

assign Data_Mem = (write_Mem_data || write_Mem_instr)? (write_Mem_data? Data_Mem_data: Data_Mem_instr) : 32'dz;
assign Data_Mem_data = read_Mem_data? Data_Mem  : 32'dz;
assign Data_Mem_instr = read_Mem_instr? Data_Mem  : 32'dz;
 

always@(read_Mem_data, write_Mem_data, read_Mem_instr, write_Mem_instr)
begin
if(read_Mem_data || write_Mem_data)
   begin
   read_Mem_hold = read_Mem_data;
   write_Mem_hold = write_Mem_data;
   Addr_Mem_hold = Addr_Mem_data;
   end
else if(read_Mem_instr || write_Mem_instr)
   begin
   read_Mem_hold = read_Mem_instr;
   write_Mem_hold = write_Mem_instr;
   Addr_Mem_hold = Addr_Mem_instr;
   end
end 

always @(ready_mem)
begin
if(read_Mem_data || write_Mem_data)
begin
ready_mem_data_hold= ready_mem;
end
else if (read_Mem_instr || write_Mem_instr)
begin
ready_mem_instr_hold= ready_mem;
end
end

assign read_Mem = read_Mem_hold;
assign write_Mem = write_Mem_hold;
assign Addr_Mem = Addr_Mem_hold;
assign Data_Mem = Data_Mem_hold;

assign ready_mem_data = ready_mem_data_hold;
assign ready_instr_data = ready_mem_instr_hold;


endmodule
