module top_led (
    input  wire       clk,
    input  wire       rst_n,
    // Assuming 4-bit inputs for hex digits 0-F
    input  wire [3:0] digit0,
    input  wire [3:0] digit1,
    input  wire [3:0] digit2,
    input  wire [3:0] digit3,
    
    // 7-segment display outputs
    output wire [3:0] sseg_an, // Anodes
    output wire [6:0] sseg_ca  // Cathodes
);

    // Internal wire for the connection between counter and sseg
    // and the feedback loop to the counter itself.
    wire counter_overflow;
    logic enable_c = '1;
    
    // Wire for the unconnected counter value output
    wire [31:0] counter_value; 

    counter u_counter (
        .clk      (clk),
        .rst_n    (rst_n),
        .enabled  (enable_c), 
        .value    (counter_value),    // Unconnected in diagram
        .overflow (counter_overflow)
    );

    // Instantiate the 7-segment display driver module
    sseg u_sseg (
        .clk      (clk),
        .rst_n    (rst_n),
        .enabled  (counter_overflow),
        .digit0   (digit0),
        .digit1   (digit1),
        .digit2   (digit2),
        .digit3   (digit3),
        .sseg_an  (sseg_an),
        .sseg_ca  (sseg_ca)
    );

endmodule