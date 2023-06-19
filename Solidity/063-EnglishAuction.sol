// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IERC721 {
    function transferFrom(address from, address to, uint nftId) external;
}

contract EnglishAuction {
    event Start();
    event Bid(address indexed sender, uint amount);
    event Withdraw(address indexed bidder, uint amount);
    event End(address winner, uint amount);

    IERC721 public immutable nft;
    uint public immutable nftId;

    address payable public immutable seller;
    uint public endAt;
    bool public started;
    bool public ended;

    address public highestBidder;
    uint public highestBid;
    // mapping from bidder to amount of ETH the bidder can withdraw
    mapping(address => uint) public bids;

    constructor(address _nft, uint _nftId, uint _startingBid) {
        nft = IERC721(_nft);
        nftId = _nftId;

        seller = payable(msg.sender);
        highestBid = _startingBid;
    }

    function start() external {
        // Write your code here
        require(msg.sender == seller, "not seller");
        require(!started, "already started");
        started = true;
        nft.transferFrom(msg.sender, address(this), nftId);
        endAt = block.timestamp + 7 days;
        emit Start();
        
    }

    function bid() external payable {
        // Write your code here
        require(started, "not started");
        require(msg.value > highestBid, "not enough funds");
        bids[highestBidder] += highestBid;
        highestBidder = msg.sender;
        highestBid = msg.value;
        emit Bid(msg.sender, msg.value);
    }

    function withdraw() external {
        // Write your code here
        uint amount = bids[msg.sender];
        require(amount > 0, "nothing to withdraw");
        bids[msg.sender] = 0;
        (bool ok, ) = msg.sender.call{value: amount}("");
        require(ok, "failed withdraw");
        emit Withdraw(msg.sender, amount);
    }

    function end() external {
        // Write your code here
        require(started, "not started");
        require(!ended, "already ended");
        require(block.timestamp >= endAt, "not ended yet");
        ended = true;
        (bool ok, ) = seller.call{value: highestBid}("");
        require(ok, "failed transfer");
        nft.transferFrom(address(this), highestBidder, nftId);
        emit End(highestBidder, highestBid);
    }
}