module RegFile(
    input [4:0] Read_Reg_Num_1,
    input [4:0] Read_Reg_Num_2,
    input [4:0] Write_Reg_Num,
    input [31:0] Write_Data,
    output reg [31:0] Read_Data_1,
    output reg [31:0] Read_Data_2,
    input clk,
    input RegWrite, 
    input reset
    );
    integer i;
    reg [31:0] RegMem [31:0];
     always @ (negedge reset) begin
        for(i = 0; i < 32; i = i + 1) begin
                RegMem[i] = 32'b0;
           end
            
        end
        
      always @(*) begin
        Read_Data_1 = RegMem[Read_Reg_Num_1];
        Read_Data_2 = RegMem[Read_Reg_Num_2];
    end
        always @(negedge clk) begin
        if (RegWrite) begin
            RegMem[Write_Reg_Num] <= Write_Data;
        end
    end
endmodule
