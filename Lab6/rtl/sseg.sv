module sseg (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       enabled,
    input  wire [3:0] digit0,
    input  wire [3:0] digit1,
    input  wire [3:0] digit2,
    input  wire [3:0] digit3,
    output wire [3:0] sseg_an, 
    output wire [6:0] sseg_ca  
);

    wire [3:0] value;           
    wire [3:0] digit_selected;  

    ring_counter #(
        .SIZE(4),    
        .BICIK(0)
    ) u_ring_counter (
        .clk     (clk),
        .rst_n   (rst_n),
        .enabled (enabled),
        .value   (value)
    );

    sseg_mux u_sseg_mux (
        .digit0         (digit0),
        .digit1         (digit1),
        .digit2         (digit2),
        .digit3         (digit3),
        .sel            (value),          
        .digit_selected (digit_selected)
    );

    hex2sseg u_hex2sseg (
        .hex  (digit_selected),
        .sseg (sseg_ca)
    );

    assign sseg_an = value;

endmodule