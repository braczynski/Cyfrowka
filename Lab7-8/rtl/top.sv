module top #( parameter logic [27:0] BITRATE = 115200,
        parameter logic [27:0] CORE_FREQ = 100_000_000,
        parameter logic [27:0] UART_FREQ = (CORE_FREQ / (BITRATE*16)),
        parameter logic [27:0] UART_START_FREQ = (UART_FREQ + 2000))(
    input logic clk,
    input logic rst_n,
    input logic [7:0] din,

    input logic rx,     
    input logic sw,  

    output logic tx,
    output logic tx_buf,
    output logic tx_done_tick_buf,

    output logic [7:0] rx_dout,   
    output logic rx_done_tick, 
    output logic db_level,           
    output logic db_tick            
);

logic [27:0] counter_value1;
logic [27:0] counter_value2;
logic s_tick;
logic tx_start;
logic tx_done_tick;

counter #(.MAX_VALUE(UART_FREQ)) u_counter_s_tick (
    .clk (clk),
    .rst_n (rst_n),
    .enabled (1),
    .value (counter_value1),
    .overflow(s_tick)
);

counter #(.MAX_VALUE(UART_START_FREQ)) u_counter_tx_start (
    .clk        (clk),
    .rst_n      (rst_n),
    .enabled    (1),
    .value (counter_value2),
    .overflow(tx_start)
);

uart_tx u_uart_tx (
    .clk (clk),
    .rst_n (rst_n),
    .din (din[7:0]),
    .s_tick (s_tick),
    .tx_start(tx_start),
    .tx (tx),
    .tx_done_tick (tx_done_tick)
);

uart_tx_out_buffer u_uart_tx_out_buffer (
    .clk (clk),
    .rst_n (rst_n),
    .tx_in (tx),
    .tx_done_tick_in (tx_done_tick),
    .tx_out (tx_buf),
    .tx_done_tick_out (tx_done_tick_buf)
);

debounce #(.N(22)) u_debounce (
    .clk(clk),
    .rst_n(rst_n),
    .sw(sw),
    .db_level(db_level),
    .db_tick(db_tick)
);

uart_rx #(
    .DBIT(8), 
    .SB_TICK(16)
) u_uart_rx (
    .clk(clk),
    .rst_n(rst_n),
    .rx(rx),
    .s_tick(s_tick),    
    .rx_done_tick(rx_done_tick),
    .dout(rx_dout)
);

endmodule 
