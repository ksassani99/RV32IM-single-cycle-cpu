module alu(
    input [31:0] A,
    input [31:0] B,
    input [3:0] ALUSel,
    output reg [31:0] result
);

    // Op Codes
    localparam ADD = 4'd0;
    localparam SUB = 4'd12;

    localparam AND = 4'd7;
    localparam OR = 4'd6;
    localparam XOR = 4'd4;

    localparam SLL = 4'd1;  // Shift Left Logical
    localparam SRL = 4'd5;  // Shift Right Logical
    localparam SRA = 4'd13; // Shift Right Arithmetic (Signed)

    localparam SLT  = 4'd2; // Set Less Than
    localparam SLTU = 4'd3; // Set Less Than Unsigned

    localparam MUL    = 4'd8;  // Multiply
    localparam MULH   = 4'd9;  // Multiply High (Signed)
    localparam MULHSU = 4'd10; // Multiply High Signed and Unsigned
    localparam MULHU  = 4'd11; // Multiply High Unsigned

    localparam BSEL = 4'd15; // Used for LUI (Pass B)

    // Combinational Logic Always Block
    always @(*) begin
        case (ALUSel)
            ADD: result = A + B;
            SUB: result = A - B;
            AND: result = A & B;
            OR: result = A | B;
            XOR: result = A ^ B;
            SLL: result = A << B[4:0];
            SRL: result = A >> B[4:0];
            SRA: result = $signed(A) >>> B[4:0];
            SLT: result = ($signed(A) < $signed(B)) ? 32'd1 : 32'd0;
            SLTU: result = (A < B) ? 32'd1 : 32'd0;
            MUL: result = A * B;
            MULH: result = ({{32{A[31]}}, A} * {{32{B[31]}}, B}) >> 32;
            MULHSU: result = ({{32{A[31]}}, A} * {32'b0, B}) >> 32;
            MULHU: result = ({32'b0, A} * {32'b0, B}) >> 32;
            BSEL: result = B;
            default: result = 32'd0;
        endcase
    end
endmodule