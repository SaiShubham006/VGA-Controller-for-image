module Image_test(
  input clk,
  input rst,
  output [3:0] o_red,
  output [3:0] o_blue,
  output [3:0] o_green,
  output vsync,
  output hsync
    );
    
    wire tick_25;
    wire video_out;
    wire [9:0] hor_cnt;
    wire [9:0] ver_cnt;
    
    reg [3:0] o_red_reg;
    reg [3:0] o_green_reg;
    reg [3:0] o_blue_reg;
    
    parameter img_x=64;
    parameter img_y=64;
    parameter img_total=img_x*img_y;
    
    reg [23:0] image_mem [0:img_total-1];
    
    wire [5:0] img_size_x=hor_cnt[5:0];
    wire [5:0] img_size_y=ver_cnt[5:0];
 
    
    Controller mod2(.clk(clk), .rst(rst), .hor_cnt(hor_cnt), .ver_cnt(ver_cnt), .vsync(vsync), .hsync(hsync), 
                    .pix_tick(tick_25), .video_out(video_out));
                    
    initial begin
        $readmemh("memory1.mem", image_mem);
    end
    
    wire [11:0] addr = img_size_y* img_x + img_size_x;
    
    wire [7:0] r8 = image_mem[addr][23:16];
    wire [7:0] g8 = image_mem[addr][15:8];
    wire [7:0] b8 = image_mem[addr][7:0];

    wire [3:0] r4 = r8[7:4];
    wire [3:0] g4 = g8[7:4];
    wire [3:0] b4 = b8[7:4];
    
    always @(posedge tick_25) begin
      if(rst) begin
        o_red_reg<=4'b0000;
        o_blue_reg<=4'b0000;
        o_green_reg<=4'b0000;
      end
      else begin
        if (video_out && ((hor_cnt < img_x+128 && hor_cnt>128) && (ver_cnt< img_y+128  && ver_cnt>128))
                           | (video_out && (hor_cnt < img_x+256 && hor_cnt>256) && (ver_cnt< img_y+256 && ver_cnt>256))) begin
          o_red_reg <= r4;
          o_green_reg <=g4;
          o_blue_reg <= b4;
        end
        else begin
          o_red_reg<=4'b0000;
          o_blue_reg<=4'b0000;
          o_green_reg<=4'b0000;
        end
      end
    end
    
assign o_red = o_red_reg;
assign o_green = o_green_reg;
assign o_blue = o_blue_reg;

endmodule
