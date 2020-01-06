`timescale 1ns / 1ps
//****************************************************************//
// File name: pixel_gen_circuit.v //
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

//Pixel generation circuit that tells the monitor to draw objects on the screen depending on
//the location of x and y
//The wall has a width of 3 and a height of 480
//The paddle has a width of 3 and a height of 72
//The ball has a width of 8 and a height of 8
//Each of them has a different color and the background by default is white.
module pixel_gen_circuit(reset,pixel_x,pixel_y,pixel_tick,video_on,r,g,b);
input [9:0] pixel_x,pixel_y;
input reset;
input pixel_tick;
input video_on;
output reg [3:0] r, g, b;

localparam Screen_y_top = 0;
localparam Screen_y_bottom = 479;

localparam WALL_LEFT = 32;
localparam WALL_RIGHT = 35;

localparam PADDLE_LEFT = 600;
localparam PADDLE_RIGHT = 603;
localparam PADDLE_TOP = 204;
localparam PADDLE_BOTTOM = 276;

localparam BALL_LEFT = 580;
localparam BALL_RIGHT = 588;

localparam BALL_TOP = 238;
localparam BALL_BOTTOM = 246;

wire wall_on, paddle_on, ball_on;
assign wall_on = (pixel_x >= WALL_LEFT && pixel_x <= WALL_RIGHT && pixel_y >= Screen_y_top  && pixel_y <= Screen_y_bottom);
assign paddle_on = (pixel_x >= PADDLE_LEFT && pixel_x <= PADDLE_RIGHT && pixel_y >= PADDLE_TOP && pixel_y <= PADDLE_BOTTOM);
assign ball_on = (pixel_x >= BALL_LEFT && pixel_x <= BALL_RIGHT && pixel_y >= BALL_TOP && pixel_y <= BALL_BOTTOM);

always @(*) begin
	if (reset)
		{r,g,b} = 12'b0000_0000_0000;
if (pixel_tick)
	if (~video_on) 
		{r,g,b} = 12'b0000_0000_0000;
	else if (wall_on)
		{r,g,b} = 12'b1111_0000_0000;
	else if (paddle_on)
		{r,g,b} = 12'b0000_1111_0000;
	else if (ball_on)
		{r,g,b}= 12'b0000_0000_1111;
	else
		{r,g,b} = 12'b1111_1111_1111;
end
endmodule
