// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract FallbackInputOutput {
    address immutable target;

    constructor(address _target) {
        target = _target;
    }

    // Code here
    fallback(bytes calldata data) external payable returns(bytes memory) {
        (bool ok, bytes memory result) = target.call{value: msg.value}(data);
        require(ok, "failed tx");
        return result;
    }
}