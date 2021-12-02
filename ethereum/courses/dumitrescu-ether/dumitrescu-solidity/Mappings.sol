// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract Auction {
// mappings are always saved in storage
// the keys can not be of types mapping, dynamic array, enum or struct
// the values can be any type including mapping
// lookup time is constant no matter of size, while arrays have linear search time
// mappings are not iterables
// keys are not saved into the mapping
    mapping(address => uint) public bids;

    function bid() payable public {
        bids[msg.sender] = msg.value;
    }
}