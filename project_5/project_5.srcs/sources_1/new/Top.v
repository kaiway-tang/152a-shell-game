`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/06/2024 02:27:49 PM
// Design Name: 
// Module Name: Top
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


module Top(
input clk,
input btnC, //select difficulty / bet / submit guess
input btnU, //increase difficulty / bet
input btnD, //decrease difficuly / bet 
input[3:0] sw, //switches to set guess
output [6:0] seg,
output [3:0] an,
output [7:0] pmod,
output [7:0] pmodC
    );
    
reg [2:0] gameState; //0: difficulty select, 1: set bet, 2: coin place, 3: shuffling, 4: reveal animation

wire centerBtn;
wire upBtn;
wire downBtn;

wire sw0;
wire sw1;
wire sw2;
wire sw3;

//reg [7:0] boardState;
wire [7:0] boardState;

reg [2:0] difficulty;

wire [6:0] segment_cupDisplay;
wire [3:0] index_cupDisplay;
wire [6:0] segment_difficulty;
wire [3:0] index_difficulty;
wire [6:0] segment_bet;
wire [3:0] index_bet;
wire [6:0] segment_coinPlace;
wire [3:0] index_coinPlace;
wire [6:0] segment_reveal;
wire [3:0] index_reveal;

CupDisplayer cupDisplayer(
    .boardState(boardState),
    .clk(clk), .segment(segment_cupDisplay), .index(index_cupDisplay)
);

DisplayController displayController(
    .gameState(gameState),
    .clk(clk),
    
    .segment_cupDisplay(segment_cupDisplay),
    .index_cupDisplay(index_cupDisplay),
    .segment_difficulty(segment_difficulty),
    .index_difficulty(index_difficulty),
    .segment_bet(segment_bet),
    .index_bet(index_bet),
    .segment_coinPlace(segment_coinPlace),
    .index_coinPlace(index_coinPlace),
    .segment_reveal(segment_reveal),
    .index_reveal(index_reveal),
    
    .segment(seg),
    .index(an)
);

reg [6:0] balance;
reg [6:0] bet;
wire [6:0] pmodSegment;
wire pmodIndex;
PModDisplay pmodDisplay( .balance(balance), .clk(clk), .segment(pmodSegment), .index(pmodIndex));
assign pmod[6:3] = pmodSegment[6:3];
assign pmodC[6:4] = pmodSegment[2:0];
assign pmodC[3] = pmodIndex; 


Debouncer btnCDebouncer( .btn(btnC), .clk(clk), .out(centerBtn));
Debouncer btnUDebouncer( .btn(btnU), .clk(clk), .out(upBtn));
Debouncer btnDDebouncer( .btn(btnD), .clk(clk), .out(downBtn));

Debouncer sw0Debouncer( .btn(sw[0]), .clk(clk), .out(sw0));
Debouncer sw1Debouncer( .btn(sw[1]), .clk(clk), .out(sw1));
Debouncer sw2Debouncer( .btn(sw[2]), .clk(clk), .out(sw2));
Debouncer sw3Debouncer( .btn(sw[3]), .clk(clk), .out(sw3));

reg [35:0] counter;
reg [9:0] state;
reg startCoinDrop;
reg startAnimation;
reg startCoinReveal;
wire endCoinDrop;
wire endAnimation;
reg [1:0] tmp1 = 2'b11;
reg [1:0] tmp2 = 2'b00;
reg [24:0] frameRate;

DifficultyDisplay(
.d(difficulty), .clk(clk), .segment(segment_difficulty), .index(index_difficulty)
);
BetDisplay betDisplay(
    .clk(clk), .currBet(bet), .segment(segment_bet), .index(index_bet)
);
DropCoinDisplay(
.trigger(startCoinDrop), .cup(1), .clk(clk), .frameRate(30000000),
.segment(segment_coinPlace), .index(index_coinPlace)
);

reg randomSelectGo;
reg [1:0] target;
reg [1:0] dest;
AnimationExample(
    .target(tmp1), .dest(tmp2), .trigger(startAnimation), .frameRate(frameRate), .msClk(msClk),
    .boardState(boardState), .isInAnimation(isInAnimation)
);
RevealCoinDisplay(
   .submit(startCoinReveal), .guess(4'b0100), .coins(4'b1000), .msClk(clk), .segment(segment_reveal), .index(index_reveal)
);

//RandomSelector randomSelector(
//    .go(randomSelectGo), .clk(clk), .anyInput(centerBtn || upBtn || downBtn), .swapTarget(target), .swapDest(dest)
//);

initial begin
//0: difficulty select, 1: set bet, 2: coin place, 3: shuffling, 4: reveal animation
    gameState = 0;
    
    balance = 10;
    bet = 5;
end

reg centerBtnFlag;
reg upBtnFlag;
reg downBtnFlag;

reg msClk;
reg [15:0] msClkCounter;

reg [5:0] numberShuffles;
wire isInAnimation;
reg animFlag;

always @(posedge clk) begin   
    counter = counter + 1;
    msClkCounter = msClkCounter + 1;
    if (msClkCounter >= 50000) begin
        msClkCounter = 0;
        msClk = ~msClk;
    end
    
    if (centerBtnFlag != centerBtn) begin
        centerBtnFlag = centerBtn;
        
        if (centerBtnFlag) begin
            if (gameState == 0) begin // Select difficulty                    
                    if (difficulty == 0) begin
                        frameRate = 300;
                        numberShuffles = 8;
                    end else
                    if (difficulty == 1) begin
                        frameRate = 150;
                        numberShuffles = 16;
                    end else
                    if (difficulty == 2) begin
                        frameRate = 75;
                        numberShuffles = 32;
                    end else
                    if (difficulty == 3) begin
                        frameRate = 60;
                        numberShuffles = 40;
                    end
                    
                    if (balance >= 1) begin bet = 1; end
                    if (balance >= 2) begin bet = 2; end
                    if (balance >= 4) begin bet = 4; end        
                    gameState = 1;
                end else if (gameState == 1) begin // Set bet
                    if (bet * 2 <= balance) begin
                        bet = bet * 2;
                    end
                    gameState = 2;
                    startCoinDrop = 1;
                end else if (gameState == 2) begin // Drop coin
                    gameState = 3;
                    startCoinDrop = 0;
                    animFlag = 1;
                    
                    startAnimation = 1;
                end else if (gameState == 3) begin // Animation
                    gameState = 4;
                end else if (gameState == 4) begin // Reveal coin
                    gameState = 0;
                end
        end
    end
    
    if (upBtnFlag != upBtn) begin
        upBtnFlag = upBtn;
        
        if (upBtnFlag) begin
            if (gameState == 0) begin //difficulty
                        difficulty = (difficulty + 1) % 4;
                    end
                    if (gameState == 1) begin // Set bet
                        if (bet * 2 <= balance) begin
                            bet = bet * 2;
                        end
                    end
        end         
    end
    
    if (downBtnFlag != downBtn) begin
        downBtnFlag = downBtn;
        if (downBtnFlag) begin
            if (gameState == 0) begin // difficulty
                 difficulty = difficulty - 1;
                 if (difficulty < 0) begin
                     difficulty = 3;
                 end
             end else if (gameState == 1) begin // Set bet
                 if (bet > 1) begin
                     bet = bet / 2;
                 end
            end
        end
    end
    
    
end
    
endmodule
