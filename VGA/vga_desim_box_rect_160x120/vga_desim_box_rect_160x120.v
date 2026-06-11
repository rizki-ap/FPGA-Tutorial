// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

`timescale 1ns / 1ns
`default_nettype none

module vga_desim_box_rect_160x120 (clk,rst_n,VGA_X,VGA_Y,VGA_RGB,VGA_PLOT);
    // Number of columns and rows in the video memory
    parameter COLS = 160  ;
    parameter ROWS = 120  ;
    parameter nX = 8; // VGA x bitwidth for 640x480
    parameter nY = 7; // VGA y bitwidth for 640x480

    input wire clk;	// DE-series board 50 MHz Clock
    input wire rst_n;		// 

    output reg [nX-1:0] VGA_X;     // VGA column
    output reg [nY-1:0] VGA_Y;     // VGA row
    output reg [23:0] VGA_RGB;   // VGA pixel colour (24-bit color)
    output wire VGA_PLOT;   	// VGA pixel colour (24-bit color)

	//the box parameter
	parameter BOX_W		= 10;			// box width
	parameter BOX_H		= 10;			// box height
	parameter BOX_RGB	= 24'h00_FF_00;		// box foreground colors
	reg [nX:0] box_px = 0;		// box position x (top left corner)
	reg [nY:0] box_py = 0;		// box position y (top left corner)
	
	//the box parameter
	parameter RECT_W	= 30;			// box width
	parameter RECT_H	= 3;			// box height
	parameter RECT_RGB	= 24'h00_00_FF;		// box foreground colors
	reg [nX-1:0] rect_px = 0;				// box position x (top left corner)
	reg [nY-1:0] rect_py = 100;				// box position y (top left corner)

	parameter BACK_RGB	= 24'hFF_FF_FF;		// background colors

	assign VGA_PLOT = 1;

    always @(posedge clk or negedge rst_n) begin	//creating one frame
        if (rst_n == 0) begin
            VGA_X <= {nX{1'b0}};	// set starting x coordinate
            VGA_Y <= {nY{1'b0}};	// set starting y coordinate
        end
        else begin
		if(VGA_X < 160)	
			VGA_X <= VGA_X + 1'b1;		//counting up X plot coordinate
		else begin			
			VGA_X <= {nX{1'b0}};
			if(VGA_Y < ROWS )
				VGA_Y <= VGA_Y + 1'b1;	//counting up Y plot coordinate
			else 
				VGA_Y <= {nY{1'b0}};
		end	
	end
    end
	
	always @(posedge clk or negedge rst_n) begin	//drawing the box, rect and background
		if (rst_n == 0) 
			VGA_RGB <= {24{1'b0}};
		else begin
			if 	((VGA_X>box_px)&&(VGA_Y>box_py)&&(VGA_X<(box_px+BOX_W))&&(VGA_Y<(box_py+BOX_H)))
				VGA_RGB <= BOX_RGB ;	//if the the x-y now is the box coordinate draw box color
			else if	((VGA_X>rect_px)&&(VGA_Y>rect_py)&&(VGA_X<(rect_px+RECT_W))&&(VGA_Y<(rect_py+RECT_H)))
				VGA_RGB <= RECT_RGB ;	//if the the x-y now is the rect coordinate draw rect color
			else
				VGA_RGB <= BACK_RGB;	//if other draw background color
		end
	end

	always @(posedge VGA_Y) begin		//moving the box, plot new box coordinate 
		if (VGA_Y == ROWS-1) begin	//once every frame

		if ( box_py < ROWS-BOX_H) 	box_py <= box_py + 5; //moving the box y coordinate
		else box_py <= {nX{1'b0}};
		if ( box_px < COLS-BOX_W) 	box_px <= box_px + 5; //moving the box x coordinate
		else box_px <= {nX{1'b0}};
		if ( rect_px < COLS-RECT_W) 	rect_px <= rect_px + 10; //moving the rect x coordinate
		else rect_px <= {nX{1'b0}};
		end
	end

endmodule
