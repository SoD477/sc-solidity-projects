// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {BasicNft} from "src/BasicNft.sol";
// forge install ChainAccelOrg/foundry-devops
import {DevOpsTools} from "../lib/foundry-devops/src/DevOpsTools.sol";


contract MintBasicNft is Script {
    string public constant SHIBA = "ipfs://QmYer3fkXzsku7aPSSGz4PuQQURLBE9g1dquY8KAh1LYVD";

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "BasicNft", 
            block.chainid
        );
        minNftOnContract(mostRecentlyDeployed);
    }

    function minNftOnContract(address contractAddress) public {
        vm.startBroadcast();
        BasicNft(contractAddress).mintNft(SHIBA);
        vm.stopBroadcast();
    }
}