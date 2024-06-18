module I2S_transmitter 
#(
    parameter  SAMPLE_WIDTH = 16 
)
(
    input Clk,
    input BClk,                       // Bit-Stream Clock  
    input LRClk,                      // DAC LR Clock 
    input [SAMPLE_WIDTH-1:0] LeftIn,  // вектор левого канала для вывода на ЦАП
    input [SAMPLE_WIDTH-1:0] RightIn, // вектор правого канала для вывода на ЦАП);
    output DacDat
);

// вектора для входных данных (для ЦАП)
reg [SAMPLE_WIDTH-1:0] lb;
reg [SAMPLE_WIDTH-1:0] rb;
 
reg [4:0] bit_cnt; // указатель текущего бита
reg actualLR;

wire [4:0] bit_ptr = ~bit_cnt;
assign DacDat = (bit_cnt < SAMPLE_WIDTH) ? actualLR ? lb[bit_ptr] : rb[bit_ptr] : 1'b0;

reg [2:0] bclk_trg; 

always @(posedge Clk)
    bclk_trg <= { bclk_trg[1:0], BClk };

assign BCLK_S = bclk_trg[1];                    // синхронизированный BCLK
wire BCLK_Pos = ~bclk_trg[2] & bclk_trg[1];           // выделенный передний фронт BCLK
wire BCLK_Neg = bclk_trg[2] & ~bclk_trg[1];           // выделенный задний фронт BCLK
     
reg [2:0] lrclk_trg;

always @(posedge Clk)
    lrclk_trg <= { lrclk_trg[1:0], LRClk };
wire LRClk_S = lrclk_trg[1];                  // синхронизированный LRCLK
wire LRCLK_PRV = lrclk_trg[2];                  // предыдущее значение LRCLK
wire LRClk_Change = lrclk_trg[2] ^ lrclk_trg[1];            // любое измененение LRCLK
     
// вычисление указателя, защелкивание данных для выхода на ЦАП
always @(posedge Clk)
begin
    if (LRClk_Change) begin //LRClk is changed
        bit_cnt <= (SAMPLE_WIDTH-1);
        actualLR <= ~LRClk_S;
    end
    else if (BCLK_Neg) begin //BClk is changed
        actualLR <= LRClk_S;
                 
        bit_cnt <= bit_cnt + 1'b1;
            if (bit_cnt == (SAMPLE_WIDTH-1))
            begin
                lb <= LeftIn;
                rb <= RightIn;
            end                 
    end
end

endmodule