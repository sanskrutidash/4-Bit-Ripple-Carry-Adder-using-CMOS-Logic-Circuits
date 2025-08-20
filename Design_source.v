`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.07.2024 22:18:17
// Design Name: 
// Module Name: Traffic_Signal_Controller
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
// defining the variables

`define TRUE 1'b1
`define FALSE 1'b0
`define RED 2'd0
`define YELLOW 2'd1
`define GREEN 2'd2

// State definition    Highway   Country_Road

`define S0 3'd0      //H = G      C = R
`define S1 3'd1      //H = Y      C = R
`define S2 3'd2      //H = R      C = R
`define S3 3'd3      //H = R      C = G
`define S4 3'd4      //H = R      C = Y

// Delays define

`define Y2R 3//Yellow to red delay
`define R2G 2// Red to yellow delay

module Traffic_Signal_Controller(hwy, cntry, X, clock, clear);
// I/O ports
output [1:0] hwy, cntry;
reg [1:0] hwy, cntry; // declared the output signals as the registers

input X; // if TRUE then indicates there is a car on country road otherwise FALSE
input clock, clear;

// internal state variables
reg [2:0] state;
reg [2:0] next_state;

// signal controller starts from S0 state
initial
begin
  state = `S0;
  next_state = `S0;
  hwy = `GREEN;
  cntry = `RED;
end

// state changes only at positive edge of clock
always @(posedge clock)
state = next_state;

// computes the value of main signal and country signal
always @(state)
begin
  case(state)
  `S0 : begin 
         hwy = `GREEN;
         cntry = `RED;
        end
  `S1 : begin 
         hwy = `YELLOW;
         cntry = `RED;
        end
  `S2 : begin 
         hwy = `RED;
         cntry = `RED;
        end
  `S3 : begin 
         hwy = `RED;
         cntry = `GREEN;
        end
  `S4 : begin 
         hwy = `RED;
         cntry = `YELLOW;
        end
  endcase
end

// state machine using the case statements

always @(state or clear or X)
begin 
if(clear)
  next_state = `S0;
else
  case (state)
  `S0 : if(X)
           next_state = `S1;
        else
           next_state = `S0;
           
  `S1 : begin // delay some positive edge of the clock
          repeat(`Y2R) @(posedge clock);
          next_state = `S2;
        end
  
  `S2 : begin // delay some positive edge of the clock 
          repeat(`R2G) @(posedge clock);
          next_state = `S3;
        end
  
  `S3 : if(X)
           next_state = `S3;
        else
           next_state = `S4;
           
  `S4 : begin // delay some positive edge of the clock
          repeat(`Y2R) @(posedge clock);
          next_state = `S0;
        end
  default : next_state = `S0;
  endcase 
end
