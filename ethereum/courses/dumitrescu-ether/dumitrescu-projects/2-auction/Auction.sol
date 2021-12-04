// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract AuctionCreator {
    Auction[] public deployedAuctions;
    function deploy() public {
        Auction new_auction = new Auction(msg.sender);
        deployedAuctions.push(new_auction);
    }
}

contract Auction {
    address payable public owner;
    address payable public highestBidder;
    uint public startBlock;
    uint public endBlock;
    uint public bidIncrement;
    uint public highestBindingBid;
    string public ipfsHash;
    
    mapping(address => uint) public bids;
    
    enum State {Started, Running, Ended, Cancelled}
    State public auctionState;


    constructor(address eoa) {
        owner = payable(eoa);
        auctionState = State.Running;
        startBlock = block.number;
        // auction will run for a week
        endBlock = startBlock + 4;
        ipfsHash = "";
        bidIncrement = 1000000000000000000;
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

    //     function placeBid() public payable notOwner afterStart beforeEnd {
    //     require(auctionState == State.Running);
    //     require(msg.value >= 100);
    //     uint currentBid = bids[msg.sender] + msg.value;
    //     bids[msg.sender] = currentBid;
    //     if(currentBid > highestBindingBid){
    //         if(currentBid <= bids[highestBidder]){
    //             highestBindingBid = min(currentBid + bidIncrement, bids[highestBidder]);
    //         } else {
    //             highestBindingBid = min(currentBid, bids[highestBidder] + bidIncrement);
    //             highestBidder = payable(msg.sender);
    //         }
    //     }

    // }


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

    function cancelAuction() public payable onlyOwner {
        require(auctionState == State.Running);
        auctionState = State.Cancelled;
    }

    function finalizeAuction() public payable {
        require(auctionState == State.Cancelled || block.number > endBlock);
        require(msg.sender == owner || bids[msg.sender] > 0);
        address payable recipient;
        uint value;

        if(auctionState == State.Cancelled){
            recipient = payable(msg.sender);
            value = bids[msg.sender];
        } else { // if auction ended
            if(msg.sender == owner){ // this is the owner
                recipient = owner;
                value = highestBindingBid;
            } else { // this is a bidder
                if(msg.sender == highestBidder) {
                    recipient = highestBidder;
                    value = bids[highestBidder] - highestBindingBid;
                } else { // this is neither the owner nor the highestBidder
                    recipient = payable(msg.sender);
                    value = bids[msg.sender];
                    }
                }
        }
        // exclude recipient from bids mapping
        bids[recipient] = 0;
        recipient.transfer(value);
    }

    function withdrawal() public payable {
        require(auctionState == State.Cancelled);
    }
}