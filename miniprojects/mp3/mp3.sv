module mp3(
    input logic     clk, 
    output logic    _9b,    // D0
    output logic    _6a,    // D1
    output logic    _4a,    // D2
    output logic    _2a,    // D3
    output logic    _0a,    // D4
    output logic    _5a,    // D5
    output logic    _3b,    // D6
    output logic    _49a,   // D7
    output logic    _45a,   // D8
    output logic    _48b    // D9
);

logic [8:0] sample_idx = 0;         // 9 bit counter for current sample in sine wave cycle
logic [9:0] quarter_mem [0:127];    // stores 128 values of 10-bit data from text file
logic [9:0] dac_out;                // stores 10 bit DAC output

// read 128 hex values representing quarter sine wave into quarter_mem
initial begin
    $readmemh("quarter.txt", quarter_mem);
end

// actual implementation of sample counter
always_ff @(posedge clk) begin
    if (sample_idx == 511)
        sample_idx <= 0;
    else begin
        sample_idx++;
    end
end

// compute DAC value based on current sample index (4 sections)
always_comb begin
    dac_out = (sample_idx < 128)  ? (quarter_mem[sample_idx]) :                     // rising from 512 to 1023
              (sample_idx < 256)  ? (quarter_mem[127 - (sample_idx - 128)]) :       // falling from 1023 to 512
              (sample_idx < 384)  ? (1024 - quarter_mem[sample_idx - 256]) :        // falling from 512 to 1
                                    (1024 - quarter_mem[127 - (sample_idx - 384)]); // rising from 1 to 512
end

// assign dac_out's bits to DAC output signals
assign {_48b, _45a, _49a, _3b, _5a, _0a, _2a, _4a, _6a, _9b} = dac_out;

endmodule
