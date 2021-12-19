// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import './ERC20Interface.sol';

// ERC20 is a standard interface used by application such as wallets, decentralized exchanges, and so on to interact with tokens
// a fully compatible ERC20 token must implement 6 functions and 2 events

contract Chihuahua is ERC20Interface {
    string public name = "Chihuahua";
    string public symbol = "CHI";
    uint public decimals = 0; // up to 18
    uint public override totalSupply;

    address public founder;
    mapping(address => uint) public balances;
    mapping(address => mapping(address => uint)) public allowed;
    // 0x1111... (owner) allows 0x2222... (the spender) --- 100 tokens
    // allowed[0x1111][0x2222] = 100;

    constructor(){
        totalSupply = 1000000;
        founder = msg.sender;
        balances[founder] = totalSupply;
    }

    function balanceOf(address tokenOwner) public view override returns (uint balance) {
        return balances[tokenOwner];
    }

    function transfer(address to, uint tokens) public virtual override returns (bool success) {
        require(balances[msg.sender] >= tokens, "Not enough tokens");

        balances[msg.sender] -= tokens;
        balances[to] += tokens;

        emit Transfer(msg.sender, to, tokens);

        return true;
    }

    function allowance(address tokenOwner, address spender) view public override returns(uint){
        return allowed[tokenOwner][spender];
    }

    function approve(address spender, uint tokens) public override returns (bool success) {
        require(balances[msg.sender] >= tokens, "Not enough tokens");
        require(tokens > 0, "Cannot send 0 tokens");
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }

    function transferFrom(address from, address to, uint tokens) public virtual override returns (bool success){
        require(allowed[from][to] >= tokens, "Not enough allowed tokens");
        require(balances[from] >= tokens, "Not enough tokens");
        balances[from] -= tokens;
        allowed[from][to] -= tokens;
        balances[to] += tokens;
        return true;
    }
}