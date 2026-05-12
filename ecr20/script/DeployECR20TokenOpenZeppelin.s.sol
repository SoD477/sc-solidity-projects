// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.19;

import {Script} from "forge-std/Script.sol";
import {ECR20TokenOpenZeppelin} from "src/ECR20TokenOpenZeppelin.sol";

contract DeployECR20TokenOpenZeppelin is Script {
    uint256 public constant INITIAL_SUPPLY = 1000 ether;

    function run() external {
        vm.startBroadcast();
        new ECR20TokenOpenZeppelin(INITIAL_SUPPLY);
        vm.stopBroadcast();
    }
}