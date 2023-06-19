// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./IERC721.sol";

contract ERC721 is IERC721 {
    event Transfer(address indexed from, address indexed to, uint indexed id);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint indexed id
    );
    event ApprovalForAll(
        address indexed owner,
        address indexed operator,
        bool approved
    );

    // Mapping from token ID to owner address
    mapping(uint => address) internal _ownerOf;

    // Mapping owner address to token count
    mapping(address => uint) internal _balanceOf;

    // Mapping from token ID to approved address
    mapping(uint => address) internal _approvals;

    // Mapping from owner to operator approvals
    mapping(address => mapping(address => bool)) public isApprovedForAll;

    function supportsInterface(
        bytes4 interfaceId
    ) external pure returns (bool) {
        return
            interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC165).interfaceId;
    }
    
    modifier exists(uint id) {
        require(_exists(id), "not exists");
        _;
    }
    
    function _exists(uint id) internal view returns(bool) {
        return _ownerOf[id] != address(0);
    }
    
    function _transfer(address from, address to, uint id) internal {
        delete _approvals[id];
        
        _ownerOf[id] = to;
        _balanceOf[from] -= 1;
        _balanceOf[to] += 1;
        
        emit Transfer(from, to, id);
    }
    
    function _transferFrom(
        address operator, 
        address from, 
        address to, 
        uint id
    ) internal {
        require(to != address(0), "zero address");
        address owner = _ownerOf[id];
        require(from == owner, "not owner");
        require(
            owner == operator || 
            _approvals[id] == operator || 
            isApprovedForAll[owner][operator], 
            "has no access"
        );
        
        _transfer(from, to, id);
    }
    
    function _safeTransferFrom(
        address operator, 
        address from, 
        address to, 
        uint id,
        bytes memory data
    ) internal {
        _transferFrom(operator, from, to, id);
        
        if (to.code.length > 0) {
            try IERC721Receiver(to).onERC721Received(operator, from, id, data) returns (bytes4 selector) {
                require(selector == IERC721Receiver.onERC721Received.selector, "not a ERC721 receiver");
            } catch {
                revert("failed safeTransferFrom()");
            }
        }
    }

    function ownerOf(uint id) external view exists(id) returns (address) {
        // code
        return _ownerOf[id];
    }

    function balanceOf(address owner) external view returns (uint) {
        // code
        require(owner != address(0), "zero address");
        return _balanceOf[owner];
    }

    function setApprovalForAll(address operator, bool approved) external {
        // code
        isApprovedForAll[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }

    function getApproved(uint id) external view exists(id) returns (address) {
        // code
        return _approvals[id];
    }

    function approve(address to, uint id) external exists(id) {
        // code
        address owner = _ownerOf[id];
        require(msg.sender == owner || isApprovedForAll[owner][msg.sender], "has no access");
        _approvals[id] = to;
        emit Approval(owner, to, id);
    }

    function transferFrom(address from, address to, uint id) public exists(id) {
        // code
        _transferFrom(msg.sender, from, to, id);
    }

    function safeTransferFrom(address from, address to, uint id) external {
        // code
        _safeTransferFrom(msg.sender, from, to, id, "");
    }

    function safeTransferFrom(
        address from,
        address to,
        uint id,
        bytes calldata data
    ) external {
        // code
        _safeTransferFrom(msg.sender, from, to, id, data);
    }

    function mint(address to, uint id) external {
        // code
        require(to != address(0), "zero address");
        require(!_exists(id), "already exists");
        _ownerOf[id] = to;
        _balanceOf[to] += 1;
        
        emit Transfer(address(0), to, id);
    }

    function burn(uint id) external exists(id) {
        // code
        address owner = _ownerOf[id];
        require(msg.sender == owner, "not owner");
        
        _balanceOf[owner] -= 1;
        delete _ownerOf[id];
        delete _approvals[id];
        
        emit Transfer(owner, address(0), id);
    }
}