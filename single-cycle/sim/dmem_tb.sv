module dmem_tb();

    parameter DWIDTH = 32;
    parameter AWIDTH = 14;

    reg clk;
    reg [DWIDTH/8-1:0] wbe;
    reg [AWIDTH-1:0] addr;
    reg [DWIDTH-1:0] dataw;
    wire [DWIDTH-1:0] datar;

    dmem #(
        .DWIDTH(DWIDTH),
        .AWIDTH(AWIDTH)
    ) dmem (
        .clk(clk),
        .wbe(wbe),
        .addr(addr),
        .dataw(dataw),
        .datar(datar)
    );

    initial begin
        $dumpfile("dmem_tb.fst");
        $dumpvars(0, dmem_tb);

        clk = 0;
        wbe = 4'b0000;

        assert (dmem.mem[0] == 0) else $error("Initial memory value is not 0");

        #1;
        wbe = 4'b1111;
        addr = 0;
        dataw = 32'hdeadbeef;
        
        @(posedge clk); #1;
        assert (dmem.mem[0] == 32'hdeadbeef) else $error("Memory value is not 32'hdeadbeef");

        wbe = 4'b0001;
        addr = 1;
        dataw = 32'hcafebabe;

        @(posedge clk); #1;
        assert (dmem.mem[1] == 32'h000000be) else $error("Memory value is not 32'h000000be");

        wbe = 4'b0011;
        addr = 1;
        dataw = 32'hffffffff;

        @(posedge clk); #1;
        assert (dmem.mem[1] == 32'h0000ffff) else $error("Memory value is not 32'h0000ffff");

        wbe = 4'b0000;
        addr = 0;

        assert (datar == 32'hdeadbeef) else $error("asynchronous read failed");

        $display("All tests passed");

        $finish;
    end

    always #5 clk = ~clk;

endmodule