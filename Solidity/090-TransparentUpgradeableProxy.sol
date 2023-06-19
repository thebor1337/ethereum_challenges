// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./StorageSlot.sol";

contract TransparentUpgradeableProxy {
    using StorageSlot for bytes32;
    
    // Code here
    bytes32 private constant IMPLEMENTATION_SLOT = bytes32(uint(keccak256("eip1967.proxy.implementation")) - 1);
    bytes32 private constant ADMIN_SLOT = bytes32(uint(keccak256("eip1967.proxy.admin")) - 1);

    constructor() {
        _setAdmin(msg.sender);
    }

    modifier ifAdmin() {
        // Code here
        if (msg.sender == _getAdmin()) {
            _;    
        } else {
            _delegate(_getImplementation());
        }
    }
    
    function _getAdmin() private view returns(address) {
        return ADMIN_SLOT.getAddressSlot().value;
    }
    
    function _setAdmin(address _admin) private {
        require(_admin != address(0), "zero address");
        ADMIN_SLOT.getAddressSlot().value = _admin;
    }
    
    function _getImplementation() private view returns(address) {
        return IMPLEMENTATION_SLOT.getAddressSlot().value;
    }
    
    function _setImplementation(address _implementation) private {
        IMPLEMENTATION_SLOT.getAddressSlot().value = _implementation;
    }
    
    function _delegate(address _implementation) internal returns(bytes memory) {
        (bool ok, bytes memory result) = _implementation.delegatecall(msg.data);
        require(ok, "failed tx");
        return result;
    }
    
    function changeAdmin(address _admin) external ifAdmin {
        _setAdmin(_admin);
    }
    
    function upgradeTo(address _implementation) external ifAdmin {
        require(_implementation.code.length > 0, "zero code");
        _setImplementation(_implementation);
    }
    
    function admin() external ifAdmin returns(address) {
        return _getAdmin();
    }
    
    function implementation() external ifAdmin returns(address) {
        return _getImplementation();
    }
    
    fallback(bytes calldata data) external payable returns(bytes memory) {
        return _delegate(_getImplementation());
    }
    
    receive() external payable {
        _delegate(_getImplementation());
    }
}