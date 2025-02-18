`timescale 10ns/10ns
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
        $dumpvars(0, mp2_tb);
        #100000000; // going slightly past 1 second to show cycle repeating
        $finish;
    end

    always begin
        #4
        clk = ~clk;
    end

endmodule
