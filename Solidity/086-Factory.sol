// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Factory {
    event Log(address addr);

    function deploy() external {
        // Code
        bytes memory bytecode = hex"600a8060093d393df3602a60005260206000f3";
        address addr;
        assembly {
            addr := create(0, add(bytecode, 0x20), mload(bytecode))
            if iszero(addr) {
                revert(0,0)
            }
        }
        
        emit Log(addr);
    }
}