// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract MostSignificantBit {
    function findMostSignificantBit(uint x) external pure returns (uint8 r) {
        // Code
        uint8 i = 128;
        while (i > 0) {
            if (x >= 2 ** i) {
                x = x >> i;
                r += i;
            }
            i /= 2;
        }
    }
}