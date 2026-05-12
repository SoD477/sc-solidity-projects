// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {PriceConverter} from "./PriceConverter.sol";

error NotOwner();

contract FoundMe {
    using PriceConverter for uint256;

    uint256 public constant MIN_USD = 5e18;
    
    address[] public funders;
    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;
    
    address public immutable i_owner;

    constructor(){
        i_owner = msg.sender;
    }

    function fund() public payable {
        // Allow users to send $
        // Have a minimum $ sent 5$
        require(msg.value.getConversionRate() >= MIN_USD, "Didn't sent enough ETH"); // 1e18 = 1 ETH = 1 * 10 ** 18 Wei
        // What is a revert?
        // Undo any action that have been done, and sent the remaining gas back
        // require(msg.value >= 1e18, "Didn't sent enough ETH"); if this check fails functio reverts

        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner {
        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);

        // transfer
        // payable(msg.sender).transfer(address(this).balance);

        // send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Failed to send");
        
        //call recommended way
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Failed to call");
    }

    modifier onlyOwner(){
        // require(msg.sender == i_owner, "Sender is not owner");
        if(msg.sender != i_owner) { revert NotOwner(); } // more Gas efficient
        _; // if this was aboce require the code of function that has this modifier would execute first
    }

    // What happenns if someone saned this contract ETH without calling fund function
    // Explainer from: https://solidity-by-example.org/fallback/
    // Ether is sent to contract
    //      is msg.data empty?
    //          /   \
    //         yes  no
    //         /     \
    //    receive()?  fallback()
    //     /   \
    //   yes   no
    //  /        \
    //receive()  fallback()

    fallback() external payable { 
        fund();
    }
    
    receive() external payable {
        fund();
    }
}