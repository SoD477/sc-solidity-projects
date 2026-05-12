// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {BasicNft} from "src/BasicNft.sol";
import {DeployBasicNft} from "script/DeployBasicNft.s.sol";

contract TestBasicNft is Test{
    string public constant SHIBA = "ipfs://QmYer3fkXzsku7aPSSGz4PuQQURLBE9g1dquY8KAh1LYVD";

    address public USER = makeAddr("user");
    BasicNft public basicNft;
    DeployBasicNft public deployer;

    function setUp() public {
        deployer = new DeployBasicNft();
        basicNft = deployer.run();
    }

    function testNameIsCorrect() public view {
        string memory expectedName = "Dogie";
        string memory actualName = basicNft.name();

        bytes32 hashedExpectedName = keccak256(abi.encodePacked(expectedName));
        bytes32 hashedActualName = keccak256(abi.encodePacked(actualName));
        
        assert(hashedExpectedName == hashedActualName);
    }

    function testCanMintAndHaveABalance() public {
        vm.prank(USER);
        basicNft.mintNft(SHIBA);

        assert(basicNft.balanceOf(USER) == 1);
        assert(keccak256(abi.encodePacked(SHIBA)) == keccak256(abi.encodePacked(basicNft.tokenURI(0))));
    }
}