pragma solidity ^0.4.18;

contract TicTacToe {
  address[2] players;
  uint16[2] moves;
  
  // 0 for Player1 // 1 for Player2
  uint8 turn = 2;
  uint16[] winnings = [0x49, 0x92, 0x124, 0x7, 0x38, 0x1C0, 0x111, 0x54];
  
  // Who creates the game is always Player0 
  function TicTacToe(address otherPlayer) public payable {
      if (msg.value == 1 ether) { //deposit made
        players[0] = msg.sender;
        players[1] = otherPlayer;
      }
      //TODO: do not create game if deposit is not made
  }
  
  function deposit() public payable {
      if (msg.value != 1 ether && msg.sender != players[1]) return;
      //TODO: pick starting player
      turn = 0;
  }
  
  function play(uint8 position) public {
      if (turn == 2) return; //Game not running
      if (msg.sender != players[turn]) return;
      
      uint16 move = uint16(0x1) << position;
      //Check if the other player already made this move
      if (moves[(turn + 1) % 2] & move == move) return;
      
      // Set the play
      moves[turn] |= move;
      
      checkWinner();
      
      if ((moves[0] | moves[1]) == 0x1FF) { // tie
          turn = 2; // end game
      } else {
          turn = (turn + 1) % 2;
      }
  }
  
  function checkWinner() private {
      for (uint8 i = 0; i < winnings.length; i++) {
          if (winnings[i] & moves[turn] == winnings[i]) {
              //Winner 
              turn = 2; //End game
              break;
          } 
      }
  }
}
