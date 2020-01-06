`timescale 1ns / 1ps
//****************************************************************//
// File name: vga_fix.v //
// //
// Created by Steven Wang on 4/11/2018 3:00 PM. //
// Copyright © 2018 Steven Wang. All rights reserved. //
// //
// //
// In submitting this file for class work at CSULB //
// I am confirming that this is my work and the work //
// of no one else. In submitting this code I acknowledge that //
// plagiarism in student project work is subject to dismissal. //
// from the class //
//****************************************************************//

//vga_fix is the top level module that contains two submodules
//vga_sync is the module that generates hsync,vsync,x,and y, and 
//video_on that are vital to rendering pixels on the monitor
//pixel_gen_circuit draws the pixels depending on the position x and y
//Some of these are ball,paddle,wall
module vga_fix(clk,reset,hsync,vsync,r,g,b);
input wire clk,reset;
output wire hsync,vsync;
wire video_on,p_tick;
wire [9:0] pixel_x,  pixel_y;
output [3:0]r,g,b;

vga_sync  VGA(.clk(clk),.reset(reset),.hsync(hsync),.vsync(vsync),.video_on(video_on)
				,.p_tick(p_tick),.pixel_x(pixel_x),.pixel_y(pixel_y));
pixel_gen_circuit PXL(.reset(reset),.pixel_x(pixel_x),.pixel_y(pixel_y)
				,.video_on(video_on),.r(r),.g(g),.b(b),.pixel_tick(clk));

endmodule
