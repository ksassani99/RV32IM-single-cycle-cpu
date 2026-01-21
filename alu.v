module alu(
    input [31:0] A,
    input [31:0] B,
    input [3:0] ALUSel,
    output reg [31:0] Result
);

    // Op Codes
    localparam ADD = 4'd0;
    localparam SUB = 4'd12;

    localparam AND = 4'd7;
    localparam OR = 4'd6;
    localparam XOR = 4'd4;

    localparam SLL = 4'd1;  // Shift Left Logical
    localparam SRL = 4'd5;  // Shift Right Logical
    localparam SRA = 4'd13; // Shift Right Arithmetic

    localparam SLT  = 4'd2; // Set Less Than
    localparam SLTU = 4'd3; // Set Less Than Unsigned

    localparam MUL    = 4'd8;
    localparam MULH   = 4'd9;
    localparam MULHSU = 4'd10;
    localparam MULHU  = 4'd11;

    localparam BSEL = 4'd15; // Used for LUI (Pass B)

    // Combinational Logic Always Block
    always @(*) begin
        case (ALUSel)
            ADD: Result = A + B;
            SUB: Result = A - B;
            AND: Result = A & B;
            OR: Result = A | B;
            XOR: Result = A ^ B;
            SLL: Result = A << B[4:0];
            SRL: Result = A >> B[4:0];
            SRA: Result = $signed(A) >>> B[4:0];
            SLT: Result = ($signed(A) < $signed(B)) ? 32'd1 : 32'd0;
            SLTU: Result = (A < B) ? 32'd1 : 32'd0;
            MUL: Result = A * B;
            MULH: Result = ({{32{A[31]}}, A} * {{32{B[31]}}, B}) >> 32;
            MULHSU: Result = ({{32{A[31]}}, A} * {32'b0, B}) >> 32;
            MULHU: Result = ({32'b0, A} * {32'b0, B}) >> 32;
            BSEL: Result = B;
            default: Result = 32'd0;
        endcase
    end
endmodule