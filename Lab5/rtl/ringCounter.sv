/* Copyright (C) 2025  AGH University of Krakow */

module ringCounter #(
    parameter SIZE = 7,    
    parameter logic BICIK = 1

) (
    input logic clk,
    input logic rst_n,
    input logic enabled,
    output logic [SIZE-1:0] value
);


/* Local variables and signals */



logic [SIZE-1:0] value_nxt;


/* Module internal logic */

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        value <= BICIK ? {1'b1, {SIZE-1{1'b0}}} : {1'b0, {SIZE-1{1'b1}}};  
    end else begin
        value <= value_nxt;
    end
end

always_comb begin
    value_nxt = value;

    if (enabled) begin 
        value_nxt = {value[0], value[SIZE-1:1]};
    end
end

endmodule
