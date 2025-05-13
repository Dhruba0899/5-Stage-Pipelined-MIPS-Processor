module InstructionMemory(
    input [31:0] PC,
    input reset,
    output [31:0] Instruction_Code 
    );
    reg [7:0] mem[36:0];
    assign Instruction_Code = {mem[PC], mem[PC+1],mem[PC+2],mem[PC+3]};
    always @(reset) begin
        if(reset == 0) begin
            mem[0]= 8'h8C; mem[1] = 8'h01; mem[2] = 8'h00; mem[3] = 8'h00; // lw r1, 0(r0)
            mem[4] = 8'h8C; mem[5] = 8'h02; mem[6] = 8'h00; mem[7] = 8'h01; // lw r2, 1(r0)
            mem[8] = 8'h00; mem[9] = 8'h22; mem[10] = 8'h08; mem[11] = 8'h18; // mul r1,r1,r2
            mem[12] = 8'h08; mem[13] = 8'h00; mem[14] = 8'h00; mem[15] = 8'h05; //j L
            mem[16] = 8'h00; mem[17] = 8'h22; mem[18] = 8'h10; mem[19] = 8'h18; // mul r2, r1,r2
            
             //L :
            mem[20] = 8'h04; mem[21] = 8'h26; mem[22] = 8'h00; mem[23] = 8'h03; // srl r6, r1, 3
            mem[24] = 8'hAC; mem[25] = 8'h06; mem[26] = 8'h00; mem[27] = 8'h04; // sw r6, 4(r0)   
           end
          end
endmodule
