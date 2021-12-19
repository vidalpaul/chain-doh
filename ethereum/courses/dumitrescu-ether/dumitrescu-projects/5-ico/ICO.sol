// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import './Token.sol';

contract ChihuahaICO is Chihuahua {
    address public admin;
    // it is safer than storing the Ether in the contract
    address payable public deposit;
    uint public tokenPrice = 0.001 ether; // 1 ETH = 1000 CHI
    uint public hardCap = 300 ether;
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

    modifier onlyAdmin() {
        require(msg.sender == admin);
        _;
    }

    // Start emergency administrative functions
    function halt() public onlyAdmin {
        ICOState = State.halted;
    }

    function resume() public onlyAdmin {
        ICOState = State.running;
    }

    function changeDepositAddress(address payable newDeposit) public onlyAdmin {
        deposit = newDeposit;
    }

    function getCurrentState() public view returns (State) {
        if(ICOState == State.halted){
            return State.halted;
        } else if(block.timestamp < saleStart){
            return State.beforeStart;
        } else if(block.timestamp <= saleEnd){
            return State.running;
        } else {
            return State.afterEnd;
        }
    }
    // End of emergency functions

    event Invest(address investor, uint value, uint tokens);

    function invest() payable public returns (bool){
        ICOState = getCurrentState();
        require(ICOState == State.running);
        require(msg.value <= maxInvestment && msg.value >= minInvestment);
        raisedAmount += msg.value;
        require(raisedAmount <= hardCap);
        uint tokens = msg.value / tokenPrice;
        balances[msg.sender] += tokens;
        balances[founder] -= tokens;
        deposit.transfer(msg.value);
        emit Invest(msg.sender, msg.value, tokens);
        return true;
    }

    receive() payable external {
        invest();
    }
}