module Clk_25MHz (
    input  wire clk,     // 100 MHz
    input  wire rst,
    output wire clk_25    // 25 MHz clock
);

    reg [1:0] div;

    always @(posedge clk or posedge rst) begin
        if (rst)
            div <= 2'b00;
        else
            div <= div + 1'b1;
    end

    assign clk_25 = div[1];

endmodule
