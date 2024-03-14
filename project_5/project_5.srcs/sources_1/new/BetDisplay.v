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
input clk,
input[7:0] currBet,
output reg [6:0] segment,
output reg [3:0] index
);

parameter min = 1;
parameter max = 99;

reg[24:0] slowClk;
reg[1:0] indexed;

always @(posedge clk) begin
    slowClk = slowClk + 1;
    indexed = slowClk[19:18]; //select which digit is displaying

    //display max two digits
    //ones
    if (indexed == 2'b00 || indexed == 2'b10) begin
        index = 4'b1011;
//        segment = 7'b1000000;
        segment = getSegmentEncoding(currBet%10);
    end else if (indexed == 2'b01 || indexed == 2'b11) begin
        //tens
        index = 4'b0111;
//        segment = 7'b1111001;
        segment = getSegmentEncoding(currBet/10);
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
            9: getSegmentEncoding = 7'b0010000;
            default: getSegmentEncoding = 7'b1111111; // default to all segments off
        endcase
    end
endfunction

endmodule