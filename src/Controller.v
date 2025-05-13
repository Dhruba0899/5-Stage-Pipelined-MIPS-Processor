module Controller(
    input [5:0] op,
    input [5:0] funct,
    output reg [3:0] ALUop,
    output ALUsrc,
    output RegWrite,
    output jump,
    output RegDst,
    output MemRead,
    output MemWrite,
    output MemtoReg
    );
    assign RegDst = (op == 6'b100011 || op ==6'b000001) ? 0 : 1;
    assign jump = (op == 6'b000010);
    assign ALUsrc = (op == 6'b100011 || op ==6'b000001 || op == 6'b101011);
    assign RegWrite = (op == 6'b100011 || op ==6'b000001 || op == 6'b000000);
    assign MemWrite = (op == 6'b101011);
    assign MemRead = (op == 6'b100011);
    assign MemtoReg = (op == 6'b100011);
    
    always @(*) begin
        case(op)
            6'b100011 : ALUop = 4'b0000;
            6'b101011 : ALUop = 4'b0001;
            6'b000000 : ALUop = 4'b0010;
            6'b000001 : ALUop = 4'b0011;
            default : ALUop = 4'b0000;
        endcase 
   end
