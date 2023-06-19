// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

library StorageSlot {
    // Code here
    struct AddressSlot {
        address value;
    }
    
    function getAddressSlot(bytes32 slot) internal pure returns(AddressSlot storage pointer) {
        assembly {
            pointer.slot := slot
        }
    }
}

contract TestSlot {
    bytes32 public constant TEST_SLOT = keccak256("TEST_SLOT");

    function write(address _addr) external {
        // Code here
        StorageSlot.AddressSlot storage pointer = StorageSlot.getAddressSlot(TEST_SLOT);
        pointer.value = _addr;
    }

    function get() external view returns (address) {
        // Code here
        return StorageSlot.getAddressSlot(TEST_SLOT).value;
    }
}