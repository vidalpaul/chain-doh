// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract CampaignFactory{
    Campaign[] public deployedCampaigns;

    function deployCampaign() public {
        Campaign newCampaign = new Campaign(msg.sender);
        deployedCampaigns.push(newCampaign);
    }
}

contract Campaign {
    address payable owner;
    constructor(address eoa){
        owner = payable(eoa);
    }
}