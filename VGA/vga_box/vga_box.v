// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

`timescale 1ns / 1ns
`default_nettype none

module vga_box (iCLK_50,iRSTn,oVGA_X,oVGA_Y,oVGA_RGB,oVGA_HS,oVGA_VS,oVGA_SYNC,oVGA_BLANK,oVGA_CLK);
    // Number of columns and rows in the video memory
    parameter COLS = 640  ;
    parameter ROWS = 480  ;
    parameter nX = 10; // VGA x bitwidth for 640x480
    parameter nY = 9; // VGA y bitwidth for 640x480

    input wire iCLK_50;	// DE-series board 50 MHz Clock
    input wire iRSTn;		// 

    output wire [nX-1:0] oVGA_X;     // VGA column
    output wire [nY-1:0] oVGA_Y;     // VGA row
    output wire [23:0] oVGA_RGB;   // VGA pixel colour (24-bit color)
    output reg	oVGA_HS;			// Pixel is drawn plot = 1
    output reg	oVGA_VS;			// Pixel is drawn plot = 1
    output wire oVGA_SYNC;		// Pixel is drawn plot = 1
    output wire oVGA_BLANK;		// Pixel is drawn plot = 1
    output reg	oVGA_CLK=0;		// Pixel is drawn plot = 1

    reg [nX-1:0]	x_cntr;		// used when drawing individual colors
    reg [nY:0] 		y_cntr;		// used when drawing individual colors
    reg [23:0] 		color;		// used when drawing individual colors
	reg [1:0] tick_cntr=0;

	//	Horizontal	Parameter
	parameter	H_FRONT	=	16;
	parameter	H_SYNC	=	96;
	parameter	H_BACK	=	48;
	parameter	H_ACT	=	640;
	parameter	H_BLANK	=	H_FRONT+H_SYNC+H_BACK;
	parameter	H_TOTAL	=	H_FRONT+H_SYNC+H_BACK+H_ACT;
	//	Vertical Parameter
	parameter	V_FRONT	=	11;
	parameter	V_SYNC	=	2;
	parameter	V_BACK	=	31;
	parameter	V_ACT	=	480;
	parameter	V_BLANK	=	V_FRONT+V_SYNC+V_BACK;
	parameter	V_TOTAL	=	V_FRONT+V_SYNC+V_BACK+V_ACT;
	
	//the box parameter
	parameter BOX_W		= 20;						// box width
	parameter BOX_H		= 20;						// box height
	parameter BACK_RGB	= 24'hFF_FF_FF;				// background colors
    parameter BOX_RGB	= 24'hFF_00_00;				// box foreground colors
	parameter BOX_MV_X	= 10;						// box movement-x 
	parameter BOX_MV_Y	= 10;						// box movement-y 
    reg [nX-1:0] box_px = (COLS>>1)-(BOX_W>>1);		// box position x
    reg [nY:0]	 box_py = (ROWS>>1)-(BOX_H>>1);		// box position y
	
	
	assign	oVGA_SYNC	=	1'b1;			//	This pin is unused.
	assign	oVGA_BLANK	=	~((x_cntr<H_BLANK)||(y_cntr<V_BLANK));
	assign	oVGA_X		=	(x_cntr>=H_BLANK)? x_cntr-H_BLANK :	{nX{1'b0}};
	assign	oVGA_Y		=	(y_cntr>=V_BLANK)? y_cntr-V_BLANK :	{nY{1'b0}};
	assign  oVGA_RGB	= 	color;

	always @(posedge oVGA_VS) begin
//		if ( box_py < V_ACT) 	box_py <= box_py + BOX_MV_Y;
//		else 					box_py <= {nX{1'b0}};
//		if ( box_px < H_ACT) 	box_py <= box_px + BOX_MV_X;
//		else 					box_py <= {nX{1'b0}};
	end
	
	//X-Y_Counter block
    always @(posedge iCLK_50 or negedge iRSTn) begin
        if (iRSTn == 0) begin
            x_cntr <= {nX{1'b0}};	// set starting x coordinate
            y_cntr <= {nY{1'b0}};	// set starting y coordinate
            oVGA_HS <= 1'b1;         // set starting X-sync state 
            oVGA_VS <= 1'b1;         // set starting Y-sync state 
        end
        else begin
			if(x_cntr < H_TOTAL)	
				x_cntr <= x_cntr + 1'b1;
			else begin			
				x_cntr <= {nX{1'b0}};
				if(y_cntr < V_TOTAL)
					y_cntr <= y_cntr + 1'b1;
				else 
					y_cntr <= {nY{1'b0}};
				if(y_cntr == V_FRONT-1) oVGA_VS <= 1'b0; 
				if(y_cntr == V_FRONT+V_SYNC-1) oVGA_VS <= 1'b1; 
			end	
			if(x_cntr == H_FRONT-1) oVGA_HS <= 1'b0; 
			if(x_cntr == H_FRONT+H_SYNC-1) oVGA_HS <= 1'b1; 
		end
    end
	
	always @(posedge iCLK_50 or negedge iRSTn) begin
		if (iRSTn == 0) 
			color <= {24{1'b0}};
		else begin
			if 	((oVGA_X>box_px)&&(oVGA_Y>box_py)&&(oVGA_X<(box_px+BOX_W))&&(oVGA_Y<(box_py+BOX_H)))
				color <= BOX_RGB ;
			else
				color <= BACK_RGB;
		end
	end
endmodule
