`timescale 1ns / 1ps
module test_cam(
    input wire clk,
    input wire rst,
	output wire CAM_xclk,
	output [7:0]data_mem,
	input wire CAM_pclk,
	input wire CAM_vsync,
	input wire CAM_href,
	input wire [7:0] CAM_px_data

		
);

parameter CAM_SCREEN_X = 160;
parameter CAM_SCREEN_Y = 120;

localparam AW = 15; // LOG2(CAM_SCREEN_X*CAM_SCREEN_Y)
localparam DW = 8;

wire clk25M;
wire clk24M;
wire  [AW-1: 0] DP_RAM_addr_in;  
wire  [DW-1: 0] DP_RAM_data_in;
wire DP_RAM_regW;
reg  [AW-1: 0] DP_RAM_addr_out;  
	
assign CAM_xclk =  clk24M;

clk24_25_nexys4  clk25_24(
  .clk100M(clk),
  .clk25M(clk25M),
  .clk24M(clk24M),
  .reset(rst)
 );

buffer_ram_dp #(AW,DW)
	DP_RAM(  
	.clk_w(CAM_pclk), 
	.addr_in(DP_RAM_addr_in), 
	.data_in(DP_RAM_data_in),
	.regwrite(DP_RAM_regW), 
	.clk_r(clk25M), 
	.addr_out(DP_RAM_addr_out),
	.data_out(data_mem)
	);

 cam_read #(AW)cam_read(
		.CAM_pclk(CAM_pclk),
		.rst(rst),
		.CAM_vsync(CAM_vsync),
		.CAM_href(CAM_href),
		.CAM_px_data(CAM_px_data),

		.DP_RAM_addr_in(DP_RAM_addr_in),
		.DP_RAM_data_in(DP_RAM_data_in),
		.DP_RAM_regW(DP_RAM_regW)
   );
endmodule
