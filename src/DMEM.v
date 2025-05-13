module DMEM(
    input clk,
    input [31:0] address,
    input [31:0] WriteData,
    input reset,
    input MemRead,
    input MemWrite,
    output reg [31:0] ReadData
    );
    integer i;
    wire [31:0] calc;
    assign calc = address << 2;
    reg [7:0] Dmem[255:0];
    always @ (negedge reset) begin
        Dmem[0] = 8'd0;
        Dmem[1] = 8'd0;
        Dmem[2] = 8'd0;
        Dmem[3] = 8'd9;
        Dmem[4] = 8'd0;
        Dmem[5] = 8'd0;
        Dmem[6] = 8'd0;
        Dmem[7] = 8'd1;
        for(i = 8; i < 256; i = i + 1) begin
                Dmem[i] = 8'd0;
           end
        end
        
    always @(*) begin 
        if(MemRead) begin
            ReadData = {Dmem[calc],Dmem[calc+1],Dmem[calc+2],Dmem[calc+3]};
           end 
    end
    
    always @(negedge clk) begin
        if(MemWrite) begin
            Dmem[calc] = WriteData[31:24];
            Dmem[calc+1] = WriteData[23:16];
            Dmem[calc+2] = WriteData[15:8];
            Dmem[calc+3] = WriteData[7:0];
        end
    end
endmodule
