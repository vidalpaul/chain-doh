// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Ganache {
    string message = "";
    uint [] list;

    // Publica un mensaje en la cadena de bloques
    function setMessage(string memory _message) public {
        message = _message;
    }

    // Visualizar el mensaje de la cadena de bloques
    function getMessage() public view returns (string memory) {
        return message;
    }
    
}