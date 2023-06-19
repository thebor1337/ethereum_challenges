// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./IERC20.sol";

import "hardhat/console.sol";

contract DiscreteStakingRewards {
    IERC20 public immutable stakingToken;
    IERC20 public immutable rewardToken;
    
    mapping(address => uint) public balanceOf;
    uint public totalSupply;
    
    uint private rewardIndex;
    mapping(address => uint) private rewardIndexOf;
    mapping(address => uint) private earned;
    
    uint private constant MULTIPLIER = 1e18;

    constructor(address _stakingToken, address _rewardToken) {
        stakingToken = IERC20(_stakingToken);
        rewardToken = IERC20(_rewardToken);
    }

    function updateRewardIndex(uint reward) external {
        // Code
        rewardToken.transferFrom(msg.sender, address(this), reward);
        rewardIndex += (reward * MULTIPLIER) / totalSupply;
    }

    function _calculateRewards(address account) private view returns (uint) {
        // Code
        return (balanceOf[account] * (rewardIndex - rewardIndexOf[account])) / MULTIPLIER;
    }

    function calculateRewardsEarned(
        address account
    ) external view returns (uint) {
        // Code
        return _calculateRewards(account) + earned[account];
    }

    function _updateRewards(address account) private {
        // Code
        earned[account] += _calculateRewards(account);
        rewardIndexOf[account] = rewardIndex;
    }

    function stake(uint amount) external {
        // Code
        _updateRewards(msg.sender);
        stakingToken.transferFrom(msg.sender, address(this), amount);
        balanceOf[msg.sender] += amount;
        totalSupply += amount;
    }

    function unstake(uint amount) external {
        // Code
        _updateRewards(msg.sender);
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        stakingToken.transfer(msg.sender, amount);
    }

    function claim() external returns (uint) {
        // Code
        _updateRewards(msg.sender);
        uint _earned = earned[msg.sender];
        if (_earned > 0) {
            earned[msg.sender] = 0;
            rewardToken.transfer(msg.sender, _earned);    
        }
        return _earned;
    }
}