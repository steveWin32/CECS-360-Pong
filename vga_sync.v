`timescale 1ns / 1ps
//****************************************************************//
// File name: VGA Sync.v //
// //
// Created by Steven Wang on 3/6/2018 10:25 PM. //
// Copyright © 2018 Steven Wang. All rights reserved. //
// //
// //
// In submitting this file for class work at CSULB //
// I am confirming that this is my work and the work //
// of no one else. In submitting this code I acknowledge that //
// plagiarism in student project work is subject to dismissal. //
// from the class //
//****************************************************************//

//VGA Sync renders the horizontal and verical counter once every 25MHZ
//from our 100 MHZ clock
//Our monitor contains 800 by 525 with only 640x480 is rendered onto the screen
//Our output video_on determines whether the pixel shall be drawn otherwise
//it won't be drawn
//the X is a counter that counts up to 800 and resets
//the Y is a counter that counts up to 525 and resets

module vga_sync(clk,reset,hsync,vsync,video_on,p_tick,pixel_x,pixel_y);
input wire clk, reset;
output wire hsync, vsync, video_on, p_tick;
output wire [9:0] pixel_x, pixel_y;

//Screen size
localparam HD = 640;
localparam HF = 48;
localparam HB = 16;
localparam HR = 96;
localparam VD = 480;
localparam VF = 10;
localparam VB = 33;
localparam VR = 2;

//Set monitor clock rate to 25MHZ
reg [1:0] mod2_reg;
reg [9:0] h_count_reg, h_count_next;
reg [9:0] v_count_reg, v_count_next;

wire h_end,v_end,pixel_tick;
wire h_videoOn,v_videoOn;
always @(posedge clk, posedge reset)
	if (reset)
		begin
			mod2_reg <= 1'b0;
			v_count_reg <= 0;
			h_count_reg <= 0;
		end else begin
			mod2_reg <= (mod2_reg + 2'b1) % 4;
			v_count_reg <= v_count_next;
			h_count_reg <= h_count_next;
		end
//Set monitor to 25MHZ clock
assign pixel_tick = mod2_reg == 2'b11 ? 1'b1 : 1'b0;
//Check if the horizontal counter reaches the end
assign h_end = (h_count_reg == (HD+HF+HB+HR-1));
//Check if the vertical counter reaches the end
assign v_end = (v_count_reg == (VD+VF+VB+VR-1));

always @(*)
	if (pixel_tick)
		if (h_end) //reset if reached
			h_count_next = 10'b0;
		else //increment by 1
			h_count_next = h_count_reg + 10'b1;
	else
		h_count_next = h_count_reg;

always @(*)
	if (pixel_tick & h_end)
		if (v_end) //reset if reached
			v_count_next = 10'b0;
		else //increment by 1
			v_count_next = v_count_reg + 10'b1;
	else
		v_count_next = v_count_reg;

//HSYNC goes LOW ACTIVE until 656 to 704
assign hsync = ~(h_count_reg >= (HD+HB) && h_count_reg <= (HD+HB+HR-1));
//VSYNC goes LOW ACTIVE until 490 to 491
assign vsync = ~(v_count_reg >= (VD+VF) && v_count_reg <= (VD+VF+VR-1));

//Check if the horizontal direction is currently in the monitor screen between 0 to 640
assign h_videoOn = (h_count_reg < HD);
//Check if the vertical direction is currently in the monitor screen between 0 to 480
assign v_videoOn = (v_count_reg < VD);
//Check if both horizontal and veritcal video are in between the 640x480 screen
assign video_on =  h_videoOn && v_videoOn ;

//Output X/Y monitor coords
assign pixel_x = h_count_reg;
assign pixel_y = v_count_reg;
//Pixel tick, check if the 25MHZ clock is at posedge.
assign p_tick = pixel_tick;

endmodule


