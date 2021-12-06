// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

// contract CampaignFactory{
//     Campaign[] public deployedCampaigns;

//     function deployCampaign(uint goal, uint deadline) public {
//         Campaign newCampaign = new Campaign(msg.sender, goal, deadline);
//         deployedCampaigns.push(newCampaign);
//     }
// }

contract Campaign {
    address payable admin;
    uint public nOfContributors;
    uint public minimumContribution;
    uint public goal;
    uint public deadline; // timestamp
    uint public raisedAmount;
    uint public nOfRequests;
    mapping(address => uint) public contributors;
    struct Request {
        string description;
        address payable recipient;
        uint value;
        bool completed;
        uint nOfVoters;
        mapping(address => bool) voters;
    }
    mapping(uint => Request) public requests;

    constructor(uint _goal, uint _deadline){
        // admin = payable(eoa);
        admin = payable(msg.sender);
        goal = _goal;
        deadline = block.timestamp + _deadline;
        minimumContribution = 100 wei;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin);
        _;
    }

    function contribute() public payable {
        require(block.timestamp < deadline, "Deadline has passed");
        require(msg.value >= minimumContribution, "Minimum contribution not met");
        if(contributors[msg.sender] == 0){
            nOfContributors++;
        }
        contributors[msg.sender] += msg.value;
        raisedAmount += msg.value;
    }

    receive() payable external {
        contribute();
    }

    function getBalance() public view returns(uint){
        return address(this).balance;
    }

    function getRefund() public {
        require(block.timestamp > deadline && raisedAmount < goal);
        require(contributors[msg.sender] > 0);
        address payable recipient = payable(msg.sender);
        uint value = contributors[msg.sender];
        recipient.transfer(value);
        contributors[msg.sender] = 0;
    }

    function createRequest(string memory _description, address payable _recipient, uint _value) public onlyAdmin {
        Request storage newRequest = requests[nOfRequests];
        newRequest.description = _description;
        newRequest.recipient = _recipient;
        newRequest.value = _value;
        newRequest.completed = false;
        newRequest.nOfVoters = 0;
        nOfRequests++;
    }

    function voteForRequest(uint _requestNo) public {
        require(contributors[msg.sender] > 0, "You must be a contributor to vote");
        Request storage thisRequest = requests[_requestNo];
        require(thisRequest.voters[msg.sender] == false, "You have already voted");
        thisRequest.voters[msg.sender] = true;
        thisRequest.nOfVoters++;
    }

    function makePayment(uint _requestNo) public onlyAdmin {
        require(raisedAmount >= goal);
        Request storage thisRequest = requests[_requestNo];
        require(thisRequest.completed == false, "The request is already completed");
        require(thisRequest.nOfVoters > nOfContributors / 2);
        thisRequest.recipient.transfer(thisRequest.value);
        thisRequest.completed = true;
    }