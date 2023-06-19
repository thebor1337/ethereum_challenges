// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./IERC20.sol";

contract Vault {
    IERC20 public immutable token;
    
    uint public totalSupply;
    mapping(address => uint) public balanceOf;

    constructor(address _token) {
        token = IERC20(_token);
    }

    function _mint(address _to, uint _shares) private {
        // code here
        balanceOf[_to] += _shares;
        totalSupply += _shares;
    }

    function _burn(address _from, uint _shares) private {
        // code here
        balanceOf[_from] -= _shares;
        totalSupply -= _shares;
    }

    function deposit(uint _amount) external {
        // code here
        uint _totalSupply = totalSupply;
        
        uint shares;
        if (_totalSupply == 0) {
            shares = _amount;
        } else {
            shares = _amount * _totalSupply / token.balanceOf(address(this));
        }
        
        token.transferFrom(msg.sender, address(this), _amount);
        
        _mint(msg.sender, shares);
    }

    function withdraw(uint _shares) external {
        // code here
        uint amount = _shares * token.balanceOf(address(this)) / totalSupply;
        
        _burn(msg.sender, _shares);
        
        token.transfer(msg.sender, amount);
    }
}