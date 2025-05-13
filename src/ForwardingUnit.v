module ForwardingUnit(
 input [4:0] ID_EX_RegisterRs,
 input [4:0] ID_EX_RegisterRt,
 input [4:0] EX_MEM_RegisterRd,
 input [4:0] MEM_WB_RegisterRd,
 input RegWrite_EX,
 input RegWrite_WB,
 output reg [1:0] ForwardRs,
 output reg [1:0] ForwardRt
    ); 
    always @(*) begin
            //ForwardRs = 2'b00;
            //ForwardRt = 2'b00;
        if( RegWrite_EX && (EX_MEM_RegisterRd != 0) && (EX_MEM_RegisterRd == ID_EX_RegisterRs)) begin
            ForwardRs = 2'b01; 
           end
        else if ( RegWrite_WB && (MEM_WB_RegisterRd != 0)&& (MEM_WB_RegisterRd == ID_EX_RegisterRs)) begin 
            ForwardRs = 2'b10;
           end
        else begin
            ForwardRs = 2'b00;
            end  
        if( RegWrite_EX && (EX_MEM_RegisterRd != 0) && (EX_MEM_RegisterRd == ID_EX_RegisterRt)) begin
            ForwardRt = 2'b01;
           end
        else if ( RegWrite_WB && (MEM_WB_RegisterRd != 0) && (MEM_WB_RegisterRd == ID_EX_RegisterRt)) begin
            ForwardRt = 2'b10;
           end
        else begin
            ForwardRt = 2'b00;
           end
    end
endmodule
