module top_basys3 (
    input wire clk,
    input wire btnC,
    input wire [15:0] sw,
    output wire [6:0] seg,
    output wire [3:0] an
);

top u_top(
    .clk(clk),
    .rst_n(!btnC),
    .digit0(sw[3:0]),
    .digit1(sw[7:4]),
    .digit2(sw[11:8]),
    .digit3(sw[15:12]),
    .sseg_ca(seg),
    .sseg_an(an)
);

endmodule
