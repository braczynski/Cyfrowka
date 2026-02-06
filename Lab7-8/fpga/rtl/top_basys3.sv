module top_basys3 (
    input wire clk,
    input wire btnC,
    input wire btnU, 
    input wire RsRx,
    input wire [15:0] sw,
    output wire [6:0] seg,
    output wire [3:0] an,
    output wire [1:0] JB,
    output wire [15:0] led,
    output wire RsTx
);

wire [7:0] rx_byte;      // Odebrany bajt danych
wire rx_done;            // Impuls po odebraniu danych
wire db_out_tick;        // Impuls po wciśnięciu przycisku (odszumiony)
wire db_out_level;       // Poziom przycisku (odszumiony)

top_led u_top_led(
    .clk(clk),
    .rst_n(!btnC),
    .digit0(sw[3:0]),
    .digit1(sw[7:4]),
    .digit2(sw[11:8]),
    .digit3(sw[15:12]),
    .sseg_ca(seg),
    .sseg_an(an)
);

top u_top(
    .clk (clk),
    .din (sw[7:0]),
    .rst_n (!btnC),
    .tx (RsTx),
    .tx_done_tick_buf (JB[0]),
    .tx_buf (JB[1]),
    .rx (RsRx),
    .sw (btnU),           
    .rx_dout (rx_byte),  
    .rx_done_tick (rx_done), 
    .db_tick (db_out_tick),  
    .db_level (db_out_level)
);

assign led[0] = rx_done;      // Mignie, gdy przyjdą dane z PC
assign led[1] = db_out_tick;  // Mignie, gdy wciśniesz btnU (po debounce)
assign led[2] = db_out_level; // Świeci, gdy trzymasz btnU (stabilnie)
assign led[7:3] = 0;          // Nieużywane
assign led[15:8] = rx_byte;   // Binarny podgląd odebranego bajtu na diodach

endmodule
