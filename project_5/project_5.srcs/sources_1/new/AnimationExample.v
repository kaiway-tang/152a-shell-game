`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/13/2024 10:59:41 PM
// Design Name: 
// Module Name: AnimationExample
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


module AnimationExample(
input[1:0] target,
input[1:0] dest,
input trigger, //on pos edge, start the animation (denoted by swapTarget swapDestination)
input[24:0] frameRate,
input msClk,
output reg [7:0] boardState,
output reg isInAnimation
    );

reg inAnimation;
reg [24:0] internalClk;
reg [7:0] nextState;

initial begin
    nextState = 8'b10010101;
end

always @(posedge msClk) begin
    if (inAnimation == 1) begin       
        internalClk = internalClk + 1;
        if (internalClk >= frameRate) begin
            internalClk = internalClk - frameRate;
            
            boardState = nextState;
            nextState = ~nextState;
        end
    end else if (trigger == 1) begin
        inAnimation = 1;
    end
end
    
endmodule
