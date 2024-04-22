module SEG7_4X_DEC
(
	input [15:0] value,
	output [6:0] seg0,
	output [6:0] seg1,
	output [6:0] seg2,
	output [6:0] seg3
);

wire [15:0] d10;
wire [15:0] d100;
wire [15:0] d1000;

assign d10 = value/16'd10;
assign d100 = value/16'd100;
assign d1000 = value/16'd1000;

SEG7_LUT	S0	(seg0, value%16'd10);
SEG7_LUT	S1	(seg1, d10%16'd10);
SEG7_LUT	S2	(seg2, d100%16'd10);
SEG7_LUT	S3	(seg3, d1000%16'd10);

endmodule