// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.6.11;

import { DSTest } from "../../modules/ds-test/src/test.sol";
import { ERC20 }  from "../../modules/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

import { IFundingLocker } from "../interfaces/IFundingLocker.sol";

import { FundingLockerFactory } from "../FundingLockerFactory.sol";

import { Loan } from "./accounts/Loan.sol";

contract MockToken is ERC20 {

    constructor (string memory name, string memory symbol) ERC20(name, symbol) public {}

    function mint(address account, uint256 amount) external {
        _mint(account, amount);
    }

}

contract FundingLockerFactoryTest is DSTest {

    function test_newLocker() external {
        FundingLockerFactory factory = new FundingLockerFactory();
        MockToken            token   = new MockToken("TKN", "TKN");
        Loan                 loan    = new Loan();
        Loan                 notLoan = new Loan();

        IFundingLocker locker = IFundingLocker(loan.fundingLockerFactory_newLocker(address(factory), address(token)));

        // Validate the storage of factory.
        assertEq(factory.owner(address(locker)), address(loan), "Invalid owner");
        assertTrue(factory.isLocker(address(locker)),           "Invalid isLocker");

        // Validate the storage of locker.
        assertEq(locker.loan(),                    address(loan),  "Incorrect loan address");
        assertEq(address(locker.liquidityAsset()), address(token), "Incorrect address of liquidity asset");

        // Assert that only the FundingLocker owner can access funds
        token.mint(address(locker), 10);
        assertTrue(!notLoan.try_fundingLocker_pull(address(locker), address(loan), 1), "Pull succeeded from notLoan");
        assertTrue(    loan.try_fundingLocker_pull(address(locker), address(loan), 1), "Pull failed from loan");
        assertTrue(!notLoan.try_fundingLocker_drain(address(locker)),                  "Drain succeeded from notLoan");
        assertTrue(    loan.try_fundingLocker_drain(address(locker)),                  "Drain failed from loan");
    }

}
