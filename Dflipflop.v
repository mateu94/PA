//D_Flipflop_tbcode
module d_ff_tb();
reg d,clk;
wire q,q_bar;
d_ff DUT(
.d(d),
.clk(clk),
.q(q),
.q_bar(q_bar)
);

initial 
clk=1'b0;
always #10 clk= ~clk;
initial
begin
d= 1'b0;
repeat(10) #25 d= ~d;
//#25 $finish;
end
endmodule

