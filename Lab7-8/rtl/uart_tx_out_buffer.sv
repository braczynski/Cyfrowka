module uart_tx_out_buffer( 
    
    input logic rst_n,
    input logic clk,
    input logic tx_done_tick_in,
    input logic tx_in,
   
    output logic tx_out,
    output logic tx_done_tick_out
);

always_ff @(posedge clk, negedge rst_n) begin
    if(!rst_n) begin
        tx_out <= 0;
        tx_done_tick_out <= 0;
    end 
    else begin
        tx_out <= tx_in;
        tx_done_tick_out <=  tx_done_tick_in;
    end
end
endmodule
