pragma solidity ^0.8.0;

contract SmartBank {
    uint totalFund ;
    mapping(address => uint) balances;
    mapping(address => uint) depositTimestamps;

    constructor(uint totalFund_) public payable {
        totalFund = totalFund_;
    }

    function showTotalBalance() public returns(uint) {
        return totalFund;
    } 

    function showBalance(address userAddress) public returns(uint) {
        uint principal = balances[userAddress];
        uint timeElapsed = block.timestamp - depositTimestamps[userAddress];
        uint currentBalance = principal + uint((principal * 7 * timeElapsed) / (100 * 365 * 24 * 60 * 60));
        //require(totalFund >= (currentBalance - principal));
        balances[userAddress] = currentBalance;// account balance updated
        depositTimestamps[userAddress] = block.timestamp;//now time will be counted from here
        return currentBalance;
    }
     
    function AddBalance(uint Amount) public payable {
        uint principal = balances[msg.sender];
        uint timeElapsed = block.timestamp - depositTimestamps[msg.sender];
        uint currentBalance = principal + uint((principal * 7 * timeElapsed) / (100 * 365 * 24 * 60 * 60));
        balances[msg.sender] = currentBalance + Amount;
        depositTimestamps[msg.sender] = block.timestamp;
        totalFund = totalFund + Amount;
    }

    function Transfer(address receiver, uint numTokens) public returns (bool) {
        uint principal = balances[msg.sender];
        uint timeElapsed = block.timestamp - depositTimestamps[msg.sender];
        uint currentBalance = principal + uint((principal * 7 * timeElapsed) / (100 * 365 * 24 * 60 * 60));
        //require(
        balances[msg.sender] = currentBalance - numTokens;
        uint principal2 = balances[receiver];
        uint timeElapsed2 = block.timestamp - depositTimestamps[receiver];
        uint currentBalance2 = principal2 + uint((principal2 * 7 * timeElapsed2) / (100 * 365 * 24 * 60 * 60));
        balances[receiver] = currentBalance2 + numTokens;

        depositTimestamps[msg.sender] = block.timestamp;
        depositTimestamps[receiver] = block.timestamp;
        
        return true;
    }

    function Withdraw(uint Amount) public payable returns (bool){
        //require();
        uint principal = balances[msg.sender];
        uint timeElapsed = block.timestamp - depositTimestamps[msg.sender];
        uint currentBalance = principal + uint((principal * 7 * timeElapsed) / (100 * 365 * 24 * 60 * 60));
        require(totalFund >= Amount);
        if(currentBalance>=Amount){
            payable(msg.sender).transfer(Amount);
            balances[msg.sender] = currentBalance - Amount;// account balance updated
            depositTimestamps[msg.sender] = block.timestamp;//now time will be counted from here
            totalFund = totalFund - Amount ;//interest deducted from totalfund        
            return true;
        }
        else{
            return false;
        }
    }

}