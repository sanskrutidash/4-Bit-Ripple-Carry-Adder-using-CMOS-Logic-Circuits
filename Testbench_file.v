`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.07.2024 07:51:00
// Design Name: 
// Module Name: traffic_signal_controller_tb
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


module traffic_signal_controller_tb();

wire [1:0] MAIN_SIG, COUNTRY_SIG;
reg CAR_ON_COUNTRY_ROAD;

reg CLOCK, CLEAR;

// instantiate the signal_controller
Traffic_Signal_Controller tsc(MAIN_SIG, COUNTRY_SIG, CAR_ON_COUNTRY_ROAD, CLOCK, CLEAR);

// setup monitor
initial 
$monitor($time, "Main Sig = %b, Country  Sig = %b, Is there Car on Country Road ?  = %b", MAIN_SIG, COUNTRY_SIG, CAR_ON_COUNTRY_ROAD);

//setup clock
initial
begin
  CLOCK = `FALSE;
  forever #5 CLOCK = ~CLOCK;
end

initial
begin
  CLEAR = `TRUE;
  repeat (5) @(negedge CLOCK);
  CLEAR = `FALSE;
end

//apply stimulus
initial 
begin
  CAR_ON_COUNTRY_ROAD = `FALSE;
  #200 CAR_ON_COUNTRY_ROAD = `TRUE;
  #100 CAR_ON_COUNTRY_ROAD = `FALSE;
  
  #200 CAR_ON_COUNTRY_ROAD = `TRUE; 
  #100 CAR_ON_COUNTRY_ROAD = `FALSE;
  
  #200 CAR_ON_COUNTRY_ROAD = `TRUE; 
  #100 CAR_ON_COUNTRY_ROAD = `FALSE;
  
  #100 $stop;
end
endmodule
