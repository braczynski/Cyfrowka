module cardooralarm_tb;
    wire y;
    bit a, b, c, d, e;

    cardooralarm u_cardooralarm(.y, .a, .b, .c, .d, .e);

    initial begin
        $monitor("t=%0t | a=%b b=%b c=%b d=%b e=%b | y=%b",
        $time, a, b, c, d, e, y);

        a = 0;
        b = 0;
        c = 0;
        d = 0;
        e = 0;

        for(int i = 0; i < 32; i++) begin
            {a, b, c, d, e} = i;
            #1;

            assert (y == (~a | ~b | ~c | ~d | ~e)) else
                $error("y: exp: 0b%b, rcv: 0b%b", (~a | ~b | ~c | ~d | ~e), y);
        end
        $finish;
    end
endmodule 