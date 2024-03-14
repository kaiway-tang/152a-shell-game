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


module DifficultyDisplay(
input[1:0] d, //0-3 = easy, ehh, hard, bruh
input clk,
output reg [6:0] segment,
output reg [3:0] index
   );

reg [24:0] internalClk;
reg [24:0] slowClk; //
reg[1:0] indexed;

always @(posedge clk) begin
    slowClk = slowClk + 1;
    indexed = slowClk[19:18];
    
    if (d == 2'b00) begin
    //easy
        if (indexed == 2'b00) begin
            index = 4'b0111;
            segment = 7'b0000110;
        end else if (indexed == 2'b01) begin
            index = 4'b1011;
            segment = 7'b0001000;
        end else if (indexed == 2'b10) begin
            index = 4'b1101;
            segment = 7'b0010010;
        end else if (indexed == 2'b11) begin
            index = 4'b1110;
            segment = 7'b0010001;
        end

    end else if (d == 2'b01) begin 
    //ehhh
        if (indexed == 2'b00) begin
            index = 4'b0111;
            segment = 7'b0000110;
        end else if (indexed == 2'b01) begin
            index = 4'b1011;
            segment = 7'b0001011;
        end else if (indexed == 2'b10) begin
            index = 4'b1101;
            segment = 7'b0001011;
        end else if (indexed == 2'b11) begin
            index = 4'b1110;
            segment = 7'b0001011;
        end

    end else if (d == 2'b10) begin 
    //hard
        if (indexed == 2'b00) begin
            index = 4'b0111;
            segment = 7'b0001001;
        end else if (indexed == 2'b01) begin
            index = 4'b1011;
            segment = 7'b0001000;
        end else if (indexed == 2'b10) begin
            index = 4'b1101;
            segment = 7'b0101111;
        end else if (indexed == 2'b11) begin
            index = 4'b1110;
            segment = 7'b0100001;
        end

    end else if (d == 2'b11) begin 
    //bruh
        if (indexed == 2'b00) begin
            index = 4'b0111;
            segment = 7'b0000011;
        end else if (indexed == 2'b01) begin
            index = 4'b1011;
            segment = 7'b0101111;
        end else if (indexed == 2'b10) begin
            index = 4'b1101;
            segment = 7'b1100011;
        end else if (indexed == 2'b11) begin
            index = 4'b1110;
            segment = 7'b0001011;
        end
    end
    
end
    
endmodule
