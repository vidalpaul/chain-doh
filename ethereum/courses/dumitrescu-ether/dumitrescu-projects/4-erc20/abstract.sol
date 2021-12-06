// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

// abstract contracts cannot be deployed
abstract contract BaseContract {
    int public x;
    address public owner;

    constructor(){
        x = 1;
        owner = msg.sender;
    }

    function setX(int _x) public virtual;
}

contract A is BaseContract{
    int public y = 2;

    function setX(int _x) public override {
        x = _x;
    }
}

abstract contract B is BaseContract{
    int public y = 3;
}