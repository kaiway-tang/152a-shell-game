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

reg [24:0] internalClk;
reg [7:0] nextState;
reg[1:0] left; //internally track target and dest so left is the smaller index
reg[1:0] right;
reg[3:0] i1; // dumb way to track which bottom cup moves
reg[3:0] i2; //dumb way to track where the top cup is
reg[5:0] frameNum; //tracks how many frames it has been (not current frame)
reg triggerPrevState = 0; // to detect the rising edge of trigger and set left, right when first triggered


initial begin
    nextState = 8'b01010101;
end

always @(posedge msClk) begin
    triggerPrevState <= trigger;
    if (isInAnimation == 1) begin       
        internalClk = internalClk + 1;
        if (internalClk >= frameRate) begin
            internalClk = internalClk - frameRate;
            
            // move bottom cups left
            if (frameNum > 0 && frameNum < 1 + (right - left)) begin
                nextState[7 - (i1-1)*2 - 1] = 1;
                nextState[7- i1*2 -1] = 0;
                i1 = i1 + 1;
            //move top cup right
            end else if (frameNum < 1 + 2 * (right - left)) begin
                nextState[7-(i2 + 1)*2] = 1;
                nextState[7-i2*2] = 0;
                i2 = i2 + 1;
            //last frame, move top cup down to final position
            end else begin
                nextState[7 - right*2] = 0;
                nextState[7- right*2 - 1] = 1;
                frameNum = 0;
                isInAnimation = 0;
            end
            boardState = nextState;
            
            //next frame
            frameNum = frameNum + 1;
        end
    end else if (trigger == 1 && triggerPrevState == 0 && isInAnimation != 1) begin
        isInAnimation = 1;
        if (target < dest) begin
            left = target;
            right = dest;
        end else begin
            left = dest;
            right = target;
        end
        frameNum = 1;
        i1 = left + 1;
        i2 = left;

        //move first cup up
        nextState[7-left*2] = 1; //move first cup up
        nextState[7-left*2 - 1] = 0;
        
        boardState = nextState;
    end
end
    
endmodule
