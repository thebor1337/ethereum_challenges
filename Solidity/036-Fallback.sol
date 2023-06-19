// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Fallback {
    string[] public answers = ["", ""];

    fallback() external payable {
        answers[1] = "fallback";
    }

    receive() external payable {
        answers[0] = "receive";
    }
}