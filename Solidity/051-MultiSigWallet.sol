// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract MultiSigWallet {
    event Deposit(address indexed sender, uint amount);
    event Submit(uint indexed txId);
    event Approve(address indexed owner, uint indexed txId);
    event Revoke(address indexed owner, uint indexed txId);
    event Execute(uint indexed txId);

    struct Transaction {
        address to;
        uint value;
        bytes data;
        bool executed;
    }

    address[] public owners;
    mapping(address => bool) public isOwner;
    uint public required;

    Transaction[] public transactions;
    // mapping from tx id => owner => bool
    mapping(uint => mapping(address => bool)) public approved;

    modifier onlyOwner() {
        require(isOwner[msg.sender], "not owner");
        _;
    }

    modifier txExists(uint _txId) {
        require(_txId < transactions.length, "tx does not exist");
        _;
    }

    modifier notApproved(uint _txId) {
        require(!approved[_txId][msg.sender], "tx already approved");
        _;
    }

    modifier notExecuted(uint _txId) {
        require(!transactions[_txId].executed, "tx already executed");
        _;
    }

    constructor(address[] memory _owners, uint _required) {
        require(_owners.length > 0, "owners required");
        require(
            _required > 0 && _required <= _owners.length,
            "invalid required number of owners"
        );

        for (uint i; i < _owners.length; i++) {
            address owner = _owners[i];

            require(owner != address(0), "invalid owner");
            require(!isOwner[owner], "owner is not unique");

            isOwner[owner] = true;
            owners.push(owner);
        }

        required = _required;
    }
    
    function submit(address _to, uint _value, bytes calldata _data) external onlyOwner {
        transactions.push(Transaction(_to, _value, _data, false));
        emit Submit(transactions.length - 1);
    }
    
    function approve(uint _txId) 
        external 
        onlyOwner 
        txExists(_txId) 
        notExecuted(_txId)
        notApproved(_txId)
    {
        approved[_txId][msg.sender] = true;
        emit Approve(msg.sender, _txId);
    }
    
    function execute(uint _txId)
        external
        onlyOwner
        txExists(_txId)
        notExecuted(_txId)
    {
        uint numVotes;
        uint numOwners = owners.length;
        for (uint i = 0; i < numOwners; i++) {
            if (approved[_txId][owners[i]]) {
                numVotes++;
            }
        }
        
        require(numVotes >= required, "not enough votes");
        
        Transaction storage tx = transactions[_txId];
        tx.executed = true;
        (bool success, ) = tx.to.call{value: tx.value}(tx.data);
        require(success, "tx failed");
        
        emit Execute(_txId);
    }
    
    function revoke(uint _txId) 
        external
        onlyOwner
        txExists(_txId)
        notExecuted(_txId)
    {
        require(approved[_txId][msg.sender], "not approved");
        approved[_txId][msg.sender] = false;
        
        emit Revoke(msg.sender, _txId);
    }
    
    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }
}