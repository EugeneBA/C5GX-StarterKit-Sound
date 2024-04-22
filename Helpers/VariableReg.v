module VariableReg (clk, inc, dec, var);
parameter SIZE = 16;
parameter DELTA = 1;
parameter MIN = 0;
parameter MAX = 100;
parameter DEFAULT = 50;

input clk;
input inc;
input dec;
output reg [SIZE-1:0] var = DEFAULT;

always@ (posedge clk)
begin
	if(dec && var>MIN)
		var<=var-DELTA;
	if(inc && var<MAX)
		var<=var+DELTA;	
end

endmodule
