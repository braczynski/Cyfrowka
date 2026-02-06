module hex2sseg (
    input logic [3:0] hex,
    output logic [6:0] sseg
);

// bits for segments  gfedcba
localparam logic [6:0] CODES [0:15] = '{
    7'b1000000, // 0
    7'b1111001, // 1
    7'b0100100, // 2
    7'b0110000, // 3
    7'b0011001, // 4
    7'b0010010, // 5
    7'b0000010, // 6
    7'b1111000, // 7
    7'b0000000, // 8
    7'b0011000, // 9
    7'b0001000, // A  
    7'b0000011, // B  
    7'b1000110, // C  
    7'b0100001, // D  
    7'b0000110, // E  
    7'b0001110  // F  
};

assign sseg = CODES[hex];

endmodule


