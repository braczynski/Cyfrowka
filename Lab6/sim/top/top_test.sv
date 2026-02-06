
module top_test;
    timeunit 1ns;
    timeprecision 1ps;

    // --- Deklaracja sygnałów ---
    logic        clk;
    logic        rst_n;
    logic  [3:0] digit0;
    logic  [3:0] digit1;
    logic  [3:0] digit2;
    logic  [3:0] digit3;

    logic [3:0] sseg_an;
    logic [6:0] sseg_ca;

    // --- Instancja testowanego modułu (DUT - Device Under Test) ---
    top dut (
        .clk      (clk),
        .rst_n    (rst_n),
        .digit0   (digit0),
        .digit1   (digit1),
        .digit2   (digit2),
        .digit3   (digit3),
        .sseg_an  (sseg_an),
        .sseg_ca  (sseg_ca)
    );

    // --- Generowanie zegara ---
    // Zegar 100MHz (okres 10ns)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // --- Blok stymulacji (Test Scenarios) ---
    initial begin
        // 1. Inicjalizacja
        $display("Start symulacji...");
        rst_n = 0;      // Aktywny reset
        digit0 = 4'h0;
        digit1 = 4'h0;
        digit2 = 4'h0;
        digit3 = 4'h0;

        // 2. Zwolnienie resetu po chwili
        #100;
        rst_n = 1;
        $display("Reset zwolniony.");

        #20;
        digit3 = 4'h1;
        digit2 = 4'h2;
        digit1 = 4'h3;
        digit0 = 4'h4;
        
        #200;

        $display("Zmiana wejść na A, B, C, D");
        digit3 = 4'hA;
        digit2 = 4'hB;
        digit1 = 4'hC;
        digit0 = 4'hD;

        #500;

        #500;

        #3_000_000_0;

        $display("Koniec symulacji.");
        $finish;
    end
    
    initial begin
        $monitor("Czas=%t | Rst=%b | Digits=%h%h%h%h | Anodes=%b | Cathodes=%b", 
                 $time, rst_n, digit3, digit2, digit1, digit0, sseg_an, sseg_ca);
    end

endmodule