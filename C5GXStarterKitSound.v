
//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

module C5GXStarterKitSound(

	//////////// CLOCK //////////
	input 		          		CLOCK_125_p,
	input 		          		CLOCK_50_B5B,
	input 		          		CLOCK_50_B6A,
	input 		          		CLOCK_50_B7A,
	input 		          		CLOCK_50_B8A,

	//////////// LED //////////
	output		     [7:0]		LEDG,
	output		     [9:0]		LEDR,

	//////////// KEY //////////
	input 		          		CPU_RESET_n,
	input 		     [3:0]		KEY,

	//////////// SW //////////
	input 		     [9:0]		SW,

	//////////// SEG7 //////////
	output		     [6:0]		HEX0,
	output		     [6:0]		HEX1,
	output		     [6:0]		HEX2,
	output		     [6:0]		HEX3,

	//////////// Audio ////////// (PB - PlayBack; REC - Record)
	input 		          		AUD_ADCDAT,  // Audio CODEC ADC Data (RECDAT)
	inout 		          		AUD_ADCLRCK, // Audio CODEC ADC LR Clock (RECLRC)
	inout 		          		AUD_BCLK,    // Audio CODEC Bit-Stream Clock (BCLK)
	output		          		AUD_DACDAT,  // Audio CODEC DAC Data (PBDAT)
	inout 		          		AUD_DACLRCK, // Audio CODEC DAC LR Clock (PBLRC)
	output		          		AUD_XCK,     // Audio CODEC Chip Clock (MCLK)

	//////////// I2C for Audio/HDMI-TX/Si5338/HSMC //////////
	output		          		I2C_SCL,
	inout 		          		I2C_SDA,

	//////////// Uart to USB //////////
	input 		          		UART_RX,
	output		          		UART_TX,

	//////////// SRAM //////////
	output		    [17:0]		SRAM_A,
	output		          		SRAM_CE_n,
	inout 		    [15:0]		SRAM_D,
	output		          		SRAM_LB_n,
	output		          		SRAM_OE_n,
	output		          		SRAM_UB_n,
	output		          		SRAM_WE_n
);



//=======================================================
//  REG/WIRE declarations
//=======================================================

wire [15:0] freq;
wire [9:0] gain;

localparam MAX_GAIN = 10'd1000;

wire [3:0] RepeatKEY;


//=======================================================
//  Structural coding
//=======================================================

generate
genvar i;
for(i=0; i<4; i=i+1) begin: GRepeatKey
	RepeatPulse #(.T(200)) reBtn(.clk(CLOCK_50_B5B), .en(~KEY[i]), .pulse(RepeatKEY[i]));
end
endgenerate

VariableReg #(.SIZE(10), .MIN(0), .MAX(MAX_GAIN), .DELTA(50), .DEFAULT(500)) GainVar
(
	.clk(CLOCK_50_B5B),
	.inc(RepeatKEY[0]),
	.dec(RepeatKEY[1]),
	.var(gain)	
);

VariableReg #(.SIZE(16), .MIN(100), .MAX(22000), .DELTA(100), .DEFAULT(1000))
FreqVar
(
	.clk(CLOCK_50_B5B),
	.inc(RepeatKEY[2]),
	.dec(RepeatKEY[3]),
	.var(freq)	
);


SEG7_4X_DEC
(
	.value(SW[9]?(freq/10'd10):(gain/10'd10)),
	.seg0(HEX0),
	.seg1(HEX1),
	.seg2(HEX2),
	.seg3(HEX3)
);

endmodule
