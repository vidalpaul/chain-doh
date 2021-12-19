// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import './Token.sol';

contract ChihuahaICO is Chihuahua {
    address public admin;
    // it is safer than storing the Ether in the contract
    address payable public deposit;
    uint public tokenPrice = 0.001 ether; // 1 ETH = 1000 CHI
    uint public hardcap = 300 ether;
    uint public raisedAmount; // this value will be in wei
    uint public saleStart = block.timestamp;
    uint public saleEnd = block.timestamp +  604800; // sale ends in one week
    uint public tokenTradeStart = saleEnd + 604800; // transferable in a week after sale end
    uint public maxInvestment = 5 ether;
    uint public minInvestment = 0.1 ether;

    enum State {beforeStart, running, afterEnd, halted}
    State public ICOState;

    constructor(address payable _deposit) {
        deposit = _deposit;
        admin = msg.sender;
        ICOState = State.beforeStart;
    }
}