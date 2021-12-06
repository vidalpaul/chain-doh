// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract BaseContract {
    int public x;
    address public owner;

    constructor(){
        x = 1;
        owner = msg.sender;
    }

    function setX(int _x) public {
        x = _x;
    }
}

contract A is BaseContract{
    int public y = 2;
}