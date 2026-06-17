// creator : EDES
// desc : controlling box movement simulation for DESim of 160x120

`timescale 1ns / 1ns
`default_nettype none

module vga_desim_box_ctrl(clk,rst_n,VGA_X,VGA_Y,VGA_RGB,VGA_PLOT,box_x,box_y);
    // Number of columns and rows in the video memory
    parameter COLS = 160  ;
    parameter ROWS = 120  ;
    parameter nX = 8; // VGA x bitwidth for 640x480
    parameter nY = 7; // VGA y bitwidth for 640x480

    input wire clk;	// DE-series board 50 MHz Clock
    input wire rst_n;	//
    input wire [nX-1:0] box_x ;	//
    input wire [nY-1:0] box_y ;	//

    output reg [nX-1:0] VGA_X;     // VGA column
    output reg [nY-1:0] VGA_Y;     // VGA row
    output reg [23:0] VGA_RGB;   // VGA pixel colour (24-bit color)
    output wire VGA_PLOT;   	// VGA pixel colour (24-bit color)

//the box parameter
	parameter BOX_W		= 30;			// box width
	parameter BOX_H		= 10;			// box height
	parameter BOX_RGB	= 24'hA5_2A_2A;		// box foreground colors
	parameter BACK_RGB	= 24'hFF_FF_FF;		// background colors
    reg [nX:0] box_pos_x = 80;		// box position x (top left corner)
    reg [nY:0] box_pos_y = 60;		// box position y (top left corner)
	
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
	
	always @(posedge clk or negedge rst_n) begin	//drawing the box and background
		if (rst_n == 0) 
			VGA_RGB <= {24{1'b0}};
		else begin
			if 	((VGA_X>box_pos_x)&&(VGA_Y>box_pos_y)&&(VGA_X<(box_pos_x+BOX_W))&&(VGA_Y<(box_pos_y+BOX_H)))
				VGA_RGB <= BOX_RGB ;	//if the the x-y now is the box coordinate draw box color
			else
				VGA_RGB <= BACK_RGB;	//if other draw background color
		end
	end

	always @(posedge VGA_Y) begin	//moving the box depend on the input
		if (VGA_Y == ROWS-1) begin	//once every frame
			box_pos_x <= box_x;
			box_pos_y <= box_y;
		end
	end

endmodule
