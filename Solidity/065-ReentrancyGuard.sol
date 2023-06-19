// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract ReentrancyGuard {
    // Count stores number of times the function test was called
    uint public count;

    function test(address _contract) external {
        require(count == 0, "reentrant");
        count += 1;
        (bool success, ) = _contract.call("");
        require(success, "tx failed");
    }
}