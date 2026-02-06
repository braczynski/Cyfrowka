/* Copyright (C) 2025  AGH University of Krakow */

module counter2_test;


/* Local variables and signals */

logic clk, rst_n, overflow;
logic [3:0] value_low;
logic [3:0] value_high;
logic enabled;


/* Submodules placement */

counter2 dut (
    .clk,
    .rst_n,
    .enabled,
    .value_low,
    .value_high,
    .overflow
);


/* Tasks and functions definitions */

task reset();
    for (int i = 0; i < 2; ++i) begin
        @(negedge clk);
        rst_n = i[0];
    end
endtask

task test_disabled_counter();
    enabled = 1'b0;

    reset();

    for (int i = 0; i < 20; ++i) begin
        assert (value_low == 4'b0) else begin
            $error("value_low: exp: %1d, rcv: %1d", 4'b0, value_low);
        end

        assert (value_high == 4'b0) else begin
            $error("value_high: exp: %1d, rcv: %1d", 4'b0, value_high);
        end

        assert (overflow == 1'b0) else begin
            $error("overflow: exp: %1d, rcv: %1d (disabled counter)", 1'b0, overflow);
        end
        @(negedge clk);
    end
endtask

task test_enabled_counter();
    enabled = 1'b1;

    reset();

    for (int i = 0; i < 280; ++i) begin

        assert (value_low == (i % 16)) else begin
            $error("value_low: exp: %1d, rcv: %1d", (i % 16), value_low);
        end

        assert (value_high == ((i / 16) % 16)) else begin
            $error("value_high: exp: %1d, rcv: %1d", ((i / 16) % 16), value_high);
        end

        if (value_high == 4'd13) begin
            assert (overflow == 1'b1) else begin
                $error("overflow: exp: %1d, rcv: %1d (at value=255)", 1'b1, overflow);
            end
        end else begin
            assert (overflow == 1'b0) else begin
                $error("overflow: exp: %1d, rcv: %1d (at value=%1d)", 1'b0, overflow, value_high);
            end
        end

        @(negedge clk);
    end


endtask


/* Clock generation */

initial begin
    clk = 1'b0;

    forever begin
        clk = #5ns ~clk;
    end
end


/* Test */

initial begin
    rst_n = 1'b1;
    enabled = 1'b0;

    test_disabled_counter();
    test_enabled_counter();

    repeat(50) begin
        @(negedge clk);
    end

    $finish;
end

endmodule
