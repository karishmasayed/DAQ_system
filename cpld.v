

`timescale 1ns / 1ps

module cpld_mod0 #(parameter DATA_SIZE=208) //208
(
input CLK,
input RESET,

input CLK_IN, 
input DFRM_IN,
input SER_DATA_IN, 

output SER_DATA_O,
output CLK_OUT,
output DFRM_O,
output load_to_FPGA,

input  MISO_0,
output MOSI_0,
output SCLK_0,
output CS_0,
 
input  MISO_1,
output MOSI_1,
output SCLK_1,
output CS_1,

input  MISO_2,
output MOSI_2,
output SCLK_2,
output CS_2,

output [7:0] temp
);

//===========================================================================================================================================================================
// DECLARATIONS
//===========================================================================================================================================================================
reg frame_out;
reg [7:0] out_cnt;
reg [7:0] in_cnt;
reg [207:0] out_reg;
reg [1:0] clk_div;

parameter HIGH_TIME=10'd4;
parameter LOW_TIME =10'd4;


//shift in
reg  s_frame_in_reg;
reg  [207:0] in_reg;
wire [DATA_SIZE-1:0] DATA_2_SEND_I;
reg  [DATA_SIZE-1:0]DATA_RECVD_O;

reg  [207:0] DATA_RECEVIED;

reg d_out;

reg sync0_CLK_IN;
reg sync1_CLK_IN;

reg sync0_DFRM_IN;
reg sync1_DFRM_IN;

reg sync0_SER_DATA_IN;
reg sync1_SER_DATA_IN;

reg sync0_CLK_OUT;
reg sync1_CLK_OUT;


wire posedge_CLK_IN;
wire posedge_DFRM_IN;
wire posedge_CLK_OUT;

wire [207:0] ser_mod_data;
reg  [207:0] mod_adc_data;
reg  send_mod_data;

reg [2:0] frame_count; 

wire all_ch_sampling_done;



reg MOSI_0_i;
reg SCLK_0_i;
reg CS_0_i;

reg MOSI_1_i;
reg SCLK_1_i;
reg CS_1_i;

reg MOSI_2_i;
reg SCLK_2_i;
reg CS_2_i;

reg [5:0] cycle_0;
reg [5:0] cycle_1;
reg [5:0] cycle_2;

reg [5:0] state_0;
reg [5:0] state_1;
reg [5:0] state_2;

reg [7:0] address_0;
reg [7:0] address_1;
reg [7:0] address_2;

reg [7:0] input_reg_0;
reg [7:0] input_reg_1;
reg [7:0] input_reg_2;

reg sclk_low_sync;
reg sclk_low_sync1;
reg sclk_low;

wire sclk_pos_edge;
wire sclk_neg_edge;

reg [9:0] h_count;
reg [9:0] l_count;

reg [3:0] delay_counter_0;
reg [3:0] delay_counter_1;
reg [3:0] delay_counter_2;

reg sclk_high;
reg  [4:0] channel_count;
wire [7:0] temp;

reg clk_start_0;
reg clk_start_1;
reg clk_start_2;

reg [7:0]  STAT1_read_0 ;
reg [7:0]  STAT1_status_read_0;
reg [7:0]  CTRL2_read_0 ;
reg [7:0]  CTRL2_status_read_0;
reg [15:0] CTRL2_mux_select_0;    
reg [15:0] CTRL1_config_0;
reg [7:0]  CTRL1_read_0;
reg [7:0]  CTRL1_status_read_0;


reg [7:0]  STAT1_read_1 ;
reg [7:0]  STAT1_status_read_1;
reg [7:0]  CTRL2_read_1 ;
reg [7:0]  CTRL2_status_read_1;
reg [15:0] CTRL2_mux_select_1;    
reg [15:0] CTRL1_config_1;
reg [7:0]  CTRL1_read_1;
reg [7:0]  CTRL1_status_read_1;


reg [7:0]  STAT1_read_2 ;
reg [7:0]  STAT1_status_read_2;
reg [7:0]  CTRL2_read_2 ;
reg [7:0]  CTRL2_status_read_2;
reg [15:0] CTRL2_mux_select_2;    
reg [15:0] CTRL1_config_2;
reg [7:0]  CTRL1_read_2;
reg [7:0]  CTRL1_status_read_2;


reg [23:0] ADC_channel_reg_0;
reg [23:0] ADC_channel_reg_1;
reg [23:0] ADC_channel_reg_2;

reg [23:0] ADC_channel_0;
reg [23:0] ADC_channel_1;
reg [23:0] ADC_channel_2;
reg [23:0] ADC_channel_3;
reg [23:0] ADC_channel_4;
reg [23:0] ADC_channel_5;
reg [23:0] ADC_channel_6;
reg [23:0] ADC_channel_7;

reg conversion_done_0;
reg convo_done_0;

reg conversion_done_1;
reg convo_done_1;

reg conversion_done_2;
reg convo_done_2;

reg [7:0]  DATA_read_0;
reg [23:0] data_reg_0;
reg [7:0]  stat1_reg_0;
reg [7:0]  ctrl1_reg_0;
reg [7:0]  ctrl2_reg_0;

reg [7:0]  DATA_read_1;
reg [23:0] data_reg_1;
reg [7:0]  stat1_reg_1;
reg [7:0]  ctrl1_reg_1;
reg [7:0]  ctrl2_reg_1;

reg [7:0]  DATA_read_2;
reg [23:0] data_reg_2;
reg [7:0]  stat1_reg_2;
reg [7:0]  ctrl1_reg_2;
reg [7:0]  ctrl2_reg_2;

reg [7:0] ini_conv_cmd_0;
reg [7:0] ini_conv_cmd_1;
reg [7:0] ini_conv_cmd_2;

reg [4:0] convo_count_0;
reg [4:0] convo_count_1;
reg [4:0] convo_count_2;

reg trig;
reg [23:0] con_time_cnt;
reg [23:0] con_time;
reg load;

reg load_0;
reg load_1;
reg load_2;

reg [2:0] ch_count_0;
reg [2:0] ch_count_2;
reg [2:0] ch_count_1;

reg new_value;

reg new_value_0;
reg new_value_1;
reg new_value_2;

reg adc_0_done;
reg adc_1_done;
reg adc_2_done;

wire all_conversion_done;


//========================================================================================================================================================================
// OUTPUT ASSIGNMENT
//=========================================================================================================================================================================

assign CLK_OUT = CLK_IN;
assign DFRM_O = frame_out;
assign SER_DATA_O = d_out;//out_reg[0];

assign load_to_FPGA = new_value;

assign MOSI_0 = MOSI_0_i;
assign CS_0 = CS_0_i;
assign SCLK_0 = SCLK_0_i;

assign MOSI_1 = MOSI_1_i;
assign CS_1 = CS_1_i;
assign SCLK_1 = SCLK_1_i;

assign MOSI_2 = MOSI_2_i;
assign CS_2 = CS_2_i;
assign SCLK_2 = SCLK_2_i;

assign temp = in_reg;
//========================================================================================================================================================================
// DUAL RANK SYNCHRONIZER
//========================================================================================================================================================================

always @(posedge CLK or negedge RESET)
begin
	if(~RESET) begin
	     sync0_CLK_IN <= 0;
         sync1_CLK_IN <= 0;
	end
	else begin
		 sync0_CLK_IN <= CLK_IN;
         sync1_CLK_IN <= sync0_CLK_IN ;
        end
end
assign posedge_CLK_IN = sync0_CLK_IN & ~sync1_CLK_IN;

always @(posedge CLK or negedge RESET)
begin
	if(~RESET) begin
	     sync0_SER_DATA_IN <= 0;
         sync1_SER_DATA_IN <= 0;
	end
	else begin
		 sync0_SER_DATA_IN <= SER_DATA_IN;
         sync1_SER_DATA_IN <= sync0_SER_DATA_IN ;
        end
end

always @(posedge CLK or negedge RESET)
begin
	if(~RESET) begin
	     sync0_DFRM_IN <= 0;
         sync1_DFRM_IN <= 0;
	end
	else begin
		 sync0_DFRM_IN <= DFRM_IN;
         sync1_DFRM_IN <= sync0_DFRM_IN ;
        end
end
assign posedge_DFRM_IN = sync0_DFRM_IN & ~sync1_DFRM_IN;

always @(posedge CLK or negedge RESET)
begin
	if(~RESET) begin
	     sync0_CLK_OUT <= 0;
         sync1_CLK_OUT <= 0;
	end
	else begin
		 sync0_CLK_OUT <= CLK_OUT;
         sync1_CLK_OUT <= sync0_CLK_OUT ;
        end
end

assign posedge_CLK_OUT = sync0_CLK_OUT & ~sync1_CLK_OUT;

//======================================================================================================================================================================
// CLOCK GENERATION
//======================================================================================================================================================================

always @(posedge CLK or negedge RESET) begin
if (~RESET) begin
   SCLK_0_i <= 1'b0;
  end
  else if(clk_start_0 == 1'b1 && sclk_low == 1'b1)    
      SCLK_0_i <= sclk_low;
      else
      SCLK_0_i <= 1'b0;
end


always @(posedge CLK or negedge RESET) begin
if (~RESET) begin
   SCLK_1_i <= 1'b0;
  end
  else if(clk_start_1 == 1'b1 && sclk_low == 1'b1)    
      SCLK_1_i <= sclk_low;
      else
      SCLK_1_i <= 1'b0;
end


always @(posedge CLK or negedge RESET) begin
if (~RESET) begin
   SCLK_2_i <= 1'b0;
  end
  else if(clk_start_2 == 1'b1 && sclk_low == 1'b1)    
      SCLK_2_i <= sclk_low;
      else
      SCLK_2_i <= 1'b0;
end

always @(posedge CLK or negedge RESET) begin 
	if (~RESET) begin 
		sclk_low_sync <= 1'b0;
		sclk_low_sync1 <= 1'b0;	   
	end
	else begin 
		sclk_low_sync <= sclk_low;
		sclk_low_sync1 <= sclk_low_sync;
	end 
end 

 assign sclk_pos_edge =  sclk_low  & ~sclk_low_sync;
 assign sclk_neg_edge = ~sclk_low  &  sclk_low_sync;
 
always @(posedge CLK or negedge RESET) begin 
	if (~RESET) begin 
 		h_count <= 10'b0;
		l_count <= 10'b0;	
	end
	else if (sclk_low == 1'b0) begin
		h_count <= h_count+1'b1;
		l_count <= 10'b0;
	end
	else if (sclk_high == 1'b0) begin
		l_count <= l_count + 1'b1;
		h_count <= 10'b0;
	end
	else begin 
		h_count <= 10'b0;
		l_count <= 10'b0;
	end
end 

always @(posedge CLK or negedge RESET)begin 
	if (~RESET) begin 
		sclk_high <= 1'b1;
		sclk_low <= 1'b0;
	end
	else if (h_count == HIGH_TIME) begin 
		sclk_high<=1'b0;
		sclk_low<=1'b1;
	end 
	else if (l_count ==  LOW_TIME) begin
		sclk_high <= 1'b1;
		sclk_low <= 1'b0;
    end
end 

//=========================================================================================================================================================================
// SPI PROGRAM
//=========================================================================================================================================================================
/*
always @(posedge CLK or negedge RESET) begin
	if(~RESET) begin
		ADC_channel_0 <= 0;
        ADC_channel_1 <= 0;
        ADC_channel_2 <= 0;
		end
		else begin
			if (state == 6'd24 && convo_count == 5'd2)
				 ADC_channel_0 <=  ADC_channel;
		    if (state == 6'd24 && convo_count == 5'd5)
				 ADC_channel_1 <=  ADC_channel;
            if (state == 6'd24 && convo_count == 5'd8)
				 ADC_channel_2 <=  ADC_channel;				 			
			end
	end
*/
/*
J4  : CTRL2_mux_select_0   <= 16'hC4F2;
J5  : CTRL2_mux_select_0   <= 16'hC4F6;
J3  : CTRL2_mux_select_0   <= 16'hC4F4;
J15 : CTRL2_mux_select_1   <= 16'hC4F2;
J16 : CTRL2_mux_select_1   <= 16'hC4F6;
J14 : CTRL2_mux_select_1   <= 16'hC4F4;
J8  : CTRL2_mux_select_2   <= 16'hC4F2;
J7  : CTRL2_mux_select_2   <= 16'hC4F4;
*/

always @(negedge CLK or negedge RESET) begin
	if(~RESET) begin
		MOSI_0_i             <= 1'b0;
		state_0              <= 6'd0;
		CS_0_i               <= 1'b1;
		clk_start_0          <= 1'd0;
		address_0            <= 8'h02;
		cycle_0              <= 6'd0;
		STAT1_status_read_0  <= 0;
		STAT1_read_0         <= 8'hC1;
		CTRL1_config_0       <= 16'hC2FE;   ////CTRL1_config_0       <= 16'hC2BE;  
		CTRL1_read_0         <= 8'hC3;
		CTRL2_read_0         <= 8'hC5;       //1100 0101 ///right
		CTRL2_status_read_0  <= 0;
	    CTRL1_status_read_0  <= 0;
        CTRL2_mux_select_0   <= 16'hC4F4;    ///1100 0100 1111 0100
        delay_counter_0      <= 0;
		ADC_channel_reg_0    <= 24'd0;
		ini_conv_cmd_0       <= 8'h83;     //// 1000 0111
		conversion_done_0    <= 0;
		DATA_read_0          <= 8'hC9;    //// 1100 1001
		data_reg_0           <= 24'd0;
		stat1_reg_0          <= 0;
		convo_done_0         <= 1;
		convo_count_0        <= 0;
		ADC_channel_0        <= 0;
        ADC_channel_1        <= 0;
        ADC_channel_2        <= 0;
		load_0               <= 1'b0;
		ch_count_0           <= 0;
		adc_0_done           <= 0;
	end
	else begin
		case(state_0) 		
			6'd0: begin
				  MOSI_0_i            <= 1'b0;
				  CS_0_i              <= 1'd1;
				  state_0             <= 6'd1;	
				  clk_start_0         <= 1'd0;
				  cycle_0             <= 6'd0;
				  delay_counter_0     <= 0;
				  conversion_done_0   <= 0;
				  data_reg_0          <= 24'd0;
				  CTRL1_config_0      <= 16'hC2FE;
				  CTRL2_mux_select_0  <= 16'hC4F4; 
                  DATA_read_0         <= 8'hC9;	
                  ini_conv_cmd_0      <= 8'h83; 
				  if (ch_count_0 == 0)
				      CTRL2_mux_select_0  <= 16'hC4F2;
				  if (ch_count_0 == 1)
				      CTRL2_mux_select_0  <= 16'hC4F6;
                  if (ch_count_0 == 2)
				      CTRL2_mux_select_0  <= 16'hC4F4;		/////////////////////-----------------------------------------------    					  
			      end
			
            6'd1:begin     
						if(delay_counter_0 < 4'd9) begin
							delay_counter_0 <= delay_counter_0+1;
							state_0         <= 6'd1;
                        end
						else
							delay_counter_0 <= 4'b0;    
					    if(delay_counter_0 == 4'd9 ) begin
							state_0 <= 6'd2;
							CS_0_i  <= 1'b1;
						end
					end  
					
			6'd2:begin     
				   if(sclk_neg_edge == 1'd1) begin
					  if(cycle_0 == 6'd16)  begin
						 state_0     <= 6'd3;
						 cycle_0     <= 6'd0;
						 CS_0_i      <= 1'd0;
						 clk_start_0 <= 1'd0;
						 end
				      else begin
						 MOSI_0_i    <= CTRL1_config_0[10'd15-cycle_0];
						 CS_0_i      <= 1'b0;
						 clk_start_0 <= 1'd1;
						 cycle_0     <= cycle_0+1;
						 state_0     <= 6'd2;
						 end 
			        end		
				end    
				
			6'd3:begin     
						if(delay_counter_0 < 4'd9) begin
							delay_counter_0 <= delay_counter_0+1;
							state_0         <= 6'd3;
							CS_0_i          <= 1'd1;
                        end
						else
							delay_counter_0 <= 4'b0;    
					    if(delay_counter_0 == 4'd9 ) begin
							state_0 <= 6'd4;
							CS_0_i  <= 1'b1;
						end
					end  
					
			6'd4:begin     
				   if(sclk_neg_edge == 1'd1) begin
					  if(cycle_0 == 6'd16)  begin
						 state_0     <= 6'd5;
						 cycle_0     <= 6'd0;
						 CS_0_i      <= 1'd0;
						 clk_start_0 <= 1'd0;
						 end
				      else begin
						 MOSI_0_i    <= CTRL2_mux_select_0[10'd15-cycle_0];
						 CS_0_i      <= 1'b0;
						 clk_start_0 <= 1'd1;
						 cycle_0     <= cycle_0+1;
						 state_0     <= 6'd4;
						 end 
			        end		
				end    
				
			6'd5:begin     
						if(delay_counter_0 < 4'd9) begin
							delay_counter_0 <= delay_counter_0+1;
							state_0         <= 6'd5;
							CS_0_i          <= 1'd1;
                        end
						else
							delay_counter_0 <= 4'b0;    
					    if(delay_counter_0 == 4'd9 ) begin
							state_0 <= 6'd6;
							CS_0_i  <= 1'b1;
						end
					end  			
			
			6'd6:begin     
				   if(sclk_neg_edge == 1'd1) begin
					  if(cycle_0 == 6'd8)  begin
						state_0     <= 6'd7;
						cycle_0     <= 6'd0;
						CS_0_i      <= 1'd0;
						clk_start_0 <= 1'd0; ////////////////////////////////////
						end
				      else begin
						MOSI_0_i    <= ini_conv_cmd_0[10'd7-cycle_0];
						CS_0_i      <= 1'b0;
						clk_start_0 <= 1'd1;
						cycle_0     <= cycle_0+1;
						state_0     <= 6'd6;
						end 
			        end		
				end    
				
			6'd7:begin     
						if(delay_counter_0 < 4'd9) begin
							delay_counter_0 <= delay_counter_0+1;
							state_0         <= 6'd7;
							CS_0_i          <= 1'd1;   ////////////////////////////
                        end
						else
							delay_counter_0 <= 4'b0;    
					    if(delay_counter_0 == 4'd9 ) begin
							state_0 <= 6'd8;
							CS_0_i  <= 1'b0;
 						end
					end 
		
		
			6'd8:	begin 
				           if (MISO_0 == 0) begin
                                conversion_done_0 <= 1;
								convo_count_0     <= convo_count_0 + 1 ;
								CS_0_i            <= 1'b1;
								state_0           <= 6'd9;	
							end	
                            else begin 
                                conversion_done_0 <= 0;	
                                state_0 <= 6'd8;
                                CS_0_i  <= 1'b0;								
			        	    end
					end		        	
						
			6'd9:   begin     
						if(delay_counter_0 < 4'd9) begin
							delay_counter_0 <= delay_counter_0+1;
							state_0         <= 6'd9;
							CS_0_i          <= 1'b1;
                        end
						else
							delay_counter_0 <= 4'b0;    
					    if(delay_counter_0 == 4'd9 ) begin
							state_0 <= 6'd10;
							CS_0_i  <= 1'b1;
						end
					end   
			
					
			6'd10:  begin 
			        if(sclk_neg_edge == 1'd1 && conversion_done_0 == 1'd1 ) begin
					  if(cycle_0 == 5'd8)  begin
						 state_0 <= 6'd11;
						 cycle_0 <= 6'd0;
						 CS_0_i  <= 1'd0;
						 end
				      else begin
						MOSI_0_i    <= DATA_read_0[10'd7-cycle_0];
						CS_0_i      <= 1'b0;
						clk_start_0 <= 1'd1;
						cycle_0     <= cycle_0+1;
						state_0     <= 6'd10;
						end 
			         end		
			      end
            	        	
			6'd11:begin     
						if(delay_counter_0 < 4'd4) begin
							delay_counter_0 <= delay_counter_0+1;
							state_0         <= 6'd11;
							CS_0_i          <= 1'b0;
							load_0          <= 1'b1;
                        end
						else
							delay_counter_0 <= 4'b0;    
					    if(delay_counter_0 == 4'd4) begin
							state_0     <= 6'd12;
							CS_0_i      <= 1'b0;
							load_0      <= 1'b1;
							new_value_0 <=1'b1;
						end
					end 
					
		   	6'd12: begin
				  CS_0_i <= 1'b0;
				  MOSI_0_i <= 1'd0;
				  //if(cycle_0 == 6'd24) begin
			             // CS_0_i <= 1'd1; ////////////////////////
						 // clk_start_0 <= 1'd0;
			              //end 
			      if(sclk_pos_edge == 1'd1) begin
					 if(cycle_0 == 5'd24)  begin
						state_0           <= 6'd13;
						cycle_0           <= 6'd0;
						ADC_channel_reg_0 <= data_reg_0;
						CS_0_i            <= 1'd0;
						clk_start_0       <= 1'd0;
						end
					  else begin
						 data_reg_0[10'd23-cycle_0] <= MISO_0;
						 cycle_0 <= cycle_0+1;
						 state_0 <= 6'd12;
						
					     end 
			        end
			      end	
			
			6'd13: begin     
						if(delay_counter_0 < 4'd9) begin
							delay_counter_0 <= delay_counter_0+1;
							state_0 <= 6'd13;
							CS_0_i  <= 1'b1;
						
                        end
						else
							delay_counter_0 <= 4'b0;    
					    if(delay_counter_0 == 4'd9 ) begin
							state_0 <= 6'd14;
							CS_0_i  <= 1'b1;
							//ADC_channel_0 <= ADC_channel_reg_0;
							if(ch_count_0 == 0) begin
							    ADC_channel_0 <= ADC_channel_reg_0;
								end
							if(ch_count_0 == 1) begin
							    ADC_channel_1 <= ADC_channel_reg_0;
								adc_0_done <= 0;
								end
							if(ch_count_0 == 2) begin
							    ADC_channel_2 <= ADC_channel_reg_0;	
								end
                           //*/			//		-----------------------------------------------------------------------------------------			
						
						end
					end   
			
			6'd14: begin    
				            ch_count_0 <= ch_count_0 + 1;
							/*	
							if(ch_count_0 == 0) begin
							    ADC_channel_0 <= ADC_channel_reg_0;
								adc_0_done <= 0;
								end
							if(ch_count_0 == 1) 
							    ADC_channel_1 <= ADC_channel_reg_0;
							if(ch_count_0 == 2)
							    ADC_channel_2 <= ADC_channel_reg_0;	
								*////////---------------------------------------------------
								
                            state_0 <= 6'd15;							
					end  
					
			6'd15:begin     
						if(delay_counter_0 < 4'd9) begin
							delay_counter_0     <= delay_counter_0+1;
							state_0             <= 6'd15;
							CS_0_i              <= 1'b1;
							conversion_done_0   <= 0;	
							MOSI_0_i            <= 1'b0;
				            clk_start_0         <= 1'd0;
				            cycle_0             <= 6'd0;
				            conversion_done_0   <= 0;
				            data_reg_0          <= 24'd0;
							
                        end
						else 
							delay_counter_0 <= 4'b0;  
					    if(delay_counter_0 == 4'd9 ) begin
							state_0      <= 6'd0;
							CS_0_i       <= 1'b1;
							convo_done_0 <= 1;
							new_value_0  <=1'b0;
							if(ch_count_0 == 3) begin
								ch_count_0 <= 0;
								adc_0_done <= 1;
							    end
						    /*ch_count_0 <= ch_count_0 + 1;
							  if(ch_count_0 == 3) begin
								ch_count_0 <= 0;
								adc_0_done <= 1;
							end *////////////////////////-----------------------------------
						
						end
					end  	
										
            endcase
       end						
end

  ///////--------------------------------------------------------

//================================================================================================================================================================
// SPI_1 PROGRAM
//=================================================================================================================================================================


always @(negedge CLK or negedge RESET) begin
	if(~RESET) begin
		MOSI_1_i <= 1'b0;
		state_1  <= 6'd0;
		CS_1_i   <= 1'b1;
		clk_start_1         <= 1'd0;
		address_1           <= 8'h02;
		cycle_1             <= 6'd0;
		input_reg_1           <= 8'd0;
		//temp              <= 8'd0;
		STAT1_status_read_1  <= 0;
		STAT1_read_1         <= 8'hC1;
		CTRL1_config_1       <= 16'hC2FE;  
		CTRL1_read_1         <= 8'hC3;
		CTRL2_read_1         <= 8'hC5;       //1100 0101 ///right
		CTRL2_status_read_1  <= 0;
	    CTRL1_status_read_1  <= 0;
        CTRL2_mux_select_1   <= 16'hC4F4;    ///1100 0100 1111 0100
        delay_counter_1      <= 0;
		ADC_channel_reg_1    <= 24'd0;
		ini_conv_cmd_1       <= 8'h83;     //// 1000 0111
		conversion_done_1    <= 0;
		DATA_read_1          <= 8'hC9;    //// 1100 1001
		data_reg_1           <= 24'd0;
		stat1_reg_1          <= 0;
		convo_done_1         <= 1;
		convo_count_1        <= 0;
		ADC_channel_3        <= 0;
        ADC_channel_4        <= 0;
        ADC_channel_5        <= 0;
		load_1               <= 1'b0;
		ch_count_1           <= 0;
	end
	else begin
		case(state_1) 
		
			6'd0: begin
				  MOSI_1_i <= 1'b0;
				  CS_1_i   <= 1'd1;
				  state_1  <= 6'd1;	
				  clk_start_1         <= 1'd0;
				  cycle_1             <= 6'd0;
		          input_reg_1         <= 8'd0;
				  delay_counter_1     <= 0;
				  conversion_done_1   <= 0;
				  data_reg_1          <= 24'd0;
				  CTRL1_config_1      <= 16'hC2FE;
				  CTRL2_mux_select_1  <= 16'hC4F4; 
                  DATA_read_1         <= 8'hC9;	
                  ini_conv_cmd_1      <= 8'h83; 
				  if (ch_count_1 == 0)
				      CTRL2_mux_select_1  <= 16'hC4F2;
				  if (ch_count_1 == 1)
				      CTRL2_mux_select_1  <= 16'hC4F6;
                  if (ch_count_1 == 2)
				      CTRL2_mux_select_1  <= 16'hC4F4;	 
			      end
			
            6'd1:begin     
						if(delay_counter_1 < 4'd9) begin
							delay_counter_1 <= delay_counter_1+1;
							state_1         <= 6'd1;
                        end
						else
							delay_counter_1 <= 4'b0;    
					    if(delay_counter_1 == 4'd9 ) begin
							state_1 <= 6'd2;
							CS_1_i  <= 1'b1;
						end
					end  
					
			6'd2:begin     
				   if(sclk_neg_edge == 1'd1) begin
					  if(cycle_1 == 6'd16)  begin
						state_1     <= 6'd3;
						cycle_1     <= 6'd0;
						CS_1_i      <= 1'd0;
						clk_start_1 <= 1'd0;
						end
				      else begin
						MOSI_1_i    <= CTRL1_config_1[10'd15-cycle_1];
						CS_1_i      <= 1'b0;
						clk_start_1 <= 1'd1;
						cycle_1     <= cycle_1+1;
						state_1     <= 6'd2;
						end 
			        end		
				end    
				
			6'd3:begin     
						if(delay_counter_1 < 4'd9) begin
							delay_counter_1 <= delay_counter_1+1;
							state_1         <= 6'd3;
							CS_1_i          <= 1'd1;
                        end
						else
							delay_counter_1 <= 4'b0;    
					    if(delay_counter_1 == 4'd9 ) begin
							state_1 <= 6'd4;
							CS_1_i  <= 1'b1;
						end
					end  
					
			6'd4:begin     
				   if(sclk_neg_edge == 1'd1) begin
					  if(cycle_1 == 6'd16)  begin
						state_1     <= 6'd5;
						cycle_1     <= 6'd0;
						CS_1_i      <= 1'd0;
						clk_start_1 <= 1'd0;
						end
				      else begin
						MOSI_1_i    <= CTRL2_mux_select_1[10'd15-cycle_1];
						CS_1_i      <= 1'b0;
						clk_start_1 <= 1'd1;
						cycle_1     <= cycle_1+1;
						state_1     <= 6'd4;
						end 
			        end		
				end    
				
			6'd5:begin     
						if(delay_counter_1 < 4'd9) begin
							delay_counter_1 <= delay_counter_1+1;
							state_1         <= 6'd5;
							CS_1_i          <= 1'd1;
                        end
						else
							delay_counter_1 <= 4'b0;    
					    if(delay_counter_1 == 4'd9 ) begin
							state_1 <= 6'd6;
							CS_1_i  <= 1'b1;
						end
					end  			
			
			6'd6:begin     
				   if(sclk_neg_edge == 1'd1) begin
					  if(cycle_1 == 6'd8)  begin
						state_1     <= 6'd7;
						cycle_1     <= 6'd0;
						CS_1_i      <= 1'd0;
						clk_start_1 <= 1'd0;
						end
				      else begin
						MOSI_1_i    <= ini_conv_cmd_1[10'd7-cycle_1];
						CS_1_i      <= 1'b0;
						clk_start_1 <= 1'd1;
						cycle_1     <= cycle_1+1;
						state_1     <= 6'd6;
						end 
			        end		
				end    
				
			6'd7:begin     
						if(delay_counter_1 < 4'd9) begin
							delay_counter_1 <= delay_counter_1+1;
							state_1         <= 6'd7;
							CS_1_i          <= 1'd1;
                        end
						else
							delay_counter_1 <= 4'b0;    
					    if(delay_counter_1 == 4'd9 ) begin
							state_1 <= 6'd8;
							CS_1_i  <= 1'b0;
 						end
					end 
		
		
			6'd8:	begin 
				           if (MISO_1 == 0) begin
                                conversion_done_1 <= 1;
								CS_1_i            <= 1'b1;
								state_1           <= 6'd9;	
							end	
                            else begin 
                                conversion_done_1 <= 0;	
                                state_1           <= 6'd8;
                                CS_1_i            <= 1'b0;								
			        	    end
					end		        	
						
			6'd9:   begin     
						if(delay_counter_1 < 4'd9) begin
							delay_counter_1 <= delay_counter_1+1;
							state_1         <= 6'd9;
							CS_1_i          <= 1'b1;
                        end
						else
							delay_counter_1 <= 4'b0;    
					    if(delay_counter_1 == 4'd9 ) begin
							state_1 <= 6'd10;
							CS_1_i  <= 1'b1;
						end
					end   
			
					
			6'd10:  begin 
			        if(sclk_neg_edge == 1'd1 && conversion_done_1 == 1'd1 ) begin
					  if(cycle_1 == 5'd8)  begin
						 state_1 <= 6'd11;
						 cycle_1 <= 6'd0;
						 CS_1_i  <= 1'd0;
						 end
				      else begin
						MOSI_1_i    <= DATA_read_1[10'd7-cycle_1];
						CS_1_i      <= 1'b0;
						clk_start_1 <= 1'd1;
						cycle_1     <= cycle_1+1;
						state_1     <= 6'd10;
						end 
			         end		
			      end
            	        	
			6'd11:begin     
						if(delay_counter_1 < 4'd4) begin
							delay_counter_1 <= delay_counter_1+1;
							state_1         <= 6'd11;
							CS_1_i          <= 1'b0;
							load_1          <= 1'b1;
                        end
						else
							delay_counter_1 <= 4'b0;    
					    if(delay_counter_1 == 4'd4) begin
							state_1     <= 6'd12;
							CS_1_i      <= 1'b0;
							load_1      <= 1'b1;
							new_value_1 <=1'b1;
						end
					end 
					
		   	6'd12: begin
				  CS_1_i   <= 1'b0;
				  MOSI_1_i <= 1'd0;
				//  if(cycle_1 == 6'd24) begin
			      //        CS_1_i <= 1'd0;
					//	  clk_start_1 <= 1'd0;
			          //    end 
			      if(sclk_pos_edge == 1'd1) begin
					 if(cycle_1 == 5'd24)  begin
						state_1 <= 6'd13;
						cycle_1 <= 6'd0;
						ADC_channel_reg_1 <= data_reg_1;
						CS_1_i      <= 1'd0;
						clk_start_1 <= 1'd0;
						end
					  else begin
						 data_reg_1[10'd23-cycle_1] <= MISO_1;
						 cycle_1 <= cycle_1+1;
						 state_1 <= 6'd12;						
					     end 
			        end
			      end	
			
			6'd13: begin     
						if(delay_counter_1 < 4'd9) begin
							delay_counter_1 <= delay_counter_1+1;
							state_1 <= 6'd13;
							CS_1_i <= 1'b1;
						
                        end
						else
							delay_counter_1 <= 4'b0;    
					    if(delay_counter_1 == 4'd9 ) begin
							state_1 <= 6'd14;
							CS_1_i <= 1'b1;
							//ADC_channel_3 <= ADC_channel_reg_1;
							if(ch_count_1 == 0) begin
							    ADC_channel_3 <= ADC_channel_reg_1;
								end
							if(ch_count_1 == 1) begin
							    ADC_channel_4 <= ADC_channel_reg_1;
								adc_1_done <= 0;
								end
							if(ch_count_1 == 2) begin
							    ADC_channel_5 <= ADC_channel_reg_1;	
								end
						end
					end   
					
				6'd14: begin    
				            ch_count_1 <= ch_count_1 + 1;
                            state_1 <= 6'd15;							
					end  
					
			6'd15:begin     
						if(delay_counter_1 < 4'd9) begin
							delay_counter_1 <= delay_counter_1+1;
							state_1   <= 6'd15;
							CS_1_i    <= 1'b1;
							conversion_done_1 <= 0;	
							MOSI_1_i            <= 1'b0;
				            clk_start_1         <= 1'd0;
				            cycle_1             <= 6'd0;
		                   // input_reg_1         <= 8'd0;
				            conversion_done_1   <= 0;
				            data_reg_1          <= 24'd0;
                        end
						else
							delay_counter_1 <= 4'b0;    
					    if(delay_counter_1 == 4'd9 ) begin
							state_1      <= 6'd0;
							CS_1_i       <= 1'b1;
							convo_done_1 <= 1;
							new_value_1  <=1'b0;
							if(ch_count_1 == 3) begin
								ch_count_1 <= 0;
								adc_1_done <= 1;
							    end
							/*ch_count_1 <= ch_count_1 + 1;
							if(ch_count_1 <= 3) begin
								ch_count_1 <= 0;
								adc_1_done <= 1;
							end */ 
						end
					end  	
										
            endcase
       end						
end

//================================================================================================================================================================
// SPI_2 PROGRAMME
//=================================================================================================================================================================

always @(negedge CLK or negedge RESET) begin
	if(~RESET) begin
		MOSI_2_i <= 1'b0;
		state_2  <= 6'd0;
		CS_2_i   <= 1'b1;
		clk_start_2          <= 1'd0;
		address_2            <= 8'h02;
		cycle_2              <= 6'd0;
		input_reg_2          <= 8'd0;
		STAT1_status_read_2  <= 0;
		STAT1_read_2         <= 8'hC1;
		CTRL1_config_2       <= 16'hC2FE;  
		CTRL1_read_2         <= 8'hC3;
		CTRL2_read_2         <= 8'hC5;       //1100 0101 ///right
		CTRL2_status_read_2  <= 0;
	    CTRL1_status_read_2  <= 0;
        CTRL2_mux_select_2   <= 16'hC4F4;    ///1100 0100 1111 0100
        delay_counter_2      <= 0;
		ADC_channel_reg_2    <= 24'd0;
		ini_conv_cmd_2       <= 8'h83;     //// 1000 0111
		conversion_done_2    <= 0;
		DATA_read_2          <= 8'hC9;    //// 1100 1001
		data_reg_2           <= 24'd0;
		stat1_reg_2          <= 0;
		convo_done_2         <= 1;
		convo_count_2        <= 0;
		///trig                <= 0;
		ADC_channel_6        <= 0;
        ADC_channel_7        <= 0;
       //// ADC_channel_5 <= 0;
		load_2               <= 1'b0;
		ch_count_2           <= 0;
	end
	else begin
		case(state_2) 
		
			6'd0: begin
				  MOSI_2_i <= 1'b0;
				  CS_2_i   <= 1'd1;
				  state_2  <= 6'd1;	
				  clk_start_2         <= 1'd0;
				  cycle_2             <= 6'd0;
				  delay_counter_2     <= 0;
				  conversion_done_2   <= 0;
				  data_reg_2          <= 24'd0;
				  CTRL1_config_2      <= 16'hC2FE;
				  CTRL2_mux_select_2  <= 16'hC4F4; 
                  DATA_read_2         <= 8'hC9;	
                  ini_conv_cmd_2      <= 8'h83;   				  
				  if (ch_count_2 == 0)
				      CTRL2_mux_select_2  <= 16'hC4F2;
				  if (ch_count_2 == 1)
				      CTRL2_mux_select_2  <= 16'hC4F4;  
			      end
			
            6'd1:begin     
						if(delay_counter_2 < 4'd9) begin
							delay_counter_2 <= delay_counter_2+1;
							state_2         <= 6'd1;
                        end
						else
							delay_counter_2 <= 4'b0;    
					    if(delay_counter_2 == 4'd9 ) begin
							state_2 <= 6'd2;
							CS_2_i  <= 1'b1;
						end
					end  
					
			6'd2:begin     
				   if(sclk_neg_edge == 1'd1) begin
					  if(cycle_2== 6'd16)  begin
						state_2     <= 6'd3;
						cycle_2     <= 6'd0;
						CS_2_i      <= 1'd0;
						clk_start_2 <= 1'd0;
						end
				      else begin
						MOSI_2_i    <= CTRL1_config_2[10'd15-cycle_1];
						CS_2_i      <= 1'b0;
						clk_start_2 <= 1'd1;
						cycle_2     <= cycle_2+1;
						state_2     <= 6'd2;
						end 
			        end		
				end    
				
			6'd3:begin     
						if(delay_counter_2 < 4'd9) begin
							delay_counter_2 <= delay_counter_2+1;
							state_2         <= 6'd3;
							CS_2_i          <= 1'd1;
                        end
						else
							delay_counter_2 <= 4'b0;    
					    if(delay_counter_2 == 4'd9 ) begin
							state_2 <= 6'd4;
							CS_2_i  <= 1'b1;
						end
					end  
					
			6'd4:begin     
				   if(sclk_neg_edge == 1'd1) begin
					  if(cycle_2== 6'd16)  begin
						state_2     <= 6'd5;
						cycle_2     <= 6'd0;
						CS_2_i      <= 1'd0;
						clk_start_2 <= 1'd0;
						end
				      else begin
						MOSI_2_i    <= CTRL2_mux_select_2[10'd15-cycle_1];
						CS_2_i      <= 1'b0;
						clk_start_2 <= 1'd1;
						cycle_2     <= cycle_2+1;
						state_2     <= 6'd4;
						end 
			        end		
				end    
				
			6'd5:begin     
						if(delay_counter_2 < 4'd9) begin
							delay_counter_2 <= delay_counter_2+1;
							state_2         <= 6'd5;
							CS_2_i          <= 1'd1;
                        end
						else
							delay_counter_2 <= 4'b0;    
					    if(delay_counter_2 == 4'd9 ) begin
							state_2 <= 6'd6;
							CS_2_i  <= 1'b1;
						end
					end  			
			
	      	6'd6:begin     
				   if(sclk_neg_edge == 1'd1) begin
					  if(cycle_2 == 6'd8)  begin
						state_2     <= 6'd7;
						cycle_2     <= 6'd0;
						CS_2_i      <= 1'd0;
						clk_start_2 <= 1'd0;
						end
				      else begin
						MOSI_2_i    <= ini_conv_cmd_2[10'd7-cycle_2];
						CS_2_i      <= 1'b0;
						clk_start_2 <= 1'd1;
						cycle_2     <= cycle_2+1;
						state_2     <= 6'd6;
						end 
			        end		
				end    
				
			6'd7:begin     
						if(delay_counter_2 < 4'd9) begin
							delay_counter_2 <= delay_counter_2+1;
							state_2 <= 6'd7;
							CS_2_i  <= 1'd1;
                        end
						else
							delay_counter_2 <= 4'b0;    
					    if(delay_counter_2 == 4'd9 ) begin
							state_2 <= 6'd8;
							CS_2_i  <= 1'b0;
 						end
					end 
		
		
			6'd8:	begin 
				           if (MISO_2 == 0) begin
                                conversion_done_2 <= 1;
								CS_2_i  <= 1'b1;
								state_2 <= 6'd9;	
							end	
                            else begin 
                                conversion_done_2 <= 0;	
                                state_2 <= 6'd8;
                                CS_2_i  <= 1'b0;								
			        	    end
					end		        	
						
			6'd9:   begin     
						if(delay_counter_2 < 4'd9) begin
							delay_counter_2 <= delay_counter_2+1;
							state_2 <= 6'd9;
							CS_2_i  <= 1'b1;
                        end
						else
							delay_counter_2 <= 4'b0;    
					    if(delay_counter_2 == 4'd9 ) begin
							state_2 <= 6'd10;
							CS_2_i  <= 1'b1;
						end
					end   
			
					
			6'd10:  begin 
			        if(sclk_neg_edge == 1'd1 && conversion_done_2 == 1'd1 ) begin
					  if(cycle_2== 5'd8)  begin
						 state_2 <= 6'd11;
						 cycle_2 <= 6'd0;
						 CS_2_i  <= 1'd0;
						 end
				      else begin
						MOSI_2_i    <= DATA_read_2[10'd7-cycle_2];
						CS_2_i      <= 1'b0;
						clk_start_2 <= 1'd1;
						cycle_2     <= cycle_2+1;
						state_2     <= 6'd10;
						end 
			         end		
			      end
            	        	
			6'd11:begin     
						if(delay_counter_2 < 4'd4) begin
							delay_counter_2 <= delay_counter_2+1;
							state_2 <= 6'd11;
							CS_2_i  <= 1'b0;
							load_2  <= 1'b1;
                        end
						else
							delay_counter_2 <= 4'b0;    
					    if(delay_counter_2 == 4'd4) begin
							state_2 <= 6'd12;
							CS_2_i  <= 1'b0;
							load_2  <= 1'b1;
							//new_value_1 <=1'b1;
						end
					end 
					
		   	6'd12: begin
				  CS_2_i <= 1'b0;
				  MOSI_2_i <= 1'd0;
				  // if(cycle_2== 6'd24) begin
			        //      CS_2_i <= 1'd0;
						//  clk_start_2 <= 1'd0;
			             // end 
			      if(sclk_pos_edge == 1'd1) begin
					 if(cycle_2== 5'd24)  begin
						state_2  <= 6'd13;
						cycle_2  <= 6'd0;
						ADC_channel_reg_2 <= data_reg_2;
						CS_2_i      <= 1'd0;
						clk_start_2 <= 1'd0;
						end
					  else begin
						 data_reg_2[10'd23-cycle_2] <= MISO_2;
						 cycle_2  <= cycle_2+1;
						 state_2  <= 6'd12;					
					     end 
			        end
			      end	
			
			6'd13: begin     
						if(delay_counter_2 < 4'd9) begin
							delay_counter_2 <= delay_counter_2+1;
							state_2 <= 6'd13;
							CS_2_i  <= 1'b1;
						
                        end
						else
							delay_counter_2 <= 4'b0;    
					    if(delay_counter_2 == 4'd9 ) begin
							state_2 <= 6'd14;
							CS_2_i  <= 1'b1; 
							///ADC_channel_6 <= ADC_channel_reg_2;
							if(ch_count_2 == 0) begin
							    ADC_channel_6 <= ADC_channel_reg_2;
								adc_2_done    <= 0;
								end
							if(ch_count_2 == 1) begin
							    ADC_channel_7 <= ADC_channel_reg_2;
								end
						end
					end   
					
				6'd14: begin    
				            ch_count_2 <= ch_count_2 + 1;
							/*	
							if(ch_count_0 == 0) begin
							    ADC_channel_0 <= ADC_channel_reg_0;
								adc_0_done <= 0;
								end
							if(ch_count_0 == 1) 
							    ADC_channel_1 <= ADC_channel_reg_0;
							if(ch_count_0 == 2)
							    ADC_channel_2 <= ADC_channel_reg_0;	
								*/ 
                            state_2 <= 6'd15;							
					end  
					
			6'd15:begin     
						if(delay_counter_2 < 4'd9) begin
							delay_counter_2 <= delay_counter_2+1;
							state_2 <= 6'd15;
							CS_2_i  <= 1'b1;
							conversion_done_2   <= 0;	
							MOSI_2_i            <= 1'b0;
				            clk_start_2         <= 1'd0;
				            cycle_2             <= 6'd0;
		              //    input_reg_2         <= 8'd0;
				            conversion_done_2   <= 0;
				            data_reg_2          <= 24'd0;
                        end
						else
							delay_counter_2 <= 4'b0;    
					    if(delay_counter_2 == 4'd9 ) begin
							state_2      <= 6'd0;
							CS_2_i       <= 1'b1;
							convo_done_2 <= 1;
							new_value_1  <=1'b0;
							if(ch_count_2 == 2) begin
								ch_count_2 <= 0;
								adc_2_done <= 1;
							    end
							/*ch_count_2 <= ch_count_2 + 1;
							if(ch_count_2 <= 3) begin
								ch_count_2 <= 0;
								adc_1_done <= 1;
							end */ 
						end
					end  	
										
            endcase
       end						
end


assign all_conversion_done = ((adc_0_done == 1) && (adc_1_done == 1) && (adc_2_done == 1));   ///////............SYNCHRONIZATION

//======================================================================================================================================================================
// MAIN PROGRAM
//======================================================================================================================================================================


always @(posedge CLK or negedge RESET) begin
	if(~RESET) begin
		out_cnt   <= 0;
		out_reg   <= 208'h02ABABABADADADACACACA21401ABABABADADADACACACA21401;
		frame_out <= 1'b1;
		d_out     <= 0; 
	end
	else begin 
		if (posedge_CLK_IN ==1'b1) begin
                    if(out_cnt == 208) begin
                       out_cnt <= 'd0;
                       frame_out <= 1'b0;
					   out_reg <= ser_mod_data;
                       end
                    else begin
						 d_out <= out_reg[10'd207 - out_cnt];
			             out_cnt <= out_cnt + 1'b1;
			             frame_out <= 1'b1;
						end      
              end
	  end	  
end

/*

always @(posedge CLK or negedge RESET) begin
	if(~RESET) begin
		out_cnt   <= 0;
		out_reg   <= 8'b10100101;
		frame_out <= 1'b1;
		d_out     <= 0; 
	end
	else begin 
		if (posedge_CLK_IN ==1'b1) begin
                    if(out_cnt == 8) begin
                       out_cnt <= 'd0;
                       frame_out <= 1'b0;
					   out_reg <= out_reg;
                       end
                    else begin
						 d_out <= out_reg[10'd7 - out_cnt];
			             out_cnt <= out_cnt + 1'b1;
			             frame_out <= 1'b1;
						end      
              end
	  end	  
end
*/

always @(posedge CLK or negedge RESET) begin
	if(~RESET) begin
		DATA_RECEVIED <= 0;
	end
	else if(in_cnt == 1) begin
	     DATA_RECEVIED <= in_reg;
	end	
end


always @(posedge CLK or negedge RESET) begin
	if(~RESET) begin
		in_reg       <= 0;
        DATA_RECVD_O <= 0;
		in_cnt       <= 0;
	end
	else if( posedge_CLK_OUT == 1'b1) begin 
               if( sync1_DFRM_IN == 1'b1) begin 
				    in_cnt <= in_cnt+1'b1;
				    in_reg [10'd207 - in_cnt] <= sync1_SER_DATA_IN;
				end
              else 
			    if(sync1_DFRM_IN == 1'b0) begin
		            DATA_RECVD_O <= in_reg;
		            in_cnt <= 0;
	           end
	     end	
end

assign DATA_2_SEND_I = DATA_RECVD_O; 

assign all_ch_sampling_done = all_conversion_done;
///assign all_ch_sampling_done = 1;


always @(posedge CLK or negedge RESET) begin
	if(~RESET) begin
		mod_adc_data<=0;
		send_mod_data<=0;
        end
	else begin
		 if(all_ch_sampling_done == 1'b1 )	begin
		    //mod_adc_data <= {2'b10,3'd6,3'd0,ADC_channel_5,2'b10,3'd5,3'd0,ADC_channel_4,2'b10,3'd4,3'd0,ADC_channel_3,2'b10,3'd3,3'd0,ADC_channel_2,2'b10,3'd2,3'd0,ADC_channel_1,2'b10,3'd1,3'd0,ADC_channel_0};
		    //mod_adc_data <= {16'h5A5A,ADC_channel_7,24'd0,ADC_channel_5,24'd0,24'd0,ADC_channel_2,24'd0,24'd0};
		    mod_adc_data <= {16'h5A5A,ADC_channel_7,ADC_channel_6,ADC_channel_5,ADC_channel_4,ADC_channel_3,ADC_channel_2,ADC_channel_1,ADC_channel_0};
			send_mod_data <= 1'b1;
	        end
	     else 
		    send_mod_data <= 0;		
        end			
end

assign ser_mod_data = send_mod_data ? mod_adc_data:'h0;

endmodule

