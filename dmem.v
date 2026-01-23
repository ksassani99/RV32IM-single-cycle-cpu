module dmem(
    input clk,                // clock input
    input MemRW,              // memory read/write enable signal
    input [31:0] addr,        // address input
    input [31:0] dataW,       // data input (for potential writing)
    input [3:0] MemWriteMask, // comes from partial_store, tells memory which bytes to overwrite
    output [31:0] dataR       // data read output
);

    // 64KB Memory: 16,384 words of 32 bits each (Using Verilog Array)
    reg [31:0] ram [0:16383];

    // Address Transformation:
    // 1. Discard top 16 bits (only dealing with bottom 16 bits)
    // 2. Discard bottom 2 bits (word alignment, dividing by 4)
    // Result: Using bits [15:2] to index array
    wire [13:0] word_addr = addr[15:2];

    // Asynchronous Read
    // This reads the full 32-bit word
    // If want a byte (lb), partial_load handles slicing later
    assign dataR = ram[word_addr];

    // Synchronous Write
    // Simultaneous writing of multiple bits (if specified by MemWriteMask) at once
    always @(posedge clk) begin
        if (MemRW) begin
            // Byte 0 (Lowest 8 bits)
            if (MemWriteMask[0]) ram[word_addr][7:0] <= dataW[7:0];

            // Byte 1
            if (MemWriteMask[1]) ram[word_addr][15:8] <= dataW[15:8];

            // Byte 2
            if (MemWriteMask[2]) ram[word_addr][23:16] <= dataW[23:16];

            // Byte 3 (Highest 8 bits)
            if (MemWriteMask[3]) ram[word_addr][31:24] <= dataW[31:24];
        end
    end

endmodule