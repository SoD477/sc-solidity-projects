// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {SimpleStorage} from "../src/SimpleStorage.sol";

contract DeploySimpleStorage is Script {
    function run() external returns (SimpleStorage) {
        vm.startBroadcast();

        SimpleStorage simpleStorage = new SimpleStorage();

        vm.stopBroadcast();
        return simpleStorage;
    }
}

// forge script script/DeploySimpleStorage.s.sol --rpc-url $RPC_URL --broadcast --account defualtKey --sender 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
