// Have our invariant aka propeties

// 1. What are our invariants?

// The total supply of DSC should be less than the total value of collateral

// Getter view functions should never revert <- evergreen invariant

// GOOD TO HAVE Continue On Revert folder and Fail On Revert Folder!!!!!!!

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {StdInvariant} from "forge-std/StdInvariant.sol";
import {DecentralizedStableCoin} from "src/DecentralizedStableCoin.sol";
import {DSCEngine} from "src/DSCEngine.sol";
import {HelperConfig} from "script/HelperConfig.s.sol";
import {DeployDSC} from "script/DeployDSC.s.sol";
import {ERC20Mock} from "test/mocks/ERC20Mock.sol";
import {IERC20} from "@openzeppelin/contracts/interfaces/IERC20.sol";
import {Handler} from "test/fuzz/Handler.t.sol";

contract InvariantsTest is StdInvariant, Test {
    DeployDSC deployer;
    DecentralizedStableCoin dsc;
    DSCEngine dsce;
    Handler handler;

    HelperConfig config;
    address wethUsdPriceFeed;
    address wbtcUsdPriceFeed;
    address weth;
    address wbtc;

    function setUp() external {
        deployer = new DeployDSC();
        (dsc, dsce, config) = deployer.run();
        (wethUsdPriceFeed, wbtcUsdPriceFeed, weth, wbtc,) = config.activeNetworkConfig();

        // targetContract(address(dsce));
        handler = new Handler(dsce, dsc);
        targetContract(address(handler));
        // Don't call redeemColalteral unless there is collateral to redeem
    }

    function invariant_protocolMustHaveMorevalueThanTotalSupply() public view {
        // Get the value of all the collateral in the protocol
        // Compare it to all debt (dsc)
        uint256 totalSupply = dsc.totalSupply();
        uint256 totalWethDposited = IERC20(weth).balanceOf(address(dsce));
        uint256 totalWbtcDposited = IERC20(wbtc).balanceOf(address(dsce));

        uint256 wethValue = dsce.getUsdValue(weth, totalWethDposited);
        uint256 wbtcValue = dsce.getUsdValue(wbtc, totalWbtcDposited);

        console.log("weth value: ", wethValue);
        console.log("wbtc value: ", wbtcValue);
        console.log("total supply: ", totalSupply);
        console.log("Times mint called: ", handler.timesMintIsCalled());

        assert(wethValue + wbtcValue >= totalSupply);
    }

    // should alweys be included
    // A failure in a basic getter function
    // often signals an underlying invalid or unexpected system state reached during the fuzzing process.
    //
    // forge inspect DSCEngine methods
    function invariant_gettersShouldNotRevert() public view {
        dsce.getLiquidationBonus();
        dsce.getPrecision();
        // and so on ...
    }
}
