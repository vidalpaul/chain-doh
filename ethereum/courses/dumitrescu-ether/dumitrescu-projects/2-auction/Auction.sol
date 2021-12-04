// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract Auction {
    address payable public owner;
    address payable highestBidder;
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

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    modifier notOwner() {
        require(msg.sender != owner);
        _;
    }

    modifier afterStart() {
        require(block.number >= startBlock);
        _;
    }

    modifier beforeEnd() {
        require(block.number <= endBlock);
        _;
    }

    function min(uint a, uint b) pure internal returns(uint) {
        if(a <= b){
            return a;
        } else {
            return b;
        }

    }

    function placeBid() public payable notOwner afterStart beforeEnd {
        require(auctionState == State.Running);
        require(msg.value >= 100);
        uint currentBid = bids[msg.sender] + msg.value;
        require(currentBid > highestBindingBid);
        bids[msg.sender] = currentBid;
        if(currentBid <= bids[highestBidder]){
            highestBindingBid = min(currentBid + bidIncrement, bids[highestBidder]);
        } else {
            highestBindingBid = min(currentBid, bids[highestBidder] + bidIncrement);
            highestBidder = payable(msg.sender);
        }
    }
}