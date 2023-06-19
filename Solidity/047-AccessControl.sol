// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract AccessControl {
    event GrantRole(bytes32 indexed role, address indexed account);
    event RevokeRole(bytes32 indexed role, address indexed account);

    mapping(bytes32 => mapping(address => bool)) public roles;

    bytes32 public constant ADMIN = keccak256(abi.encodePacked("ADMIN"));
    bytes32 public constant USER = keccak256(abi.encodePacked("USER"));

    constructor() {
        _grantRole(ADMIN, msg.sender);
    }

    function _grantRole(bytes32 _role, address _account) internal {
        // Write code here
        roles[_role][_account] = true;
        emit GrantRole(_role, _account);
    }

    function grantRole(bytes32 _role, address _account) external onlyRole(ADMIN, msg.sender) {
        // Write code here
        _grantRole(_role, _account);
    }

    function revokeRole(bytes32 _role, address _account) external onlyRole(ADMIN, msg.sender) {
        // Write code here
        roles[_role][_account] = false;
        emit RevokeRole(_role, _account);
    }
    
    modifier onlyRole(bytes32 _role, address _account) {
        require(roles[_role][_account], "don't have the role");
        _;
    }
}