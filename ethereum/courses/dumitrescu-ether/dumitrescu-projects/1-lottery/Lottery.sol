// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract Lottery {
    address public manager;
    address payable[] public players;
    // uint public ticketPrice; to do: add variable ticket price

    constructor() {
        manager = msg.sender;
        // ticketPrice = _ticketPrice;
    }

    receive() external payable {
        require(msg.value == 0.1 ether);
        players.push(payable(msg.sender));
    }

    function getBalance() public view returns (uint) {
        require(msg.sender == manager);
        return address(this).balance;
    }

    // declared as public so it can be tested in remix, but could be internal
    function random() public view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
    }

    function pickWinner() public {
        require(msg.sender == manager);
        require(players.length >= 3);
        address payable winner;
        uint r = random();
        uint idx = r % players.length;
        winner = players[idx];
        winner.transfer(getBalance());
        players = new address payable[](0); // resetting the lottery
    }

}