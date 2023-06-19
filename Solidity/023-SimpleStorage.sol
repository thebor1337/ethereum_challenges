// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract SimpleStorage {
    // Write your code here
    string public text;
    
    function set(string calldata _text) external {
        text = _text;
    }
    
    function get() external view returns(string memory) {
        return text;
    }
}