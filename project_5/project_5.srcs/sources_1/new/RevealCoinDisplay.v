module RevealCoinDisplay(

input submit,
input [3:0] guess,
input [3:0] coins,
input msClk,
output reg [6:0] segment,
output reg [3:0] index
    );

reg [24:0] slowClk;
reg [1:0] indexed;

reg [1:0] display0;
reg [1:0] display1;
reg [1:0] display2;
reg [1:0] display3;
reg reveal;

always @(posedge msClk) begin
    slowClk = slowClk + 1;
    indexed = slowClk[19:18];
    if (indexed == 2'b00) begin
        index = 4'b1110;
        segment = segmentValue(display0);
    end else if (indexed == 2'b01) begin
        index = 4'b1101;
        segment = segmentValue(display1);
    end else if (indexed == 2'b10) begin
        index = 4'b1011;
        segment = segmentValue(display2);
    end else if (indexed == 2'b11) begin
        index = 4'b0111;
        segment = segmentValue(display3);
    end
    
    //0: upside down cup: 7'b0101011
    //1: cup over nothing: 7'b1011100
    //2: cup over coin: 7'b1010100    
    if (reveal == 0 && submit == 1) begin
        reveal = 1;
    end
    if (reveal == 1) begin
        display0 = guess[0] + (coins[0] & guess[0]);
        display1 = guess[1] + (coins[1] & guess[1]);
        display2 = guess[2] + (coins[2] & guess[2]);
        display3 = guess[3] + (coins[3] & guess[3]);
    end else begin
        display0 = 0;
        display1 = 0;
        display2 = 0;
        display3 = 0;
    end
end

function [6:0] segmentValue;
    input [1:0] cupState;
    begin
        if (cupState == 0) begin
            segmentValue = 7'b0101011;
        end else if (cupState == 2) begin
            segmentValue = 7'b1010100;
        end else if (cupState == 1) begin
            segmentValue = 7'b1011100;
        end
    end
endfunction
    
endmodule