// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

// ERC20 is a standard interface used by application such as wallets, decentralized exchanges, and so on to interact with tokens
// a fully compatible ERC20 token must implement 6 functions and 2 events

contract Chihuahua is ERC20Interface {
    string public name = "Chihuahua";
    string public symbol = "CHI";
    uint public decimals = 0; // up to 18
    uint public override totalSupply;

    address public founder;
    mapping(address => uint) public balances;

    constructor(){
        totalSupply = 1000000;
        founder = msg.sender;
        balances[founder] = totalSupply;
    }

    function balanceOf(address tokenOwner) public view override returns (uint balance) {
        return balances[tokenOwner];
    }

    function transfer(address to, uint tokens) public override returns (bool success) {
        require(balances[msg.sender] >= tokens);

        balances[msg.sender] -= tokens;
        balances[to] += tokens;

        emit Transfer(msg.sender, to, tokens);

        return true;
    };
}