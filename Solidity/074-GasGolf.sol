// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// gas golf
contract GasGolf {
    uint public total;

    function sumIfEvenAndLessThan99(uint[] calldata nums) external {
        uint _total;
        for (uint i = 0; i < nums.length; i++) {
            if (nums[i] < 99 && nums[i] % 2 == 0) {
                _total += nums[i];
            }
        }
        total = _total;
    }
}