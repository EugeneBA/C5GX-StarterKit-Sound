module SEG7_4X_HEX 
(
	input [15:0] value,
	output [6:0] seg0,
	output [6:0] seg1,
	output [6:0] seg2,
	output [6:0] seg3
);

SEG7_LUT	S0	(seg0,value[3:0]);
SEG7_LUT	S1	(seg1,value[7:4]);
SEG7_LUT	S2	(seg2,value[11:8]);
SEG7_LUT	S3	(seg3,value[15:12]);

endmodule