module prc;
reg clk;
reg reset;
Processor prcs (clk, reset);
initial begin
reset = 1;
#3 reset = 0;
#2 reset = 1;
end

initial begin
clk = 0;
repeat(30)
#10 clk = ~clk;
#10 $finish;
end
endmodule
