// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract CampaignFactory{
    Campaign[] public deployedCampaigns;

    function deployCampaign(uint goal, uint deadline) public {
        Campaign newCampaign = new Campaign(msg.sender, goal, deadline);
        deployedCampaigns.push(newCampaign);
    }
}

contract Campaign {
    address payable admin;
    uint public nOfContributors;
    uint public minimumContribution;
    uint public goal;
    uint public deadline; // timestamp
    uint public raisedAmount;
    mapping(address => uint) public contributors;

    constructor(address eoa, uint _goal, uint _deadline){
        admin = payable(eoa);
        goal = _goal;
        deadline = block.timestamp + _deadline;
        minimumContribution = 100 wei;
    }

    modifier onlyOwner() {
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

    
}