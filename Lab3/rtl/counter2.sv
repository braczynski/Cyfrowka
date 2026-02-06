/* Copyright (C) 2025  AGH University of Krakow */

module counter2     (
    input  logic       clk,
    input  logic       rst_n,
    input  logic       enabled,
    output logic [3:0] value_low,
    output logic [3:0] value_high,
    output logic       overflow
);

    logic overflow_low;

    // Pierwszy licznik (młodsze 4 bity)
    counter counter_low (
        .clk,
        .rst_n,
        .enabled,
        .value      (value_low),
        .overflow   (overflow_low)
    );

    // Drugi licznik (starsze 4 bity) - enabled przez overflow pierwszego
    counter counter_high (
        .clk,
        .rst_n,
        .enabled    (overflow_low),
        .value      (value_high),
        .overflow   (overflow)
    );


endmodule
