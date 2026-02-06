/* Copyright (C) 2025 AGH University of Krakow */

module fsm #(
    parameter logic [7:0] MAX_COUNT = 8'hB,
    parameter logic [7:0] OUTPUT_COUNT = 8'h27
) (
    input logic clk,
    input logic rst_n,
    input logic en,
    output logic done,
    output logic led,
    input logic trigger
);


/* User defined types and constants */

typedef enum logic [1:0] {
    IDLE,
    ACTIVE,
    BLINK
} state_t;


/* Local variables and signals */

state_t state, state_nxt;
logic [7:0] counter, counter_nxt;


/* Module internal logic */

/* State Sequencer Logic */
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        counter <= 8'b0;
    end else begin
        state <= state_nxt;
        counter <= counter_nxt;
    end
end

/* Next State Decode Logic */
always_comb begin
    state_nxt = state;
    counter_nxt = counter;

    case (state)
        IDLE: begin
            if (trigger) begin
                state_nxt = ACTIVE;
            end
        end
        ACTIVE: begin
            if (counter == MAX_COUNT) begin
                state_nxt = BLINK;
                counter_nxt = 8'b0;
            end else begin
                counter_nxt = counter + 1;
            end
        end
        BLINK: begin
            if (counter == OUTPUT_COUNT) begin
                state_nxt = IDLE;
                counter_nxt = 8'b0;
            end else begin
                counter_nxt = counter + 1;
            end
        end
    endcase
end

/* Output Decode Logic */
always_comb begin
    done = 1'b0;
    led = 1'b0;

    case (state)
        IDLE: ;
        ACTIVE: ;
        BLINK: begin 
            if(counter < 5) begin
                done = 1'b1;
            end
            led = counter[2] & en;
        end
    endcase
end

endmodule
