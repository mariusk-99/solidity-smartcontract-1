//SPDX-License-Identifier: Unlicense
pragma solidity ^0.4.24;
/**
 * @title TicTacToe contract
 **/
contract TicTacToe {
    address[2] public players;

    /**
     turn
     1 - players[0]'s turn
     2 - players[1]'s turn
     */
    uint public turn = 1;

    // Count no. of moves
    uint private movesTotal = 0;

    /**
     status
     0 - ongoing
     1 - players[0] won
     2 - players[1] won
     3 - draw
     */
    uint public status;

    /**
    board status
     0    1    2
     3    4    5
     6    7    8
     */
    uint[9] private board;

    /**
      * @dev Deploy the contract to create a new game
      * @param opponent The address of player2
      **/
    constructor(address opponent) public {
        require(msg.sender != opponent, "No self play");
        players = [msg.sender, opponent];
    }

    /**
      * @dev Check a, b, c in a line are the same
      * _threeInALine doesn't check if a, b, c are in a line
      * @param a position a
      * @param b position b
      * @param c position c
      **/    
    function _threeInALine(uint a, uint b, uint c) private view returns (bool){
        if(board[a]==0 || board[b]==0 || board[c]==0){
            return false;
        }
        if (board[a]==board[b] && board[b] == board[c]){
            return true;
        } 
        return false;
    }

    /**
     * @dev get the status of the game
     * @param pos the position the player places at
     * @return the status of the game
     */

    function _getStatus(uint pos) private view returns (uint) {
        
        //Row check
        uint row = pos/3;
        if (_threeInALine(pos, (pos+1)%3 + 3*row, (pos+2)%3 +3*row)){
            return turn%2 + 1;
        }

        //Column check
        if (_threeInALine(pos, (pos+3)%9, (pos+6)%9)){
            return turn%2 + 1;
        }

        //Diagonal check
        if (pos%2==0 && board[4]!=0){
          if (_threeInALine(0, 4, 8) || _threeInALine(2, 4, 6))
          return turn%2 + 1;
        }

        //Draw check
        if (movesTotal>=9)
          return 3;

        return 0;
    }

        /**
     * @dev ensure the game is still ongoing before a player moving
     * update the status of the game after a player moving
     * @param pos the position the player places at
     */
    modifier _checkStatus(uint pos) {
        require(status== 0);
        _;
        status = _getStatus(pos);
        movesTotal+=1;
    }

    /**
     * @dev check if it's msg.sender's turn
     * @return true if it's msg.sender's turn otherwise false
     */
    function myTurn() public view returns (bool) {
        return msg.sender ==  players[turn-1];

    }

    /**
     * @dev ensure it's a msg.sender's turn
     * update the turn after a move
     */
    modifier _myTurn() {
        require(myTurn());
        _;
        turn = turn%2 +1;
    }

    /**
     * @dev check a move is valid
     * @param pos the position the player places at
     * @return true if valid otherwise false
     */
    function validMove(uint pos) public view returns (bool) {
        return board[pos] == 0;
    }

    /**
     * @dev ensure a move is valid
     * @param pos the position the player places at
     */
    modifier _validMove(uint pos) {
        require(validMove(pos));
        require(pos>=0 && pos<=8);
        _;
    }

    /**
     * @dev a player makes a move
     * @param pos the position the player places at
     */  
    function move(uint pos) public _validMove(pos) _checkStatus(pos) _myTurn {
        board[pos] = turn;
    }

    /**
     * @dev show the current board
     * @return board
     */
    function showBoard() public view returns (uint[9]) {
        return board;
    }
}