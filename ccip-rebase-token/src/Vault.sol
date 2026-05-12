// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {IRebaseToken} from "src/interfaces/IRebaseToken.sol";

/**
 * @title Vault
 * @author SoD
 * @notice Vault accepts deposits and mints a RebaseToken to the depositor;
 */
contract Vault {
    /* ERRORS */
    error Vault__RedeemFailed();

    /* STATE VARIABLES */
    IRebaseToken private immutable i_rebaseToken;

    /* EVENTS */
    event Deposit(address indexed user, uint256 amount);
    event Redeem(address indexed user, uint256 amount);

    /* FUNCTIONS */
    constructor(IRebaseToken _rebaseToken) {
        i_rebaseToken = _rebaseToken;
    }

    receive() external payable {}

    function deposit() external payable {
        uint256 interestRate = i_rebaseToken.getInterestRate();
        i_rebaseToken.mint(msg.sender, msg.value, interestRate);
        emit Deposit(msg.sender, msg.value);
    }

    function redeem(uint256 _amount) external {
        if (_amount == type(uint256).max) {
            _amount = i_rebaseToken.balanceOf(msg.sender);
        }
        i_rebaseToken.burn(msg.sender, _amount);
        (bool success,) = payable(msg.sender).call{value: _amount}("");
        if (!success) {
            revert Vault__RedeemFailed();
        }
        emit Redeem(msg.sender, _amount);
    }

    /* GETTERS */
    function getRebaseToken() external view returns (address) {
        return address(i_rebaseToken);
    }
}
