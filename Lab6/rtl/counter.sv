/* Copyright (C) 2025  AGH University of Krakow */

module counter #(
    parameter logic [20:0] MAX_VALUE = 21'h7A120
)(
    input logic clk,
    input logic rst_n,
    input logic enabled,
    output logic [20:0] value,
    output logic overflow
);


/* Local variables and signals */

logic [20:0] value_nxt;
logic overflow_nxt; 


/* Module internal logic */

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        value <= 4'b0;
        overflow <= 'b0;
    end else begin
        value <= value_nxt;
        overflow <= overflow_nxt;
    end
end

always_comb begin
    value_nxt = value;

    if (enabled) begin
        value_nxt = value + 1;
    end

    if(value == MAX_VALUE) begin 
        value_nxt = 0;
        overflow_nxt = 1;
    end else begin
        overflow_nxt = 0;
    end
end

endmodule
