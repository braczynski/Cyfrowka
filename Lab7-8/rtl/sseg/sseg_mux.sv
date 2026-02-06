module sseg_mux (
    input  wire  [3:0] sel, // single zero will select the input
    input  wire  [3:0] digit0,
    input  wire  [3:0] digit1,
    input  wire  [3:0] digit2,
    input  wire  [3:0] digit3,
    output logic [3:0] digit_selected
);

always_comb begin
    case(sel)
        4'b1110: digit_selected = digit0;
        4'b1101: digit_selected = digit1;
        4'b1011: digit_selected = digit2;
        4'b0111: digit_selected = digit3;
        default: digit_selected = 4'bxxxx;
    endcase
end

endmodule
