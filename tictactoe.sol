pragma solidity ^0.4.18;

contract TicTacToe {
  address player1;
  address player2;
  //0 for Player 1 // 1 for Player 2
  uint8 turn;

  bool missingDeposit = true;
  uint16 player1Plays = 0x0;
  uint16 player2Plays = 0x0;
  
  uint16[] winnings = [0x49, 0x92, 0x124, 0x7, 0x38, 0x1C0, 0x111, 0x54];
  
  //Who creates the game is always Player1 
  function TicTacToe(address otherPlayer) public payable {
      if (msg.value == 1 ether) { //deposit made
        player1 = msg.sender;
        player2 = otherPlayer;
      }
      //TODO: do not create game if deposit is not made
  }
  
  function deposit() public payable {
      if (!missingDeposit) return;
      if (msg.value != 1 ether && msg.sender != player2) return;
      missingDeposit = false;
      //TODO: pick starting player
  }
  
  function play(uint8 position) public {
      uint16 plays;
      if (msg.sender == player1 && turn == 0) {
          plays = player1Plays;
      } else if (msg.sender == player2 && turn == 1) {
          plays = player2Plays;
      } else {
          return;
      }
      
      uint16 move = uint16(0x1) << position;
      //Check if the other player already made this move
      if (msg.sender == player1 && (player2Plays & move) == move || 
          msg.sender == player2 && (player1Plays & move) == move) {
          return;
      }
      
       // Set the play
      if (msg.sender == player1) {
          player1Plays |= move;
      } else {
          player2Plays |= move;
      }
      
      // Check the winner
      for (uint8 i = 0; i < winnings.length; i++) {
          if (winnings[i] & plays == winnings[i]) {
              //Winner 
              turn = 2; //End game
              break;
          } 
      }
      
      // Check tie
      if ((player1Plays | player2Plays) == 0x1FF) {
          turn = 2; // end game
      } else {
          turn = (turn + 1) % 2;
      }
  }
}
