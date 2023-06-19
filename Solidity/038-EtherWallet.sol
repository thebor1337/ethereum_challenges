// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract EtherWallet {
    address payable public owner;

    constructor() {
        owner = payable(msg.sender);
    }
    
    function withdraw(uint _amount) external {
        require(owner == msg.sender, "not an owner");
        (bool ok, ) = msg.sender.call{value: _amount}("");
        require(ok, "failed");
    }
    
    receive() external payable {}
}