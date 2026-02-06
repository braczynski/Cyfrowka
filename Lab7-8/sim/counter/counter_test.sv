/* Copyright (C) 2025  AGH University of Krakow */

module counter_test;


/* Local variables and signals */

logic clk, rst_n;

logic [3:0] value;
logic enabled;


/* Submodules placement */

counter dut (
    .clk,
    .rst_n,
    .enabled,
    .value
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

    for (int i = 0; i < 10; ++i) begin
        assert (value == 4'b0) else begin
            $error("value: exp: %1d, rcv: %1d", 4'b0, value);
        end
        @(negedge clk);
    end
endtask

task test_enabled_counter();
    enabled = 1'b1;

    reset();

    for (int i = 0; i < 10; ++i) begin
        assert (value == i) else begin
            $error("value: exp: %1d, rcv: %1d", i, value);
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

    $finish;
end

endmodule
