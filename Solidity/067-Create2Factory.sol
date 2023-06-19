// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./DeployWithCreate2.sol";

contract Create2Factory {
    event Deploy(address addr);

    function deploy(uint _salt) external {
        // Write your code here
        DeployWithCreate2 instance = new DeployWithCreate2{salt: bytes32(_salt)}(msg.sender);
        // emit Deploy(address(instance));
        emit Deploy(computeAddress(msg.sender, _salt));
    }
    
    function computeAddress(address _owner, uint _salt) private view returns(address) {
        bytes memory bytecode = abi.encodePacked(
            type(DeployWithCreate2).creationCode,
            abi.encode(_owner)
        );
        
        bytes32 hash = keccak256(
            abi.encodePacked(bytes1(0xff), address(this), _salt, keccak256(bytecode))
        );
        
        return address(uint160(uint(hash)));
    }
}