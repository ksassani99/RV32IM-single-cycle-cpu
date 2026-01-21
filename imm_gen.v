module imm_gen(
    input [31:0] inst,
    input [2:0] ImmSel,
    output reg [31:0] imm
);

    // Available Formats
    localparam I = 3'd0;
    localparam S = 3'd1;
    localparam B = 3'd2;
    localparam U = 3'd3;
    localparam J = 3'd4;

    // Combinational Logic Always Block
    always @(*) begin
        case (ImmSel)
            I: imm = {{20{inst[31]}}, inst[31:20]};
            S: imm = {{20{inst[31]}}, inst[31:25], inst[11:7]};
            B: imm = {{19{inst[31]}}, inst[31], inst[7], inst[30:25], inst[11:8], 1'b0};
            U: imm = {inst[31:12], 12'b0};
            J: imm = {{11{inst[31]}}, inst[31], inst[19:12], inst[20], inst[30:21, 1'b0]};
        endcase
    end
endmodule