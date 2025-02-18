module mp2 #(
    // clk freq is 12MHz, cycle once per second
    parameter CLK_FREQ = 12000000,
    parameter INTERVAL = CLK_FREQ / 360  // steps to complete time for 1 degree incremeent
)(
    input logic clk,
    // PWM outputs
    output logic RGB_R,
    output logic RGB_G,
    output logic RGB_B
);
    // counter for hue transition
    logic [31:0] counter;
    logic [8:0] hue; // 9 bits for 360°

    // PWM values for each color component
    logic [7:0] pwm_r, pwm_g, pwm_b;
    logic [7:0] pwm_counter;

    initial
    begin
        pwm_counter = 0;
        hue = 0;
        counter = 0;
    end

    // hue transition based on clk cycling
    always_ff @(posedge clk) begin
        if (counter >= INTERVAL)
        begin
            counter <= 0;
            hue <= (hue >= 359) ? 0 : hue + 1;  // increment hue, reset after 360°
        end
        else
        begin
            counter <= counter + 1;
        end
    end

    // pwm logic
    always_comb begin
        pwm_r = (hue < 60) ? 255 :
                (hue < 120) ? (255 * (120 - hue) / 60) :
                (hue < 180) ? 0 :
                (hue < 240) ? 0 :
                (hue < 300) ? (255 * (hue - 240) / 60) :
                255;

        pwm_g = (hue < 60) ? (255 * (hue - 0) / 60) :
                (hue < 180) ? 255 :
                (hue < 240) ? (255 * (240 - hue) / 60) :
                0;

        pwm_b = (hue < 120) ? 0 :
                (hue < 180) ? (255 * (hue - 120) / 60) :
                (hue < 300) ? 255 :
                (hue < 360) ? (255 * (360 - hue) / 60) :
                0;
    end

    // PWM counter
    always_ff @(posedge clk) begin
        pwm_counter <= pwm_counter + 1;
    end

    // assigning pwm output signals (1=high, 0=low)
    assign {RGB_R, RGB_G, RGB_B} = {pwm_counter < pwm_r, pwm_counter < pwm_g, pwm_counter < pwm_b};

endmodule
