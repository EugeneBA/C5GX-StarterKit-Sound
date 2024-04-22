module RepeatPulse (input clk, input en, output reg pulse);
parameter T = 100; //ms
localparam ClkCountIn1ms = 50_000; 
reg [31:0]	counter;

always @(posedge clk)
begin
	if(en)
	begin
		counter<=counter+1;
		pulse<=0;
		if(counter>=T*ClkCountIn1ms)
		begin
			counter<=0;
			pulse<=1;
		end
	end else
	begin
		pulse<=0;
		counter<=0;
	end
end

endmodule
