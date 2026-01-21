module branch_comp(
    input [31:0] data1,
    input [31:0] data2,
    input BrUn,
    output BrEq,
    output BrLt
);

    // Combinational Logic Assign Statements

    // Check if Branches are Equal
    assign BrEq = (data1 == data2);

    // Check if Branches are Less Than (Depending on Signed/Unsigned)
    assign BrLt = BrUn ? (data1 < data2) : ($signed(data1) < $signed(data2));

endmodule