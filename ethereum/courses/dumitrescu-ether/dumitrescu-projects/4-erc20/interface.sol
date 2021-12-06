// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

// interfaces cannot have any function implemented, can be inherited. cannot inherit from other contracts, but can inherit from other interfaces
// all declared functions must be external
// they cannot declare a constructor
// they cannot declare state variables
// some of these restrictions might be lifted in the future
interface Base {
    // int public x;
    // address public owner;

    // constructor(){
    //     x = 1;
    //     owner = msg.sender;
    // }

    function setX(int _x) external;
}

contract A is Base{
    int public x = 2;
    int public y = 2;

    // the overriden function may only change the visibility to public
    function setX(int _x) public override {
        x = _x;
    }

    // must have the same signature
    // function setX(uint _x) public override {
    //     x = _x;
    // }
}
