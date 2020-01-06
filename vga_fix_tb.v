`timescale 1ns / 1ps
//****************************************************************//
// File name: vga_fix_tb.v //
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

//The testbench is a self-checking testbench to ensure our 12 vga requirements
//along with 3 object requirements in pixel_gen_circuit have been met.
//for more info see the top page of our report
//If the requirements has not been met, the testbench will output a error
//and explains which requirement was incorrect.

//The self-checking testbench compares the actual and expected value
//We use the clk that changes edges once every 5ms
module vga_fix_tb;

	// Inputs
	reg clk;
	reg reset;

	// Outputs
	wire hsync;
	wire vsync;
	wire [3:0] r;
	wire [3:0] g;
	wire [3:0] b;

	// Instantiate the Unit Under Test (UUT)
	vga_fix uut (
		.clk(clk), 
		.reset(reset), 
		.hsync(hsync), 
		.vsync(vsync), 
		.r(r), 
		.g(g), 
		.b(b)
	);
	always #5 clk = ~clk;
	always @(posedge clk) begin
		//requirement 2/3
		if (uut.VGA.pixel_tick)
			if (uut.VGA.mod2_reg != 3) begin
				$display("ERROR DETECTED: Pixel Tick raised before 25MHZ pixel clock. ",$time);
			end
	end
	always @(posedge uut.VGA.pixel_tick) begin
		//Object requirement 1
		if (uut.PXL.wall_on) begin
			if (!( uut.VGA.pixel_x >=  uut.PXL.WALL_LEFT &&  uut.VGA.pixel_x <=  uut.PXL.WALL_RIGHT &&  uut.VGA.pixel_y >=  uut.PXL.Screen_y_top 
				&&  uut.VGA.pixel_y <=  uut.PXL.Screen_y_bottom))   begin
				$display("ERROR DETECTED: Wall rendering error, rendered at %d , %d at time = %t",uut.PXL.pixel_x,uut.PXL.pixel_y,$time);
				$stop ;
			end 
			if (!( r ==  4'b1111 && g == 4'b0000 && b == 4'b0000))   begin
				$display("ERROR DETECTED: Wall color error, rendered at %d , %d. Color (R/G/B): %d %d %d at time = %t",uut.PXL.pixel_x,uut.PXL.pixel_y,r,g,b,$time);
				$stop ;
			end 
		end
		//Object requirement 2
		if (uut.PXL.paddle_on) begin
			if (!(uut.VGA.pixel_x >= uut.PXL.PADDLE_LEFT && uut.VGA.pixel_x <= uut.PXL.PADDLE_RIGHT && uut.VGA.pixel_y >= uut.PXL.PADDLE_TOP && uut.VGA.pixel_y <= uut.PXL.PADDLE_BOTTOM))begin
				$display("ERROR DETECTED: Paddle rendering error, rendered at %d , %d at time = %t",uut.PXL.pixel_x,uut.PXL.pixel_y,$time);
				$stop;
			end
			if (!( r ==  4'b0000 && g == 4'b1111 && b == 4'b0000))   begin
				$display("ERROR DETECTED: Paddle color error, rendered at %d , %d. Color (R/G/B): %d %d %d at time = %t",uut.PXL.pixel_x,uut.PXL.pixel_y,r,g,b,$time);
				$stop ;
			end 
		end
		//Object requirement 3
		if (uut.PXL.ball_on) begin
		   if (!(uut.VGA.pixel_x >= uut.PXL.BALL_LEFT && uut.VGA.pixel_x <= uut.PXL.BALL_RIGHT && uut.VGA.pixel_y >= uut.PXL.BALL_TOP && uut.VGA.pixel_y <= uut.PXL.BALL_BOTTOM)) begin
				$display("ERROR DETECTED: Ball rendering error, rendered at %d , %d at time = %t",uut.PXL.pixel_x,uut.PXL.pixel_y,$time);
				$stop;
			end
			if (!( r ==  4'b0000 && g == 4'b0000 && b == 4'b1111))   begin
				$display("ERROR DETECTED: Ball color error, rendered at %d , %d. Color (R/G/B): %d %d %d at time = %t",uut.PXL.pixel_x,uut.PXL.pixel_y,r,g,b,$time);
				$stop ;
			end 
		end
		//requirement 1
		if (reset)
		 if (hsync != 0 || vsync != 0 || r != 4'b0000 || g !=  4'b0000 || b !=4'b0000) begin
		 		$display("ERROR DETECTED: Reset outputs are NOT 0s. HSYNC: %d, VSYNC: %d, R: %d, G:%d, B:%d",hsync,vsync,r,g,b);
				$stop;
			end
		//requirement 4
		 if (uut.VGA.h_end) begin
			if (uut.VGA.pixel_x >= 800) begin
				$display("ERROR DETECTED: pixel x continuing passing after 800, X: %d",uut.PXL.pixel_x);
				$stop;
			end
		 end
		//requirement 5	
		if (uut.VGA.hsync) 
		  if (!(uut.VGA.pixel_x < 656 || uut.VGA.pixel_x> 751)) begin
				$display("ERROR DETECTED: Hsync is 1, x = %d, y = %d, time = %t",uut.PXL.pixel_x,uut.PXL.pixel_y,$time);
				$stop;
			end

		//requirement 6
		if (uut.VGA.h_videoOn) 
		  if (!(uut.VGA.pixel_x >=0 && uut.VGA.pixel_x<= 639)) begin
				$display("ERROR DETECTED: Horizontal Video On is 1, x = %d, y = %d, time = %t",uut.PXL.pixel_x,uut.PXL.pixel_y,$time);
				$stop;
			end	
	
		//requirement 7
		 if (uut.VGA.h_end && uut.VGA.pixel_x == 0) begin
			$display("ERROR DETECTED: Horizontal counter not reset to 0 X: %d, Y: %d",uut.VGA.pixel_x,uut.VGA.pixel_y);	
			$stop;
		 end
		//requirement 8
		if (uut.VGA.v_end) begin
			if (uut.VGA.pixel_y >= 525) begin
				$display("ERROR DETECTED: pixel y continuing passing after 525, Y: %d",uut.PXL.pixel_y);
			end
				 end 
		//requirement 9
		 if (uut.VGA.vsync) 
		  if (!(uut.VGA.pixel_y < 490 || uut.VGA.pixel_y> 491)) begin
				$display("ERROR DETECTED: Vsync is 1, x = %d, y = %d, time = %t",uut.PXL.pixel_x,uut.PXL.pixel_y,$time);
				$stop;
			end	
		//requirement 10
		 if (uut.VGA.v_videoOn) 
		  if (!(uut.VGA.pixel_y >=0 && uut.VGA.pixel_y<=479)) begin
				$display("ERROR DETECTED: Vertical Video On is 1, x = %d, y = %d, time = %t",uut.PXL.pixel_x,uut.PXL.pixel_y,$time);
				$stop;
		end	
		//requirement 11
		if (uut.VGA.video_on)
			if (hsync ==0 || vsync == 0) begin
		 		$display("ERROR DETECTED: The hsync and vsync is off, X: %d, Y: %d, R: %d, G: %d, B: %d, time = %t",uut.PXL.pixel_x,uut.PXL.pixel_y,uut.PXL.r,uut.PXL.g,uut.PXL.b,$time);
				$stop;
			end
		//requirement 12
		if (!uut.VGA.video_on) begin
			 if (r !=0 || g != 0 || b!= 0) begin
					$display("ERROR DETECTED: The r/g/b is nonzero , X: %d, Y: %d, R: %d, G: %d, B: %d, time = %t",uut.PXL.pixel_x,uut.PXL.pixel_y,uut.PXL.r,uut.PXL.g,uut.PXL.b,$time);
					$stop;
			 end		
		end
	end
	
	integer i,j;
	initial begin
	//-3 power
	//5 decimal places
	//ms time expressed in ms
	//Up to 10 digits can be shown for $time
	$timeformat(-3,5,"ms",10);
		// Initialize Inputs
		clk = 0;
		reset = 0;
		#100
		// Wait 100 ns for global reset to finish
		reset = 1; #5; reset = 0; #100;

		// Add stimulus here

	end
      
endmodule

