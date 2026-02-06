/* Copyright (C) 2025  AGH University of Krakow */

module counter (
    input logic clk,
    input logic rst_n,
    input logic enabled,
    output logic [3:0] value
);


/* Local variables and signals */

logic [3:0] value_nxt;


/* Module internal logic */

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        value <= 4'b0;
    end else begin
        value <= value_nxt;
    end
end

always_comb begin
    value_nxt = value;

    if (enabled) begin
        value_nxt = value + 1;
    end
end

endmodule
