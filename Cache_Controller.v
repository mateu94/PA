`timescale 1ns / 1ps
module Cache_Controller(
input read_Mem_data,
input write_Mem_data,
input read_Mem_instr,
input write_Mem_instr,
input [31:0] Addr_Mem_data,
input [127:0] Data_Mem_data_read,
output [127:0] Data_Mem_data_write,

input [31:0] Addr_Mem_instr,
input [127:0] Data_Mem_instr_read,
output [127:0] Data_Mem_instr_write,

input ready_mem,

output read_Mem,
output write_Mem,
output [31:0] Addr_Mem,
input [127:0] Data_Mem_read,
output [127:0] Data_Mem_write,

output ready_mem_data,
output ready_mem_instr 
);

reg read_Mem_hold;
reg write_Mem_hold;
reg [31:0] Addr_Mem_hold; 
reg [127:0] Data_Mem_write_hold;


// this is to remember if the cache asked for the memory or instruction
reg read_Mem_data_hold; 
reg write_Mem_data_hold; 
reg read_Mem_instr_hold; 
reg write_Mem_instr_hold; 


reg ready_mem_data_hold;
reg ready_mem_instr_hold;

//assign Data_Mem = (write_Mem_data || write_Mem_instr)? (write_Mem_data? Data_Mem_data: Data_Mem_instr) : 128'dz;
assign Data_Mem_data_read = Data_Mem_read;
assign Data_Mem_instr_read = Data_Mem_read;
assign Data_Mem_write = Data_Mem_data_write;                      

initial
begin
ready_mem_data_hold = 1'b1;
ready_mem_instr_hold = 1'b1;
end 

always@(read_Mem_data, write_Mem_data, read_Mem_instr, write_Mem_instr)
 begin
 
    if(read_Mem_data || write_Mem_data)
       begin
       read_Mem_hold = read_Mem_data;
       write_Mem_hold = write_Mem_data;
       Addr_Mem_hold = Addr_Mem_data;
       
       if(read_Mem_data)
          read_Mem_data_hold=read_Mem_data;
       if(write_Mem_data)
                    write_Mem_data_hold=write_Mem_data;   
          
       end
    else if(read_Mem_instr || write_Mem_instr)
       begin
       read_Mem_hold = read_Mem_instr;
       write_Mem_hold = write_Mem_instr;
       Addr_Mem_hold = Addr_Mem_instr;
       
       if(read_Mem_instr)
                read_Mem_instr_hold=read_Mem_instr;
       if(write_Mem_instr)
                write_Mem_instr_hold=write_Mem_instr; 
       end
    else
       begin
       read_Mem_hold = 1'b0;
       write_Mem_hold = 1'b0;
       end
 end 
 


always @(ready_mem)
 begin
    if(read_Mem_data_hold || write_Mem_data_hold)
        begin
        ready_mem_data_hold= ready_mem;
        end
    else if (read_Mem_instr_hold || write_Mem_instr_hold)
        begin
        ready_mem_instr_hold= ready_mem;
        end
    else
        begin
        ready_mem_data_hold= ready_mem;
        ready_mem_instr_hold= ready_mem;
        end
 end

assign read_Mem = read_Mem_hold;
assign write_Mem = write_Mem_hold;
assign Addr_Mem = Addr_Mem_hold;
assign Data_Mem_write = Data_Mem_write_hold;

assign ready_mem_data = ready_mem_data_hold;
assign ready_mem_instr = ready_mem_instr_hold;


endmodule
