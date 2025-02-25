`timescale 1ns/1ns
`include "mp2.sv"

module mp2_tb;

    // clk and RGB output signals
    logic clk = 0;
    logic RGB_R, RGB_G, RGB_B;

    mp2 mp2 (
        .clk(clk),
        .RGB_R(RGB_R),
        .RGB_G(RGB_G),
        .RGB_B(RGB_B)
    );

    initial begin
        $dumpfile("mp2_tb.vcd");
        $dumpvars(1, mp2);
        #1000000000; // run for 1 second
        $finish;
    end
    
    always begin
        #41.6667 clk = ~clk; // ~12 MHz half-period
    end

endmodule
