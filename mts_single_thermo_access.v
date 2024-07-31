
`timescale 1ns / 1ps

module cpld_mod0
(
input CLK,
input RESET,

input  MISO_0,
output MOSI_0,
output SCLK_0,
output CS_0,

output [7:0] temp
);

//================================================================================
// DECLARATIONS
//=================================================================================
reg frame_out;
parameter HIGH_TIME=10'd4;
parameter LOW_TIME =10'd4;

reg MOSI_0_i;
reg SCLK_0_i;
reg CS_0_i;

reg [5:0] cycle_0;
reg [5:0] state_0;
reg [7:0] address_0;

reg [7:0] input_reg_0;

reg sclk_low_sync;
reg sclk_low_sync1;
reg sclk_low;

wire sclk_pos_edge;
wire sclk_neg_edge;

reg [9:0] h_count;
reg [9:0] l_count;

reg [3:0] delay_counter_0;


reg sclk_high;
reg  [4:0] channel_count;
wire [7:0] temp;

reg clk_start_0;

reg [7:0]  STAT1_read_0 ;
reg [7:0]  STAT1_status_read_0;
reg [7:0]  CTRL2_read_0 ;
reg [7:0]  CTRL2_status_read_0;
reg [15:0] CTRL2_mux_select_0;    
reg [15:0] CTRL1_config_0;
reg [7:0]  CTRL1_read_0;
reg [7:0]  CTRL1_status_read_0;

reg [23:0] ADC_channel_reg_0;

reg [23:0] ADC_channel_0;
reg [23:0] ADC_channel_1;
reg [23:0] ADC_channel_2;

reg conversion_done_0;
reg convo_done_0;

reg [7:0] DATA_read_0;
reg [23:0] data_reg_0;
reg [7:0] stat1_reg_0;
reg [7:0] ctrl1_reg_0;
reg [7:0] ctrl2_reg_0;

reg [7:0] ini_conv_cmd_0;
reg [4:0] convo_count_0;
reg trig;
reg [23:0] con_time_cnt;
reg [23:0] con_time;
reg load;

reg load_0;
reg [2:0] ch_count_0;
reg new_value;

reg new_value_0;
reg adc_0_done;

wire all_conversion_done;
//================================================================================
// OUTPUT ASSIGNMENT
//=================================================================================

assign CLK_OUT = CLK_IN;
assign DFRM_O = frame_out;
assign SER_DATA_O = d_out;//out_reg[0]

assign MOSI_0 = MOSI_0_i;
assign CS_0 = CS_0_i;
assign SCLK_0 = SCLK_0_i;

assign temp = in_reg;
//================================================================================
// CLOCK GENERATION
//=================================================================================
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

//================================================================================
// SPI PROGRAM
//=================================================================================



always @(negedge CLK or negedge RESET) begin
	if(~RESET) begin
		MOSI_0_i             <= 1'b0;
		state_0              <= 6'b0;
		CS_0_i               <= 1'b1;
		clk_start_0          <= 1'd0;
		address_0            <= 8'h02;
		cycle_0              <= 6'd0;
		//input_reg            <= 8'd0;
		STAT1_status_read_0  <= 0;
		STAT1_read_0         <= 8'hC1;
		CTRL1_config_0       <= 16'hC2FE;  ////		CTRL1_config_0       <= 16'hC2BE;  
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
		//trig                 <= 0;
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
		          //input_reg           <= 8'd0;
				  delay_counter_0     <= 0;
				  conversion_done_0   <= 0;
				  data_reg_0          <= 24'd0;
				  CTRL1_config_0      <= 16'hC2FE;
				  CTRL2_mux_select_0  <= 16'hC4F4; 
                  DATA_read_0         <= 8'hC9;	
                  ini_conv_cmd_0      <= 8'h83; 
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
								//trig              <= trig + 1;
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
							CS_0_i <= 1'b1;
						
                        end
						else
							delay_counter_0 <= 4'b0;    
					    if(delay_counter_0 == 4'd9 ) begin
							state_0 <= 6'd14;
							CS_0_i <= 1'b1;
							 ADC_channel_0 <= ADC_channel_reg_0;		
						end
					end   
			
			6'd14: begin    
			             ADC_channel_0 <= ADC_channel_reg_0;			
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
		                   // input_reg           <= 8'd0;
				            conversion_done_0   <= 0;
				            data_reg_0          <= 24'd0;
							
                        end
						else 
							delay_counter_0 <= 4'b0;  
					    if(delay_counter_0 == 4'd9 ) begin
							state_0 <= 6'd0;
							CS_0_i <= 1'b1;
							convo_done_0 <= 1;
						end
					end  	
										
            endcase
       end						
end

endmodule

