// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.18;



contract MosjidFundRaising{

    address payable public Owner;
    uint public totalFundNe;
    uint public totalFundRaised;
    uint public totalDonar;
    uint public totalVote;
    uint public votingEndTime;
    uint remainingFund;
    uint totalAsk = 1;
    uint public endTime;
    bool fundClamed;
    bool public votingStatus;

    //mapping all donaars
    mapping (address => uint) public donars;
    //here mapping all voted 
    mapping (address => bool) public voted;

    constructor(uint _totalFundReq,uint _endTime){
        Owner = payable(msg.sender);
        endTime = block.timestamp + _endTime;
        totalFundNe = _totalFundReq;
    }

    function sendFund() external payable {
        require(block.timestamp<endTime,"headline have passed");
        require(msg.sender != Owner,"onwer never give up any money");
        require(msg.value==0,"you can send minimum 1 ");
        //check the new contributeer

        if(donars[msg.sender]==0){
            totalDonar ++;
        }
        donars[msg.sender]=donars[msg.sender] + msg.value;
        totalFundRaised = totalFundRaised + msg.value;
    }

    function getContractBalance() external view returns(uint){
        return address(this).balance;
    }

    function startVoting(uint _votingEndTime) external{
        require(msg.sender == Owner,"voting start only can owneer");
        require(block.timestamp>endTime,"headlin pased yet");
        votingEndTime = block.timestamp + _votingEndTime;
         votingStatus = true;
    }
    
    function putVote() external {
        require(votingStatus == true,"voting has not starting yet!");
        require(block.timestamp<votingEndTime," voting time has passed");
        require(donars[msg.sender] != 0,"You are not allowed to participate as you have not cotributed!!");
        require(voted[msg.sender] == false,"you already voted");
        totalVote ++;
        voted[msg.sender] = true;
    }

    function claimFund() public{
        require(fundClamed == false,"fund already claimed!");
        require(msg.sender == Owner, "only claimed this fund owner!");
        require(block.timestamp > endTime, "crowdfunding not over yet!");

        if ( totalAsk == 1){
            uint transferAmt = totalFundRaised / 10; // fund frist time given 10%;
            remainingFund = totalFundRaised - transferAmt;
            totalAsk ++;
            Owner.transfer(transferAmt);
        }else {
            require(block.timestamp > votingEndTime, "voting have not yet passed");
            require(totalVote > totalDonar / 2,"mojeroty can not support");
            fundClamed = true;
            uint transferAmt = remainingFund;
            remainingFund = 0;
            Owner.transfer(transferAmt);
        }
    }

}