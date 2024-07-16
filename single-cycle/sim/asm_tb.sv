module asm_tb();

    reg clk, rst;

    // dut
    core CORE (.clk(clk), .rst(rst));

    integer num_mismatch = 0;

    initial begin
        clk = 0;
        $readmemh("test_asm.hex", CORE.IMEM.mem);
        // $display("IMEM[0] = %h", CORE.IMEM.mem[0]);
        // $monitor("[TIME %t] PC=%h instr=%h rf_we=%b",
        //           $time, CORE.pc, CORE.instr, CORE.rf_we);
    end

    initial begin
        $dumpfile("asm_tb.fst");
        $dumpvars(0, asm_tb);
        rst = 1;

        repeat (2) @(posedge clk);
        rst = 0;

        repeat(5) @(posedge clk); #1;

        assert (CORE.RF.registers[0] == 32'd0)
            else begin
                $error("x0 expect: %d actual: %d",
                        32'd0, CORE.RF.registers[0]);
                num_mismatch = num_mismatch + 1;
            end

        assert (CORE.RF.registers[1] == 32'd5)
            else begin
                $error("x1 expect: %d actual: %d",
                        32'd5, CORE.RF.registers[1]);
                num_mismatch = num_mismatch + 1;
            end
                    
        assert (CORE.RF.registers[2] == 32'd10)
            else begin
                $error("x2 expect: %d actual: %d",
                        32'd10, CORE.RF.registers[2]);
                num_mismatch = num_mismatch + 1;
            end

        assert (CORE.RF.registers[3] == 32'd10)
            else begin
                $error("x2 expect: %d actual: %d",
                        32'd10, CORE.RF.registers[3]);
                num_mismatch = num_mismatch + 1;
            end

        assert (CORE.DMEM.mem[0] == 32'd10)
            else begin
                $error("dmem[0] expect: %d actual: %d",
                        32'd10, CORE.DMEM.mem[0]);
                num_mismatch = num_mismatch + 1;
            end

        if (num_mismatch == 0)
            $display("All tests passed");
        else
            $display("%d tests failed", num_mismatch);

        $finish;
    end

    always #5 clk = ~clk;

endmodule