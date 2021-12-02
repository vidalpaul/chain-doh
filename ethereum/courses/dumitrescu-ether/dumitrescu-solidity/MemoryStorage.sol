// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract Contract {
    string[] public cities = ['Paris', 'London'];

    function f_memory() public view {
        string[] memory s1 = cities;
        s1[0] = 'Berlin';
    }

    function f_storage() public {
        string[] storage  s1 = cities;
        s1[0] = 'Berlin';
    }
}