// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract FixedSizeArrays {
    uint[3] public numbers = [1, 2, 3];
    bytes1 public b1;
    bytes2 public b2;
    //.. up to bytes32
    bytes32 public b32;

    function setElement(uint idx, uint value) public {
        numbers[idx] = value;
    }

    function getLength() public view returns (uint) {
        return numbers.length;
    }

    function setByresArray() public {
        b1 = 'a';
        b2 = 'ab';
        b32 = 'abc';
        // byte is an alias for bytes1 in older code
    }
}

contract DynamicSizeArrays{
    uint[] public numbers;
    // .length, .push, .pop

    function getLength() public view returns (uint) {
        return numbers.length;
    }

    function addElement(uint item) public {
        numbers.push(item);
    }

    function getElement(uint i) public view returns(uint) {
        if(i < numbers.length){
            return numbers[i];
        }
        return 0;
    }

    // its cost depend on the idx of the element being removed
    function popElement() public {
        numbers.pop();
    }
}

contract MemoryArrays {
    uint[] public numbers;
    function f() public {
        uint[] memory y = new uint[](3);
        y[0] = 10;
        y[1] = 20;
        y[2] = 30;
        numbers = y;
    }
}