`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/12/2024 03:33:45 PM
// Design Name: 
// Module Name: PModDisplay
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


module PModDisplay(
input [6:0] balance,
input clk,
output [6:0] segment,
output reg [1:0] index
    );

reg [3:0] value;
reg[24:0] slowClk;
reg indexed;

always @(posedge clk) begin
    slowClk = slowClk + 1;
    indexed = slowClk[19];
    if (indexed == 1'b0) begin
        index = indexed;
        value = balance % 10;
    end else if (indexed == 1'b1) begin
        index = indexed;
        value = balance / 10;
    end
end

assign segment[0] = !(value != 1 && value != 4);
assign segment[1] = !(value != 5 && value != 6);
assign segment[2] = value == 2;
assign segment[3] = !(value != 1 && value != 4 && value != 7);//2, 3, 5, 6, 8, 9, 0
assign segment[4] = !(value == 0 || value == 2 || value == 6 || value == 8); //2, 6, 8, 0
assign segment[5] = !(value != 1 && value != 2 && value != 3 && value != 7);//4, 5, 6, 8, 9, 0
assign segment[6] = !(value != 1 && value != 7 && value != 0); //2, 3, 4, 5, 6, 8, 9, 0
    
endmodule
