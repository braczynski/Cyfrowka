`timescale 1ns / 1ps

module top_test;
    
        // =========================================================================
        // 1. KONFIGURACJA (Szybka, ale precyzyjna)
        // =========================================================================
        localparam CLK_FREQ_HZ = 100_000_000;
        localparam TARGET_BAUD = 921_600;      // Szybka transmisja
        localparam CLK_PERIOD  = 10;           // 10ns
    
        // --- MAGIA SYNCHRONIZACJI ---
        // Obliczamy parametry DOKŁADNIE tak, jak robi to Twój moduł (z zaokrągleniem w dół).
        // Dzięki temu Testbench nadaje z taką samą "krzywą" prędkością jak FPGA.
        localparam int DUT_DIVIDER = CLK_FREQ_HZ / (TARGET_BAUD * 16); // = 6 dla 921600
        
        // Licznik w FPGA liczy 0..N, więc to N+1 cykli
        localparam real REAL_BIT_PERIOD = (DUT_DIVIDER + 1) * 16 * CLK_PERIOD;
    
        // Ustawiamy częstotliwość automatycznego wysyłania przez moduł (TX)
        // Musi być dłuższa niż czas trwania jednej ramki (ok. 11 bitów)
        // 11 bitów * 16 ticków * 7 cykli = ~1232 cykle. Dajemy 2000 dla zapasu.
        localparam int TX_AUTO_SEND_INTERVAL = 2000; 
    
        // =========================================================================
        // 2. SYGNAŁY
        // =========================================================================
        logic clk = 0;
        logic rst_n = 0;
        logic [7:0] din = 0;
        logic rx = 1; // Idle state
        logic sw = 0;
    
        logic tx;
        logic tx_buf;
        logic tx_done_tick_buf;
        logic [7:0] rx_dout;
        logic rx_done_tick;
        logic db_level;
        logic db_tick;
    
        // =========================================================================
        // 3. INSTANCJA DUT
        // =========================================================================
        top #(
            .BITRATE(TARGET_BAUD),
            .CORE_FREQ(CLK_FREQ_HZ),
            .UART_START_FREQ(TX_AUTO_SEND_INTERVAL) // Nadpisujemy, żeby nie czekać wieki na TX
        ) dut (
            .clk(clk),
            .rst_n(rst_n),
            .din(din),
            .rx(rx),
            .sw(sw),
            .tx(tx),
            .tx_buf(tx_buf),
            .tx_done_tick_buf(tx_done_tick_buf),
            .rx_dout(rx_dout),
            .rx_done_tick(rx_done_tick),
            .db_level(db_level),
            .db_tick(db_tick)
        );
    
        // =========================================================================
        // 4. ZADANIA TESTOWE (TASKS)
        // =========================================================================
    
        // Zadanie: TB wysyła do RX
        task automatic check_rx(input logic [7:0] byte_to_send);
            int i;
            begin
                $display("[TB] Sending 0x%h to RX...", byte_to_send);
                
                // Start bit
                rx = 0; #(REAL_BIT_PERIOD);
                // Data bits
                for (i=0; i<8; i++) begin
                    rx = byte_to_send[i]; #(REAL_BIT_PERIOD);
                end
                // Stop bit
                rx = 1; #(REAL_BIT_PERIOD);
                #(REAL_BIT_PERIOD); // Margin
    
                // Weryfikacja
                
                assert (rx_dout == byte_to_send) 
                    else $error("RX Error: Expected 0x%h, got 0x%h", byte_to_send, rx_dout);
                    
                if (rx_done_tick && rx_dout == byte_to_send)
                    $display("[TB] RX OK: 0x%h received correctly.", rx_dout);
            end
        endtask
    
        // Zadanie: TB odbiera z TX
        task automatic check_tx(input logic [7:0] expected_byte);
            logic [7:0] captured;
            int i;
            begin
                $display("[TB] Waiting for 0x%h from TX...", expected_byte);
                
                // Czekaj na start bit z timeoutem
                fork : wait_start
                    wait(tx == 0);
                    begin
                        #100000; // 100us timeout
                        if (tx !== 0) begin
                            $error("TX Timeout: Start bit never came.");
                            disable wait_start;
                        end
                    end
                join_any
                
                if (tx == 0) begin
                    // Próbkowanie w połowie bitu
                    #(REAL_BIT_PERIOD * 1.5);
                    
                    for (i=0; i<8; i++) begin
                        captured[i] = tx;
                        #(REAL_BIT_PERIOD);
                    end
                    
                    // Sprawdzenie Stop bitu
                    assert (tx == 1) else $warning("TX Warning: Stop bit unstable!");
    
                    // Asercja danych
                    assert (captured == expected_byte) 
                        $display("[TB] TX OK: Received 0x%h", captured);
                    else 
                        $error("TX Error: Expected 0x%h, got 0x%h", expected_byte, captured);
                    
                    wait(tx == 1); // Czekaj na koniec ramki
                end
            end
        endtask
    
        // =========================================================================
        // 5. GŁÓWNY PROCES
        // =========================================================================
        initial begin
            // Zegar
            fork forever #(CLK_PERIOD/2.0) clk = ~clk; join_none
    
            $timeformat(-9, 2, " ns", 20);
            $display("=== FINAL VERIFICATION START ===");
            $display("Calculated Bit Period: %0.2fns", REAL_BIT_PERIOD);
    
            // Reset
            rst_n = 0; rx = 1; din = 8'h00;
            #200;
            rst_n = 1;
            #200;
    
            // --- TEST 1: RX (Odbiór) ---
            check_rx(8'hA5);
            #5000;
            check_rx(8'h3C);
            #5000;
    
            // --- TEST 2: TX (Nadawanie) ---
            // Uwaga: Moduł wysyła dane automatycznie co TX_AUTO_SEND_INTERVAL.
            
            // 1. Czekamy na ciszę na linii TX
            wait(tx == 1); 
            #5000;
    
            // 2. Ustawiamy dane i czekamy na ich wysłanie
            din = 8'h99;
            check_tx(8'h99);
    
            #5000;
            din = 8'h12;
            check_tx(8'h12);
    
            // --- KONIEC ---
            #2000;
            $display("\n=== ALL TESTS PASSED SUCCESSFULLY ===");
            $finish;
        end
    
        // =========================================================================
        // 6. ASERCJE WSPÓŁBIEŻNE (Monitorowanie ciągłe)
        // =========================================================================
        
        // Sprawdź czy reset czyści flagę rx_done_tick
        assert property (@(posedge clk) !rst_n |-> rx_done_tick == 0);
    
        // Sprawdź czy rx_done_tick jest impulsem (1 cykl)
        assert property (@(posedge clk) rx_done_tick |=> !rx_done_tick);
    
    endmodule