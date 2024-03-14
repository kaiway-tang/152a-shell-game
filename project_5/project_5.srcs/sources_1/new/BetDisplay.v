`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/12/2024 11:07:14 AM
// Design Name: 
// Module Name: BetDisplay
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


module BetDisplay(
input [6:0] currentBet,
input clk,
output [6:0] segment,
output [4:0] index
);

parameter min = 1;
parameter max = 99;

always @(posedge btnU or posedge btnD) begin
    // double the bet when btnU is pressed. can't exceed max or max - balance
    if (btnU && (bet * 2 <= max) && (bet * 2 <= 99 - balance)) begin
        bet <= bet * 2;
    end
    // halve the bet when btnD is pressed. can't fall below min
    else if (btnD && bet > 1) begin
        if (bet > min * 2) begin
            bet <= bet / 2;
        end
    end
end

reg[24:0] slowClk;
reg[1:0] indexed;

always @(posedge clk) begin
    slowClk = slowClk + 1;
    indexed = slowClk[19:18]; //select which digit is displaying

    //display max two digits
    if (indexed == 2'b00 || indexed == 2'b10) begin
        index = 4'b1011;
        segment = getSegmentEncoding(bet/10);
    end else if (indexed == 2'b01 || indexed == 2'b11) begin
        index = 4'b0111;
        segment = getSegmentEncoding(bet%10);
    end

end

function [6:0] getSegmentEncoding;
    input [3:0] digit;
    begin
        case (digit)
            0: getSegmentEncoding = 7'b1000000;
            1: getSegmentEncoding = 7'b1111001;
            2: getSegmentEncoding = 7'b0100100;
            3: getSegmentEncoding = 7'b0110000;
            4: getSegmentEncoding = 7'b0011001;
            5: getSegmentEncoding = 7'b0010010;
            6: getSegmentEncoding = 7'b0000010;
            7: getSegmentEncoding = 7'b1111000;
            8: getSegmentEncoding = 7'b0000000;
            9: getSegmentEncoding = 7'b0011000;
            default: getSegmentEncoding = 7'b1111111; // default to all segments off
        endcase
    end
endfunction

endmodule