// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol"; 

contract FundMeTest is Test{
  FundMe fundMe;

  address USER = makeAddr("user");
  uint256 constant STARTING_BALANCE = 10 ether;
  uint256 constant SEND_VALUE = 0.1 ether;
  uint256 constant GAS_PRICE  = 1;

  function setUp() external {
    DeployFundMe deployFundMe = new DeployFundMe();
    fundMe = deployFundMe.run();
    vm.deal(USER, STARTING_BALANCE);
  }

  function testMinimumDolladIsFive() public {
    assertEq(fundMe.MINIMUM_USD(), 5e18);
  }

  function testOwnerIsMsgSender() public {
    assertEq(fundMe.i_owner(), msg.sender);
  }

  function testPriceFeedVersionIsAccurate() public {
    uint256 version = fundMe.getVersion();
    assertEq(version, 4);
  }

  function testFoundFailsWithoutEnoughETH() public {
    vm.expectRevert();
    fundMe.fund();
  }

  modifier funded() {
    vm.prank(USER);
    fundMe.fund{value: SEND_VALUE}();
    _;
  }

  function testFoundUpdatesFundedDataStructure() public funded {
    uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
    assertEq(amountFunded, SEND_VALUE);
  }

  function testAddsFunderToArrayOfFunders() public funded {
    address funder = fundMe.getFunder(0);
    assertEq(funder, USER);
  }

  function testOnlyOwnerCanWithdraw() public funded {
    vm.prank(USER);
    fundMe.fund{value: SEND_VALUE}();
    
    vm.expectRevert();
    vm.prank(USER);
    fundMe.withdraw();
  }

  function testWithdrawWithASingleFunder() public funded{
    // Arrange
    uint256 startingOwnerBalance = fundMe.getOwner().balance;
    uint256 startingFundMeBalance = address(fundMe).balance ;
    
    // Act
    vm.prank(fundMe.getOwner()); // c: 200
    fundMe.withdraw();

    // Assert
    uint256 endingOwnerBalance = fundMe.getOwner().balance;
    uint256 endingFundMeBalance = address(fundMe).balance;
    assertEq(startingOwnerBalance + startingFundMeBalance, endingOwnerBalance);
    assertEq(endingFundMeBalance, 0);
  }

  function testWithdrawFromMultipleFunders() public funded {
    // Arrange
    uint160 numberOfFunders = 10;
    uint160 startingFunderIndex = 1;

    for(uint160 i = startingFunderIndex; i < numberOfFunders; i++){
      // vm.prank new address
      // vm.deal new address
      // address()
      hoax(address(i),SEND_VALUE);
      fundMe.fund{value: SEND_VALUE}();
      // fund the fundMe
    }

    uint256 startingOwnerBalance = fundMe.getOwner().balance;
    uint256 startingFundMeBalance = address(fundMe).balance ;
    
    // Act
    vm.startPrank(fundMe.getOwner());
    fundMe.withdraw();
    vm.stopPrank();
    
    // Assert
    uint256 endingOwnerBalance = fundMe.getOwner().balance;
    uint256 endingFundMeBalance = address(fundMe).balance;
    assertEq(startingOwnerBalance + startingFundMeBalance, endingOwnerBalance);
    assertEq(endingFundMeBalance, 0);
  }
  function testWithdrawFromMultipleFundersCheaper() public funded {
    // Arrange
    uint160 numberOfFunders = 10;
    uint160 startingFunderIndex = 1;

    for(uint160 i = startingFunderIndex; i < numberOfFunders; i++){
      // vm.prank new address
      // vm.deal new address
      // address()
      hoax(address(i),SEND_VALUE);
      fundMe.fund{value: SEND_VALUE}();
      // fund the fundMe
    }

    uint256 startingOwnerBalance = fundMe.getOwner().balance;
    uint256 startingFundMeBalance = address(fundMe).balance ;
    
    // Act
    vm.startPrank(fundMe.getOwner());
    fundMe.cheaperWithdraw();
    vm.stopPrank();
    
    // Assert
    uint256 endingOwnerBalance = fundMe.getOwner().balance;
    uint256 endingFundMeBalance = address(fundMe).balance;
    assertEq(startingOwnerBalance + startingFundMeBalance, endingOwnerBalance);
    assertEq(endingFundMeBalance, 0);
  }

}
