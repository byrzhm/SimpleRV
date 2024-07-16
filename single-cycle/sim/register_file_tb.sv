module register_file_tb();

    reg clk, we;
    reg [4:0] addrA, addrB, addrD;
    reg [31:0] dataD;
    wire [31:0] dataA, dataB;

    // dut
    register_file rf (
        .clk(clk),
        .we(we),
        .addrA(addrA),
        .addrB(addrB),
        .addrD(addrD),
        .dataD(dataD),
        .dataA(dataA),
        .dataB(dataB)
    );

    initial begin

        $dumpfile("register_file_tb.fst");
        $dumpvars(0, register_file_tb);

        clk = 0;
        we = 0;
        addrA = 0;
        addrB = 0;
        addrD = 0;
        dataD = 0;

        repeat (2) @(posedge clk);

        if (dataA !== 32'h0 || dataB !== 32'h0)
            $error("dataA expected 0, got %h; dataB expected 0, got %h", dataA, dataB);

        we = 1;
        addrD = 5;
        addrA = 5;
        dataD = 32'hdeadbeef;

        @ (posedge clk); #1;
        if (dataA !== 32'hdeadbeef)
            $error("dataA expected deadbeef, got %h", dataA);

        we = 0;
        addrB = 5;
        // asynchroneous read, should immediately read the new value
        if (dataB !== 32'hdeadbeef)
            $error("dataB expected deadbeef, got %h", dataB);

        we = 1;
        addrA = 0;
        addrD = 0;
        dataD = 32'hffffffff;

        @ (posedge clk); #1;
        if (dataA !== 32'h00000000)
            $error("x0 is wired to 0, dataA expected 00000000, got %h", dataA);

        $display("Testbench passed");
        $finish;
    end

    always #5 clk = ~clk;

endmodule
