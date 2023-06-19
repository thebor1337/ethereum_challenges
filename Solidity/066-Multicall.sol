// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract MultiCall {
    function multiCall(
        address[] calldata targets,
        bytes[] calldata data
    ) external view returns (bytes[] memory) {
        require(targets.length == data.length, "mismatch length");
        bytes[] memory results = new bytes[](data.length);
        for (uint i = 0; i < targets.length; i++) {
            (bool ok, bytes memory result) = targets[i].staticcall(data[i]);
            require(ok, "failed");
            results[i] = result;
        }
        return results;
    }
}