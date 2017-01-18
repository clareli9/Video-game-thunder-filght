module enemy2_controller(choice,num,clock,resetn,X,Y,cnt,delay_cnt,loadX,loadY,
load_colour,load_black,plot,en_counter,en_delay_counter,reset_delay,en_reset);
	input choice;
	input [1:0] num;
	input [7:0] X;
	input [6:0] Y;
	input clock,resetn;
	input [3:0]cnt;
	input [3:0]delay_cnt;
	output reg en_reset,loadX,loadY,load_colour,plot,en_counter,load_black,
					en_delay_counter,reset_delay;
	parameter [3:0] RESET_S = 4'b0000,LOAD_S = 4'b0001 ,DRAW_S = 4'b0010 , 
				DONE_S = 4'b0011,	ERASE_S = 4'b0100;
	reg [3:0] PresentState , NextState;
	wire CLOCK;
	assign CLOCK=(num[0]==choice)? clock:0;
	always @ (*)
	begin: state_table
		case(PresentState)
		RESET_S:
			NextState = LOAD_S;
		LOAD_S :
			NextState = DRAW_S;
		DRAW_S:
			if(cnt < 15)
				NextState = DRAW_S;
			else 
				NextState = DONE_S;
		DONE_S:
			if(delay_cnt < 15)
				NextState = DONE_S;
			else 
				NextState = ERASE_S;
		ERASE_S:
			if(cnt < 15)
				NextState = ERASE_S;
			else if (resetn==0)
			   NextState = RESET_S;
			else 
				NextState = LOAD_S;
		endcase 
	end
	
	always@(*)
	begin: output_logic
	case(PresentState)
		RESET_S:
			begin 
			
			loadX = 0;
			loadY = 0;
			load_colour = 0;
			load_black = 0;
			en_counter = 0;
			en_delay_counter = 0;
			reset_delay = 0;
			plot = 0;
			en_reset=1;
			end
		LOAD_S:
			begin 
			if (Y==110)
				loadX = 1;
			loadY = 1;
			load_colour = 1;
			load_black = 0;
			en_counter = 0;
			en_delay_counter = 0;
			reset_delay = 0;
			plot = 0;
			en_reset=0;
			end
		DRAW_S:
			begin 
			loadX = 0;
			loadY = 0;
			load_colour = 0;
			load_black = 0;
			en_counter = 1;
			en_delay_counter = 0;
			reset_delay = 0;
			plot = 1;
			en_reset=0;
			end
		DONE_S:
			begin 
			loadX = 0;
			loadY = 0;
			load_colour = 0;
			load_black = 0;
			en_counter = 0;
			en_delay_counter = 1;
			reset_delay = 1;  //delay counter set to 0
			plot = 0;
			en_reset=0;
			end
		ERASE_S:
			begin 
			loadX = 0;
			loadY = 0;
			load_colour = 0;
			load_black = 1;
			en_counter = 1;
			en_delay_counter = 0;
			reset_delay = 0;
			plot = 1;
			en_reset=0;
			end

		default:
			begin 
			loadX = 0;
			loadY = 0;
			load_colour = 0;
			load_black = 0;
			en_counter = 0;
			plot = 0;
			en_delay_counter = 0;
			reset_delay = 0;
			en_reset=0;
			end
	endcase 
	end
	always @ (posedge CLOCK)
	begin:state_FFs 
			PresentState <= NextState;
	end
endmodule 
