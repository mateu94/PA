//D_Flipflop_tbcode
module Register_with_synch_load_behavior_tb();

reg D,Clk,load;
wire Q;
Register_with_synch_load_behavior DUT(
.D(D),
.Clk(Clk),
.load(load),
.Q(Q)
);

initial 
load=1'b1;
initial
Clk=1'b0;
always #10 Clk= ~Clk;
initial
begin
D="1111";
repeat(10) #25 D= ~D;
//#25 $finish;
end
endmodule