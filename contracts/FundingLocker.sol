// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.6.11;

import { IERC20, SafeERC20 } from "../modules/openzeppelin-contracts/contracts/token/ERC20/SafeERC20.sol";

import { IFundingLocker } from "./interfaces/IFundingLocker.sol";

/// @title FundingLocker holds custody of Liquidity Asset tokens during the funding period of a Loan.
contract FundingLocker is IFundingLocker {

    using SafeERC20 for IERC20;

    address public override immutable liquidityAsset;
    address public override immutable loan;

    constructor(address _liquidityAsset, address _loan) public {
        liquidityAsset = _liquidityAsset;
        loan           = _loan;
    }

    /**
        @dev Checks that `msg.sender` is the Loan.
    */
    modifier isLoan() {
        require(msg.sender == loan, "FL:NOT_L");
        _;
    }

    function pull(address dst, uint256 amt) isLoan external override {
        IERC20(liquidityAsset).safeTransfer(dst, amt);
    }

    function drain() isLoan external override {
        uint256 amt = IERC20(liquidityAsset).balanceOf(address(this));
        IERC20(liquidityAsset).safeTransfer(loan, amt);
    }

}
