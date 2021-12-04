// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract Auction {
    address payable public owner;
    address payable highestBider;
    uint public startBlock;
    uint public endBlock;
    uint public bidIncrement;
    uint public highestBindingBid;
    string public ipfsHash;
    
    mapping(address => uint) public bids;
    
    enum State {Started, Running, Ended, Cancelled}
    State public auctionState;


    constructor() {
        owner = payable(msg.sender);
        auctionState = State.Running;
        startBlock = block.number;
        // auction will run for a week
        endBlock = startBlock + 40320;
        ipfsHash = "";
        bidIncrement = 100;
    }

    function placeBid() {}
}