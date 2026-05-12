// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

// Importing npm package
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    function getPrice() internal view returns (uint256) {
        // Address 0x694AA1769357215DE4FAC081bf1f309aDC325306
        // ABI
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        // Price of ETH in terms of USD
        (, int256 answer, , , ) = priceFeed.latestRoundData();
        uint8 feedDecimals = priceFeed.decimals();
        return uint256(answer) * (10 ** (18 - feedDecimals));
    }
    function getConversionRate(uint256 ethAmount) internal view returns (uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }
}