// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.10;

contract Property {
    int public price;
    string constant public LOCATION = "London";

    // price = 100; this is not permitted in Solidity

    function f1() public pure returns (int) {
        int x = 5;
        x = x* 2;

        // storage vs stack vs memory
        // reference types string, array, struct and mapping
        string memory myString = "abc";

        return x;
    }

    function setPrice(int _price) public {
        price = _price;
    }

    function getprice() public view returns (int){
        return price;
    }
}