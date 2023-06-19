// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./IERC20.sol";

contract ERC20 is IERC20 {
    uint public totalSupply = 1000;
    mapping(address => uint) public balanceOf;
    mapping(address => mapping(address => uint)) public allowance;
    string public name = "TestToken";
    string public symbol = "TEST";
    uint8 public decimals = 18;

    constructor() {
        balanceOf[msg.sender] = totalSupply;
    }

    function _transfer(address from, address to, uint amount) internal {
        uint balance = balanceOf[from];
        require(amount <= balance, "not enough balance");
        unchecked {
            balanceOf[from] = balance - amount;
        }
        balanceOf[to] += amount;
        emit Transfer(from, to, amount);
    }
    
    function _approve(address owner, address spender, uint amount) internal {
        allowance[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function transfer(address recipient, uint amount) external returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function approve(address spender, uint amount) external returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external returns (bool) {
        uint approved = allowance[sender][msg.sender];
        require(approved >= amount, "not enough approved");
        
        _transfer(sender, recipient, amount);
        
        uint newApproved;
        unchecked {
            newApproved = approved - amount;    
        }
        
        _approve(sender, msg.sender, newApproved);
        return true;
    }

    function mint(uint amount) external {
        balanceOf[msg.sender] += amount;
        totalSupply += amount;
        emit Transfer(address(0), msg.sender, amount);
    }

    function burn(uint amount) external {
        uint balance = balanceOf[msg.sender];
        require(amount <= balance, "not enough balance");
        unchecked {
            balanceOf[msg.sender] = balance - amount;    
        }
        totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }
}