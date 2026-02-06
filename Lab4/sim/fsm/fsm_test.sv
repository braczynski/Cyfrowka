/* Copyright (C) 2025  AGH University of Krakow */

module fsm_test;


/* Local variables and signals */

localparam logic [7:0] MAX_COUNT = 8'hB;
localparam logic [7:0] OUTPUT_COUNT = 8'h27;

logic clk, rst_n;

logic trigger, done, led, en;


/* Submodules placement */

fsm #(
    .MAX_COUNT(MAX_COUNT),
    .OUTPUT_COUNT(OUTPUT_COUNT)
) dut (
    .clk,
    .rst_n,
    .en,
    .done,
    .led, 
    .trigger
);


/* Tasks and functions definitions */

task reset();
    for (int i = 0; i < 2; ++i) begin
        @(negedge clk);
        rst_n = i[0];
    end
endtask

task test_non_triggered_fsm();
    for (int i = 0; i < 15; ++i) begin
        assert (!done) else begin
            $error("done: exp: %b, rcv: %b", 1'b0, done);
        end
        assert (!led) else begin
            $error("led: exp: %b, rcv: %b", 1'b0, led);
        end
        @(negedge clk);
    end
endtask

task test_triggered_fsm();
    @(negedge clk);
    trigger = 1'b1;

    fork
        begin
            @(negedge clk);
            trigger = 1'b0;
        end
        begin
            for (int i = 0; i < MAX_COUNT; ++i) begin
                @(negedge clk);
                assert (!done) else begin
                    $error("done: exp: %b, rcv: %b", 1'b0, done);
                end
                assert (!led) else begin
                    $error("led: exp: %b, rcv: %b", 1'b0, led);
                end
            end

            @(negedge clk);
            for (int i = 0; i < OUTPUT_COUNT; ++i) begin
                @(negedge clk);
                assert (done) else begin
                    $error("done: exp: %b, rcv: %b", 1'b1, done);
                end
                if((i[2]) && en) begin
                    assert (led) else begin
                        $error("led: exp: %b, rcv: %b", 1'b1, led);
                    end
                end else begin 
                    assert (!led) else begin
                        $error("led: exp: %b, rcv: %b", 1'b0, led);
                    end
                end
            end

            @(negedge clk);
            assert (!done) else begin
                $error("done: exp: %b, rcv: %b", 1'b0, done);
            end
            assert (!led) else begin
                $error("led: exp: %b, rcv: %b", 1'b0, led);
            end

            @(negedge clk);
        end
    join
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
    trigger = 1'b0;
    en = 1'b0;

    reset();

    test_non_triggered_fsm();
    test_triggered_fsm();

    en = 1'b1;
    reset();

    test_non_triggered_fsm();
    test_triggered_fsm();

    $finish();
end

endmodule
