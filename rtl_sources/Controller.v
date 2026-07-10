module Controller(
   input clk,
   input rst,
   output [9:0] hor_cnt,
   output [9:0] ver_cnt,
   output vsync,  //active low
   output hsync,   //active low
   output video_out,
   output pix_tick
    );
    
    parameter HD=640;
    parameter HB=16;
    parameter HR=96;
    parameter HF=48;
    parameter HT=HR+HB+HF+HD;
    parameter VD=480;
    parameter VB=33;
    parameter VR=2;
    parameter VF=10;
    parameter VT=VR+VB+VF+VD;
         
    reg [9:0] hor_cnt_reg;
    reg [9:0] ver_cnt_reg;
    reg vsync_reg; 
    reg hsync_reg;
    reg video_out_reg;
    
    wire tick_25;
    
    Clk_25MHz mod1(.clk(clk), .rst(rst), .clk_25(tick_25));
    
    always @(posedge tick_25) begin
      if(rst) begin
        hor_cnt_reg<=0;
        ver_cnt_reg<=0;
        vsync_reg<=1;
        hsync_reg<=1;
        video_out_reg<=0;
      end
      else begin
        if(hor_cnt_reg==HT-1) begin
          hor_cnt_reg<=0;
          if(ver_cnt_reg==VT-1) begin
            ver_cnt_reg<=0;
          end
          else ver_cnt_reg<=ver_cnt_reg+1;
        end
        else hor_cnt_reg<=hor_cnt_reg+1;
      end
      
      if(hor_cnt_reg < HD && ver_cnt_reg < VD) video_out_reg<=1;
      else video_out_reg<=0;
      
      if(hor_cnt_reg >= HD+HB && hor_cnt_reg < HD+HB+HR) hsync_reg<=0;
      else hsync_reg<=1;
      
      if(ver_cnt_reg >= VD+VB && ver_cnt_reg < VD+VB+VR) vsync_reg<=0;
      else vsync_reg<=1;
    end
    
    assign hor_cnt=hor_cnt_reg;
    assign ver_cnt=ver_cnt_reg;
    assign hsync=hsync_reg;
    assign vsync=vsync_reg;
    assign pix_tick=tick_25;
    assign video_out=video_out_reg;
    
endmodule
