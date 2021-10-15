pragma solidity ^0.4.17;

contract Campaign {
    struct Request {
        string description;
        uint value;
        address recipient;
        bool complete;
    }
    
    
    address public manager;
    uint public minimumContribution;
    address[] public approvers;
    Request[] public requests;
    
    function Campaign(uint minimum) public {
        manager = msg.sender;
        minimumContribution = minimum;
    }
    
    function contribute() public payable {
        require(msg.value > minimumContribution);
        approvers.push(msg.sender);
    }
    
    function createRequest() restricted {}
    
    // function approveRequest() contributor {}
    
    function finalizeRequest() restricted {}
    
    modifier restricted() {
        require(msg.sender == manager);
        _;
    }
    
    // modifier contributor() {
    //     require(msg.sender in approvers);
    //     _;
    // }

}