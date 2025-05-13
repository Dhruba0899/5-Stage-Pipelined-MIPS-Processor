module Processor(
    input clk,
    input reset
    );
   wire [31:0] IC, PipeIC, ALUres, A, B, C, D, DataExtended, ReadData;
   wire [3:0] ALUop;
   wire [4:0] WR;
   wire ALUsrc, RegWrite, jump, RegDst, MemRead, MemWrite, MemtoReg,zero, Stall;
   reg [31:0] PC;
   reg [127:0] IF_ID, ID_EX, EX_MEM, MEM_WB;
   wire ALUsrc_ID, RegDst_ID,MemRead_ID, MemWrite_EX, MemRead_EX, RegWrite_EX, RegWrite_WB, MemtoReg_WB;
   wire [3:0] ALUop_ID;
   wire [4:0] WR_WB, ID_EX_RegisterRs, ID_EX_RegisterRt, EX_MEM_RegisterRd, MEM_WB_RegisterRd, IF_ID_RegisterRs, IF_ID_RegisterRt ;
   wire [31:0] DataExtended_ID, A_ID, B_ID;
   wire [31:0] ALUres_EX, B_EX, ReadData_WB, ALUres_WB;
   wire [31:0] A_FU_In;
   reg [31:0] A_FU, B_FU;
   wire [1:0] ForwardRs, ForwardRt;
   reg [4:0] Rs_EX_stage;
   reg [4:0] Rt_EX_stage;
   // Instruction Fetch
   always @ (negedge clk, negedge reset) begin
        if(reset == 0) begin
            PC <= 0;
        end
        else begin
            if(Stall) begin
                PC <= PC;
                IF_ID <= IF_ID;
            end
            else begin
                if(jump) begin
                    PC <= ({PC[31:28], PipeIC[25:0], 2'b00});
                    //IF_ID <= 0;
                end else begin 
                    PC <= PC+4;
                end
             end
           end
         end 
   InstructionMemory mem (PC, reset, IC);
   //
   
   always @ (posedge clk, negedge reset) begin
    if (reset == 0) begin
        IF_ID <= 0;
        ID_EX <= 0;
        EX_MEM <= 0;
        MEM_WB <= 0;
    end
    
    else begin 
        IF_ID[31:0] <= IC;
        ID_EX[4:0] <= PipeIC[15:11];
        ID_EX[9:5] <= IF_ID_RegisterRt;
        ID_EX[116:112] <= IF_ID_RegisterRs; //Forwarding ID_EX_RS
        ID_EX[37:6] <= DataExtended;
        ID_EX[69:38] <= B;
        ID_EX[101:70] <= A;
        ID_EX[105:102] <= Stall ? 0 : ALUop;
        ID_EX[106] <= Stall ? 0 : ALUsrc;
        ID_EX[107] <= Stall ? 0 : RegWrite;
        ID_EX[108] <= Stall ? 0 : RegDst;
        ID_EX[109] <= Stall ? 0 : MemRead;
        ID_EX[110] <= Stall ? 0 : MemWrite;
        ID_EX[111] <= Stall ? 0 : MemtoReg;
        EX_MEM[4:0] <= WR;
        EX_MEM[36:5] <= B_FU;
        EX_MEM[68:37] <= ALUres;
        EX_MEM[69] <= ID_EX[107]; //RegWrite
        EX_MEM[70] <= ID_EX[109]; //MemRead 
        EX_MEM[71] <= ID_EX[110]; //MemWrite 
        EX_MEM[72] <= ID_EX[111]; //MemtoReg
        MEM_WB[4:0] <= EX_MEM[4:0]; // WR 
        MEM_WB[36:5] <= ALUres_EX; // ALUres 
        MEM_WB[68:37] <= ReadData;
        MEM_WB[69] <= EX_MEM[69]; //RegWrite
        MEM_WB[70] <= EX_MEM[72]; //MemtoReg  
    end 
    end
    always @(posedge clk or negedge reset) begin
    if (!reset) begin
        Rs_EX_stage <= 0;
        Rt_EX_stage <= 0;
    end else if (!Stall && !jump) begin
        Rs_EX_stage <= IF_ID[25:21];  // or PipeIC[25:21]
        Rt_EX_stage <= IF_ID[20:16];
    end
end
   assign PipeIC = IF_ID[31:0];
   assign ALUsrc_ID = ID_EX[106];
   assign RegDst_ID = ID_EX[108];
   assign ALUop_ID = ID_EX[105:102];
   assign A_ID = ID_EX[101:70];
   assign B_ID = ID_EX[69:38];
   assign DataExtended_ID = ID_EX[37:6];
   assign ALUres_EX = EX_MEM[68:37];
   assign B_EX = EX_MEM[36:5];
   assign MemWrite_EX = EX_MEM[71];
   assign MemRead_EX = EX_MEM[70];
   assign RegWrite_EX = EX_MEM[69];
   assign ReadData_WB = MEM_WB[68:37];
   assign ALUres_WB = MEM_WB[36:5];
   assign RegWrite_WB = MEM_WB[69];
   assign MemtoReg_WB = MEM_WB[70];
   assign WR_WB = MEM_WB[4:0];
   assign ID_EX_RegisterRs = ID_EX[116:112];
   assign ID_EX_RegisterRt = ID_EX[9:5]; 
   assign EX_MEM_RegisterRd = EX_MEM[4:0];
   assign MEM_WB_RegisterRd = MEM_WB[4:0];
   assign A_FU_In = A_FU;
   assign IF_ID_RegisterRs = IF_ID[25:21];
   assign IF_ID_RegisterRt = IF_ID[20:16];
   assign MemRead_ID = ID_EX[109];
   
   HazardUnit HU (ID_EX_RegisterRt, IF_ID_RegisterRs, IF_ID_RegisterRt, MemRead_ID, Stall); 
   ForwardingUnit FU (Rs_EX_stage, Rt_EX_stage, EX_MEM_RegisterRd, MEM_WB_RegisterRd, RegWrite_EX, RegWrite_WB, ForwardRs, ForwardRt);
   Controller con ( PipeIC[31:26],PipeIC[5:0], ALUop, ALUsrc, RegWrite, jump, RegDst, MemRead, MemWrite, MemtoReg);
   assign WR = RegDst_ID ? ID_EX[4:0] : ID_EX[9:5]; // Choose write register
   always @(*) begin // Forwarding Muxes
    case(ForwardRs)
        2'b00 : A_FU = A_ID;
        2'b01 : A_FU = ALUres_EX;
        2'b10 : A_FU = D;
    endcase
    
    case(ForwardRt) 
        2'b00 : B_FU = B_ID;
        2'b01 : B_FU = ALUres_EX;
        2'b10 : B_FU = D;
    endcase
   end
   
   RegFile RF ( PipeIC[25:21], PipeIC[20:16], WR_WB, D, A, B, clk, RegWrite_WB, reset);
   assign DataExtended = { { (16) {PipeIC[15]}}, PipeIC[15:0]}; 
   
   assign C = ALUsrc_ID ? DataExtended_ID : B_FU; // choose ALU input
   
   ALU aloo ( A_FU_In, C, ALUop_ID, zero, ALUres);
   
   DMEM dmem (clk, ALUres_EX, B_EX, reset, MemRead_EX, MemWrite_EX, ReadData);
   
   assign D = MemtoReg_WB ? ReadData_WB : ALUres_WB; // choose write back data
   
endmodule
