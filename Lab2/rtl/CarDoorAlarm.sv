module cardooralarm(

    output logic y,
    input logic a,
    input logic b,
    input logic c,
    input logic d,
    input logic e 
);

assign y = (~a)|(~b)|(~c)|(~d)|(~e);

endmodule 