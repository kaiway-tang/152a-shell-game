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


//AnimationController animationController(
//    .target(2'b00), .dest(2'b10), .trigger(trigger), .frameRate(100000000), .msClk(clk),
//    .boardState(boardState)
//);

AnimationExample(
    .target(2'b11), .dest(2'b01), .trigger(trigger), .frameRate(300000000), .msClk(clk),
    .boardState(boardState)
);

reg [35:0] counter;
reg [9:0] state;
reg trigger;

initial begin
    gameState = 3;
end

always @(posedge centerBtn) begin
    if (gameState == 0) begin
        //todo: set frame rate and number of shuffles
        if (balance >= 1) begin bet = 1; end
        if (balance >= 2) begin bet = 2; end
        if (balance >= 4) begin bet = 4; end        
        gameState = 1;
    end else if (gameState == 1) begin
        //todo: trigger coin place animation (which should automatically set gameState to 2 when done)
    end else if (gameState == 2) begin
        //trigger shuffling sequence
    end
end
always @(posedge upBtn) begin
    if (gameState == 0) begin //difficulty select
        difficulty = (difficulty + 1) % 4;
    end else if (gameState == 1) begin //set bet
        if (bet * 2 <= balance) begin
            bet = bet * 2;
        end
    end
end
always @(posedge downBtn) begin
    if (gameState == 0) begin //difficulty select
        difficulty = difficulty - 1;
        if (difficulty < 0) begin
            difficulty = difficulty + 4;
        end
    end else if (gameState == 1) begin //set bet
        if (bet > 1) begin
            bet = bet / 2;
        end
    end
end

always @(posedge clk) begin   
    

    


    counter = counter + 1;
end

always @(posedge counter[24]) begin
    state = state + 1;
    if (state == 1) begin
//        trigger = ~trigger;
        trigger = 1;
    end else
    if (state == 2) begin
        state = 0;
    end
end

    
endmodule
