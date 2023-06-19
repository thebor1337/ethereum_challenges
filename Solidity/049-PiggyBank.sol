// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract PiggyBank {
    event Deposit(uint amount);
    event Withdraw(uint amount);
    address public owner;
    
    constructor() {
        owner = msg.sender;
    }
    
    function withdraw() external {
        require(msg.sender == owner, "not an owner");
        emit Withdraw(address(this).balance);
        selfdestruct(payable(msg.sender));
    }
    
    receive() external payable {
        emit Deposit(msg.value);
    }
}