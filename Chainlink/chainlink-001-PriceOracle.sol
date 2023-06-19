// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./AggregatorV3Interface.sol";

contract PriceOracle {
    AggregatorV3Interface constant oracle = AggregatorV3Interface(0xF4030086522a5bEEa4988F8cA5B36dbC97BeE88c);
    
    function getPrice() public view returns (int) {
        // Code
        (, int256 answer, , uint256 updatedAt, ) = oracle.latestRoundData();
        require(block.timestamp - updatedAt <= 3 hours, "invalid timeframe");
        return answer * 10;
    }
}