// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract ArrayReplaceLast {
    uint[] public arr = [1, 2, 3, 4];

    function remove(uint _index) external {
        // Write your code here
        uint[] storage _arr = arr;
        _arr[_index] = _arr[_arr.length - 1];
        _arr.pop();
    }
}