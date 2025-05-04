// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

contract StakingContract { 

    mapping (address=>uint) stakes;
    uint public totalStake;

    constructor(){

    }

    function stake(uint _amount) public payable {
        require(_amount > 0, "amount is too small");
        require(msg.value == _amount, "Eth send does not match the amount");
        stakes[msg.sender] += _amount;
        totalStake += _amount;
    }

    function unstake(uint _amount) public payable {
        require(_amount > 0 ,  "amount is too small");
        require(stakes[msg.sender] >= _amount , "insufficient stakes");
        payable(msg.sender).transfer(_amount);
        totalStake -= _amount;
        stakes[msg.sender] -= _amount;
    }

}
