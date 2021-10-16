pragma solidity ^0.4.17;

contract Campaign {
    struct Request {
        string description;
        uint value;
        address recipient;
        bool complete;
        uint approvalCount;
        mapping(address => bool) voters;
    }
    
    address public manager;
    uint public minimumContribution;
    mapping(address => bool) public approvers;
    Request[] public requests;
    
    modifier restricted() {
        require(msg.sender == manager);
        _;
    }
   
    function Campaign(uint minimum) public {
        manager = msg.sender;
        minimumContribution = minimum;
    }
    
    function contribute() public payable {
        require(msg.value > minimumContribution);
        approvers[msg.sender] = true;
    }
    
    function createRequest(string description, uint value, address recipient) public restricted {
        Request memory newRequest = Request({
           description: description,
           value: value,
           recipient: recipient,
           complete: false,
           approvalCount: 0
        });
        
        // a worse way of doing it: Request(description, value, recipient, false);
        
        requests.push(newRequest);
    }
    
    function approveRequest(uint idx) public {
        require(approvers[msg.sender]);
        require(!requests[idx].voters[msg.sender]);
        requests[idx].approvalCount++;
        requests[idx].voters[msg.sender] = true;
    }
    
    function finalizeRequest(uint idx) public restricted {
        requests[idx].complete = true;
    }
}