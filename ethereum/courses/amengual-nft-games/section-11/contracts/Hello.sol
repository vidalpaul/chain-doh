// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Hello {

    string public message = "Hola mundo";

    function getMessage() public view returns (string memory) {
        return message;
    }

    function setmessage(string memory _message) public {
        message = _message;
    }

}