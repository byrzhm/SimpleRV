module imem_tb();

    parameter DWIDTH = 32;
    parameter AWIDTH = 4;

    reg [AWIDTH-1:0] addr;
    wire [DWIDTH-1:0] instr;

    imem #(
        .DWIDTH(DWIDTH),
        .AWIDTH(AWIDTH)
    ) imem (
        .addr(addr),
        .instr(instr)
    );

    integer i;
    integer num_mismatch = 0;

    initial begin
        $dumpfile("imem_tb.fst");
        $dumpvars(0, imem_tb);

        addr = 0;
        if (instr !== 32'h0) begin
            $error("addr 0 should be 0, got %h", instr);
            num_mismatch = num_mismatch + 1;
        end
        
        #1;
        addr = 1;
        if (instr !== 32'h1) begin
            $error("addr 4 should be 1, got %h", instr);
            num_mismatch = num_mismatch + 1;
        end

        if (num_mismatch == 0)
            $display("All tests passed");
        else
            $display("%d tests failed", num_mismatch);
        $finish;
    end

endmodule