`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/06/2024 01:41:39 PM
// Design Name: 
// Module Name: RandomSelector
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


module RandomSelector(
input go,
input clk,
input anyInput,
output reg [1:0] swapTarget,
output reg [1:0] swapDest
    );

reg [5:0] internalClk;
reg [5:0] seed;

reg [31:0] randomReg;

initial begin
    randomReg = 32'b11111111111111111111111111111111;
end

always @(posedge go) begin
    swapTarget = randomReg[1:0];
    swapDest = randomReg[3:2];
end

always @(clk) begin
    internalClk = internalClk + 1;
    
    randomReg = randomReg << 1;
    randomReg[0] = randomReg[31] ^ randomReg[29] ^ randomReg[25] ^ randomReg[24];
end

always @(anyInput) begin
    //set a seed
    randomReg[31:27] = internalClk;
end
    
endmodule
