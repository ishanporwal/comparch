module mp1 #(
    // CLK freq is 12MHz, so 2,000,000 cycles is 1/6 seconds.
    parameter BLINK_INTERVAL = 2000000
)(
    // defining inputs and outputs
    input logic     clk,
    output logic    RGB_R,
    output logic    RGB_G,
    output logic    RGB_B
);

    // enumerated type using 3-bit encoding for 6 color states
    typedef enum logic [2:0] {red, yellow, green, cyan, blue, magenta} Color;
    
    // state variable
    Color color_state;
    
    // 32-bit counter tracks clk
    logic [31:0] counter;

    // initializing color as red
    initial color_state = red;

    // setting RGB output based on color state
    always_comb begin
        case (color_state)
            red:     {RGB_R, RGB_G, RGB_B} = 3'b100;
            yellow:  {RGB_R, RGB_G, RGB_B} = 3'b110;
            green:   {RGB_R, RGB_G, RGB_B} = 3'b010;
            cyan:    {RGB_R, RGB_G, RGB_B} = 3'b011;
            blue:    {RGB_R, RGB_G, RGB_B} = 3'b001;
            magenta: {RGB_R, RGB_G, RGB_B} = 3'b101;
            default: {RGB_R, RGB_G, RGB_B} = 3'b000;
        endcase
    end

    // sequentially updating color state based on counter
    always_ff @(posedge clk) begin
        if (counter >= BLINK_INTERVAL) begin
            counter <= 0;
            case (color_state)
                red:     color_state <= yellow;
                yellow:  color_state <= green;
                green:   color_state <= cyan;
                cyan:    color_state <= blue;
                blue:    color_state <= magenta;
                magenta: color_state <= red;
                default: color_state <= red;
            endcase
        end
        else begin
            counter <= counter + 1;
        end
    end
endmodule
