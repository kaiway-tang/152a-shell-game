`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/12/2024 10:50:52 AM
// Design Name: 
// Module Name: DisplayController
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


module DisplayController(
input [2:0] gameState,
input clk,
input [6:0] segment_cupDisplay,
input [3:0] index_cupDisplay,
input [6:0] segment_bet,
input [3:0] index_bet,
input [6:0] segment_difficulty,
input [3:0] index_difficulty,
input [6:0] segment_coinPlace,
input [3:0] index_coinPlace,
input [6:0] segment_reveal,
input [3:0] index_reveal,
output reg [6:0] segment,
output reg [3:0] index
    );

always @(posedge clk) begin
    if (gameState == 0) begin
        segment = segment_difficulty;
        index = index_difficulty;
    end
    if (gameState == 1) begin
        segment = segment_bet;
        index = index_bet;
    end
    if (gameState == 2) begin
        segment = segment_coinPlace;
        index = index_coinPlace;        
    end
    if (gameState == 3) begin
        segment = segment_cupDisplay;
        index = index_cupDisplay;
    end
    if (gameState == 4) begin
        segment = segment_reveal;
        index = index_reveal;
    end
end

    
endmodule
