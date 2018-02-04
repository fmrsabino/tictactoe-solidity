pragma solidity ^0.4.18;

contract TicTacToe {
  address[2] players;
  uint16[2] moves;
  uint256[2] deposits;
  
  // 0 for Player1 // 1 for Player2
  uint8 turn = 2;
  uint16[] winnings = [0x49, 0x92, 0x124, 0x7, 0x38, 0x1C0, 0x111, 0x54];
  
  // Who creates the game is always Player0 
  function TicTacToe(address otherPlayer) public payable {
      players[0] = msg.sender;
      players[1] = otherPlayer;
      deposit();
  }
  
  function deposit() public payable {
      if (msg.sender == players[0]) {
          deposits[0] += msg.value;
      } else if (msg.sender == players[1]) {
          deposits[1] += msg.value;
      }
      
      if (deposits[0] >= 1 ether && deposits[1] >= 1 ether) {
          turn =  uint8(uint256(block.blockhash(block.number)) % 2);
      }
  }
  
  function play(uint8 position) public {
      require(turn != 2);
      require(msg.sender == players[turn]);
      
      uint16 move = uint16(0x1) << position;
      //Check if the other player already made this move
      if (moves[(turn + 1) % 2] & move == move) return;
      
      // Set the play
      moves[turn] |= move;
      
      checkWinner();
      
      if ((moves[0] | moves[1]) == 0x1FF) { // tie
          endGame();
          players[0].transfer(1 ether);
          players[1].transfer(1 ether);
      } else {
          turn = (turn + 1) % 2;
      }
  }
  
  function checkWinner() private {
      for (uint8 i = 0; i < winnings.length; i++) {
          if (winnings[i] & moves[turn] == winnings[i]) {
              //Winner 
              endGame();
              players[turn].transfer(2 ether);
              break;
          } 
      }
  }
  
  function endGame() private {
      turn = 2;
      moves[0] = 0;
      moves[1] = 0;
      // If the user transfered more than 1 ether we shouldn't reset the deposit to zero
      deposits[0] -= 1 ether;
      deposits[1] -= 1 ether;
  }
}
