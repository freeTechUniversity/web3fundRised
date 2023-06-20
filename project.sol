// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.18;

contract youtubeChanelFundReice{
    address payable public owner;
    uint public totalFundReq;
    uint public totalFundReice;
    uint public totalDonors;
    uint public totalVoting;
    uint public votingEndTime;
    uint fundRemning;
    uint public puteVoting;
    uint totalAsk = 1;
    uint public endTime;
    bool public votingStatus;
    bool public claimedFund;

    //here maping all donars address and doller count
    mapping(address=>uint) public donars;
    //here maping all vote that mean here partecipents vote count;
    mapping(address => bool) public voted;

    //here used cnstructor here set the fund rished and endTime and set the Owner;
    constructor(uint _totalFundReq,uint _endTime ){
        owner = payable(msg.sender);
        totalFundReice = _totalFundReq;
        endTime = block.timestamp + _endTime;
    } 

    //everyOne gives that doller thst's doller deposite here;
    function depositeFunction() external payable{
        require(block.timestamp<endTime,"function also going well!");
        require(msg.sender != owner,"you can't give any money!");
        require(msg.value == 0,"you can't give 0 miniuem given 1!");

        //check the new contribute 
        if(donars[msg.sender]==0){
            totalDonors ++;
        }

    donars[msg.sender] = donars[msg.sender] + msg.value;
    totalFundReice = totalFundReice + msg.value;

    }

    function checkBalance() external view returns(uint){
       return address(this).balance;
    }
    
    function controlingVotingSystem(uint _votingEndTime) external{
    require(msg.sender == owner,"this voting system stating only owner");
    require(block.timestamp>endTime,"voting system hava stating");
    votingEndTime = block.timestamp + _votingEndTime;
    votingStatus = true;
    }

    function puteVotingHere() external {
        require(votingStatus == true,"voting status not stating");
        require(block.timestamp<votingEndTime,"voting time finsed");
        require(donars[msg.sender] != 0,"you can't participet here");
        require(voted[msg.sender] == false,"you already voted");
         totalVoting ++;
         voted[msg.sender] = true;
    }

    function claimedFunction() public {
        require(claimedFund == false,"fund already claimed");
        require(msg.sender == owner,"only can claimed owner!");
        require(block.timestamp>endTime,"this fund that mean crowdfunding are not finsed");
        

        if(totalAsk == 1){
            uint transferAmount = totalFundReice /10; // fund first time given 10%
            fundRemning = totalFundReice - transferAmount;
            totalAsk ++;
            claimedFund == true;
            owner.transfer(transferAmount);
        }else{
            require(block.timestamp > votingEndTime, "voting have not yet passed");
            require(totalVoting > totalDonors / 2 ," herre voting divided");
            votingStatus == true;
            uint transferAmount = fundRemning;
            fundRemning = 0;
            owner.transfer(transferAmount);
        }
    }
}