// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract ArrayShift {
    uint[] public arr = [1, 2, 3];

    function remove(uint _index) external {
        // Write your code here
        uint[] storage _arr = arr;
        uint length = _arr.length;
        assert(_index < length - 1);
        for (uint i = _index; i < length - 1; i++) {
            _arr[i] = _arr[i + 1];
        }
        _arr.pop();
    }
}