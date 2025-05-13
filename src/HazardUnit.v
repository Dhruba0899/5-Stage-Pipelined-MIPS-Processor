module HazardUnit(
    input [4:0] ID_EX_RegisterRt,
    input [4:0] IF_ID_RegisterRs,
    input [4:0] IF_ID_RegisterRt,
    input MemRead_ID,
    output reg Stall
    );
    
    always @(*) begin
    if (MemRead_ID && ((ID_EX_RegisterRt == IF_ID_RegisterRs) || (ID_EX_RegisterRt == IF_ID_RegisterRt))) begin
        Stall = 1;
    end else begin
        Stall = 0;
    end
end

endmodule
