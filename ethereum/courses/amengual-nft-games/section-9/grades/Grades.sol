// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
// pragma experimental ABIEncoderV2;

contract Grades {
    // Direccion del profesor
    address public professor;

    constructor() public {
        professor = msg.sender;
    }
    
}