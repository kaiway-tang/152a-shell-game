`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/06/2024 01:09:34 PM
// Design Name: 
// Module Name: CupDisplayer
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


module CupDisplayer(
input[7:0] boardState,
input clk,
output reg [6:0] segment,
output reg [3:0] index
    );
    
reg [1:0] value;
reg[24:0] slowClk;
reg[1:0] indexed;


always @(posedge clk) begin
    slowClk = slowClk + 1;
    indexed = slowClk[19:18];
    if (indexed == 2'b00) begin
        index = 4'b1110;
        value = boardState[1:0];
    end else if (indexed == 2'b01) begin
        index = 4'b1101;
        value = boardState[3:2];
    end else if (indexed == 2'b10) begin
        index = 4'b1011;
        value = boardState[5:4];
    end else if (indexed == 2'b11) begin
        index = 4'b0111;
        value = boardState[7:6];
    end
    
    if (value == 2'b00) begin 
        // no cups
        segment = 7'b1111111; 
    end else if (value == 2'b01) begin 
        // one cup on bottom
        segment = 7'b1100011;
        
        
    end else if (value == 2'b10) begin 
        // one cup on top
        segment = 7'b0011101;
        
        
    end else if (value == 2'b11) begin 
        // two cups
        //segment = 7'b1000000;
        
        segment = 7'b0000001;
    end
end





    
endmodule
