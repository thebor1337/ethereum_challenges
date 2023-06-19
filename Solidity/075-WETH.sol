// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./ERC20.sol";

contract WETH is ERC20 {
    event Deposit(address indexed account, uint amount);
    event Withdraw(address indexed account, uint amount);

    constructor() ERC20("Wrapped Ether", "WETH", 18) {}

    function deposit() public payable {
        _mint(msg.sender, msg.value);
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint _amount) external {
        _burn(msg.sender, _amount);
        (bool ok, ) = msg.sender.call{value: _amount}("");
        require(ok, "failed transfer");
        emit Withdraw(msg.sender, _amount);
    }
    
    receive() external payable {
        deposit();
    }
}