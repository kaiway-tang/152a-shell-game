`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/22/2024 06:24:46 AM
// Design Name: 
// Module Name: debouncer
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


module Debouncer(
    input btn,
    input clk,
    output reg out
    );

reg [15:0] clkCounter; //~400Hz

always @(posedge clk) begin
    clkCounter = clkCounter + 1;
    if (clkCounter == 16'b1111111111111111) begin
        out = btn;
    end
end
    
endmodule