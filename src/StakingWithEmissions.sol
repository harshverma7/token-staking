// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

interface IToken{
    function mint(address _to,uint _amount) external;
}

contract StakingWithEmissions {
    mapping (address=>uint) stakes;
    uint public totalstakes;
    uint256 public REWARD_PER_SEC_PER_ETH = 1;

    IToken public token;

    struct UserInfo {
        uint stakedAmount;
        uint rewardDebt;
        uint lastUpdate;
    }

    mapping(address=> UserInfo) public userInfo;

    constructor(IToken _token){
        token = _token;
    }

    function _updateRewards(address _user) internal {
        UserInfo storage user = userInfo[_user];

        if(user.lastUpdate == 0){
            user.lastUpdate = block.timestamp;
            return;
        }

        uint256 timeDiff = block.timestamp - user.lastUpdate;
        if(timeDiff == 0){
            return;
        }

        uint256 additionalReward = (user.stakedAmount * timeDiff * REWARD_PER_SEC_PER_ETH);

        user.rewardDebt += additionalReward;
        user.lastUpdate = block.timestamp;

    }

    function stake(uint256 _amount) external payable {
        require(_amount > 0, "amount cannot be null");
        require(_amount == msg.value,"value does not match the amount mentioned");
        _updateRewards(msg.sender);
        userInfo[msg.sender].stakedAmount += _amount;
        totalstakes += _amount;
    }

    function unstake(uint256 _amount) external payable{
        require(_amount > 0, "amount cannot be null");
        UserInfo storage user = userInfo[msg.sender];
        require(user.stakedAmount >= _amount,"not enough staked");

        _updateRewards(msg.sender);
        user.stakedAmount -= _amount;
        totalstakes -= _amount;

        payable(msg.sender).transfer(_amount);
    }

    function claimEmissions() public {
    _updateRewards(msg.sender);
    UserInfo storage user = userInfo[msg.sender];
    token.mint(msg.sender, user.rewardDebt);
    user.rewardDebt = 0;
    }

    function getRewards() public view returns(uint){
        uint256 timeDiff = block.timestamp - userInfo[msg.sender].lastUpdate;
        if (timeDiff == 0) {
            return userInfo[msg.sender].rewardDebt;
        }

        return userInfo[msg.sender].rewardDebt + (userInfo[msg.sender].stakedAmount * timeDiff * REWARD_PER_SEC_PER_ETH);
    }






}
