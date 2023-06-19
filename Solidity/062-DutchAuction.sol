// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IERC721 {
    function transferFrom(address _from, address _to, uint _nftId) external;
}

contract DutchAuction {
    uint private constant DURATION = 7 days;

    IERC721 public immutable nft;
    uint public immutable nftId;

    address payable public immutable seller;
    uint public immutable startingPrice;
    uint public immutable startAt;
    uint public immutable expiresAt;
    uint public immutable discountRate;

    constructor(
        uint _startingPrice,
        uint _discountRate,
        address _nft,
        uint _nftId
    ) {
        seller = payable(msg.sender);
        startingPrice = _startingPrice;
        startAt = block.timestamp;
        expiresAt = block.timestamp + DURATION;
        discountRate = _discountRate;

        require(
            _startingPrice >= _discountRate * DURATION,
            "starting price < min"
        );

        nft = IERC721(_nft);
        nftId = _nftId;
    }

    function getPrice() public view returns (uint) {
        // Code here
        return startingPrice - (block.timestamp - startAt) * discountRate;
    }

    function buy() external payable {
        // Code here
        require(block.timestamp < expiresAt, "expired");
        uint price = getPrice();
        require(msg.value >= price, "not enough funds");
        nft.transferFrom(seller, msg.sender, nftId);
        if (msg.value > price) {
            (bool ok, ) = msg.sender.call{value: msg.value - price}("");
            require(ok, "return failed");
        }
        selfdestruct(seller);
    }
}