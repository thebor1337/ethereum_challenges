// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./IERC20.sol";

contract StakingRewards {
    IERC20 public immutable stakingToken;
    IERC20 public immutable rewardsToken;

    address public owner;

    // Duration of rewards to be paid out (in seconds)
    uint public duration;
    // Timestamp of when the rewards finish
    uint public finishAt;
    // Minimum of last updated time and reward finish time
    uint public updatedAt;
    // Reward to be paid out per second
    uint public rewardRate;
    // Sum of (reward rate * dt * 1e18 / total supply)
    uint public rewardPerTokenStored;
    // User address => rewardPerTokenStored
    mapping(address => uint) public userRewardPerTokenPaid;
    // User address => rewards to be claimed
    mapping(address => uint) public rewards;

    // Total staked
    uint public totalSupply;
    // User address => staked amount
    mapping(address => uint) public balanceOf;

    constructor(address _stakingToken, address _rewardsToken) {
        owner = msg.sender;
        stakingToken = IERC20(_stakingToken);
        rewardsToken = IERC20(_rewardsToken);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "not authorized");
        _;
    }

    modifier updateReward(address _account) {
        // Code
        rewardPerTokenStored = rewardPerToken();
        updatedAt = lastTimeRewardApplicable();
        if (_account != address(0)) {
            rewards[_account] = earned(_account);
            userRewardPerTokenPaid[_account] = rewardPerTokenStored;
        }
        _;
    }

    function lastTimeRewardApplicable() public view returns (uint) {
        // Code
        return (block.timestamp <= finishAt) ? block.timestamp : finishAt;
    }

    function rewardPerToken() public view returns (uint) {
        // Code
        if (totalSupply == 0) {
            return rewardPerTokenStored;
        }
        uint _duration = lastTimeRewardApplicable() - updatedAt;
        return rewardPerTokenStored + rewardRate * _duration * 1e18 / totalSupply;
    }

    function stake(uint _amount) external updateReward(msg.sender) {
        // Code
        require(_amount > 0, "zero amount");
        stakingToken.transferFrom(msg.sender, address(this), _amount);
        balanceOf[msg.sender] += _amount;
        totalSupply += _amount;
    }

    function withdraw(uint _amount) external updateReward(msg.sender) {
        // Code
        require(_amount > 0, "zero amount");
        balanceOf[msg.sender] -= _amount;
        totalSupply -= _amount;
        stakingToken.transfer(msg.sender, _amount);
    }

    function earned(address _account) public view returns (uint) {
        // Code
        return ((balanceOf[_account] * (rewardPerToken() - userRewardPerTokenPaid[_account])) / 1e18) + rewards[_account];
        
    }

    function getReward() external updateReward(msg.sender) {
        // Code
        uint _rewards = rewards[msg.sender];
        rewards[msg.sender] = 0;
        rewardsToken.transfer(msg.sender, _rewards);
    }

    function setRewardsDuration(uint _duration) external onlyOwner {
        // Code
        require(block.timestamp > finishAt, "not expired");
        duration = _duration;
    }

    function notifyRewardAmount(uint _amount) external onlyOwner updateReward(address(0)) {
        // Code
        if (block.timestamp >= finishAt) {
            rewardRate = _amount / duration;
        } else {
            rewardRate = (_amount + rewardRate * (finishAt - block.timestamp)) / duration;
        }
        require(rewardRate > 0, "zero reward rate");
        require(
            rewardsToken.balanceOf(address(this)) >= rewardRate * duration,
            "not enough reward tokens"
        );
        updatedAt = block.timestamp;
        finishAt = block.timestamp + duration;
    }

    function _min(uint x, uint y) private pure returns (uint) {
        return x <= y ? x : y;
    }
}