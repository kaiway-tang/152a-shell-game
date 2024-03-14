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


module DropCoinDisplay(
input trigger,
input [1:0] cup,
input clk,
input[24:0] frameRate,
output reg [6:0] segment,
output reg [3:0] index,
output reg isInAnimation
    );

reg [24:0] internalClk;
reg [24:0] slowClk; //
reg[2:0] frameNum;
reg triggerPrevState = 0; // to detect the rising edge of trigger and set left, right when first triggered
reg[1:0] indexed;

always @(posedge clk) begin
    triggerPrevState <= trigger;
    slowClk = slowClk + 1;
    indexed = slowClk[19:18];
    case (indexed) //select which digit is displaying
        2'b00: index = 4'b1110;
        2'b01: index = 4'b1101;
        2'b10: index = 4'b1011;
        2'b11: index = 4'b0111;
    endcase
    segment = 7'b1100011;
    //place coin
    if (indexed == cup) begin
        case (frameNum)
            1: segment = 7'b1100010;
            2: segment = 7'b1100011;
            3: segment = 7'b1100010;
            4: segment = 7'b0100011;
        endcase
    end
    
    if (isInAnimation == 1) begin       
        internalClk = internalClk + 1;
        if (internalClk >= frameRate) begin
            internalClk = internalClk - frameRate;
            //end animation
            if (frameNum > 4) begin
                isInAnimation = 0;
                frameNum = 0;
            end
            //next frame
            frameNum = frameNum + 1;
        end
    end else if (trigger == 1 && triggerPrevState == 0 && isInAnimation != 1) begin
        isInAnimation = 1;
        index = cup;
        frameNum = 0;
    end
    
end
    
endmodule
