// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./IERC20.sol";

contract CSAMM {
    IERC20 public immutable token0;
    IERC20 public immutable token1;

    uint public reserve0;
    uint public reserve1;

    uint public totalSupply;
    mapping(address => uint) public balanceOf;

    constructor(address _token0, address _token1) {
        // NOTE: This contract assumes that token0 and token1
        // both have same decimals
        token0 = IERC20(_token0);
        token1 = IERC20(_token1);
    }

    function _mint(address _to, uint _amount) private {
        // Write code here
        balanceOf[_to] = _amount;
        totalSupply += _amount;
    }

    function _burn(address _from, uint _amount) private {
        // Write code here
        balanceOf[_from] -= _amount;
        totalSupply -= _amount;
    }

    function swap(
        address _tokenIn,
        uint _amountIn
    ) external returns (uint amountOut) {
        // Write code here
        IERC20 tokenIn;
        IERC20 tokenOut;
        
        uint _amountOut = _amountIn * 997 / 1000;
        
        if (_tokenIn == address(token0)) {
            tokenIn = token0;
            tokenOut = token1;
            reserve0 += _amountIn;
            reserve1 -= _amountOut;
        } else if (_tokenIn == address(token1)) {
            tokenIn = token1;
            tokenOut = token0;
            reserve1 += _amountIn;
            reserve0 -= _amountOut;
        } else {
            revert("token not found");
        }
        
        tokenIn.transferFrom(msg.sender, address(this), _amountIn);
        tokenOut.transfer(msg.sender, _amountOut);
    }

    function addLiquidity(
        uint _amount0,
        uint _amount1
    ) external returns (uint shares) {
        // Write code here
        uint _totalSupply = totalSupply;
        
        if (_totalSupply == 0) {
            shares = _amount0 + _amount1;
        } else {
            shares = (_amount0 + _amount1) * totalSupply / (reserve0 + reserve1);
        }
        
        require(shares > 0, "zero shares");
        
        token0.transferFrom(msg.sender, address(this), _amount0);
        token1.transferFrom(msg.sender, address(this), _amount1);
        
        reserve0 += _amount0;
        reserve1 += _amount1;
        
        _mint(msg.sender, shares);
    }

    function removeLiquidity(uint _shares) external returns (uint d0, uint d1) {
        // Write code here
        uint _totalSupply = totalSupply;
        
        d0 = _shares * reserve0 / _totalSupply;
        d1 = _shares * reserve1 / _totalSupply;
        
        reserve0 -= d0;
        reserve1 -= d1;
        
        _burn(msg.sender, _shares);
        
        token0.transfer(msg.sender, d0);
        token1.transfer(msg.sender, d1);
    }
}