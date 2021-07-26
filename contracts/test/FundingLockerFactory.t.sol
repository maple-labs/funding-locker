// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.6.11;
pragma experimental ABIEncoderV2;

import { DSTest } from "../../lib/ds-test/contracts/test.sol";
import { ERC20 }  from "../../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

import { IFundingLocker }       from "../interfaces/IFundingLocker.sol";
import { FundingLockerFactory } from "../FundingLockerFactory.sol";
import { FundingLockerOwner }   from "./accounts/FundingLockerOwner.sol";

contract MintableToken is ERC20 {

    constructor (string memory name, string memory symbol) ERC20(name, symbol) public {}

    function mint(address account, uint256 amount) public {
        _mint(account, amount);
    }

}

contract FundingLockerFactoryTest is DSTest {

    function test_newLocker() public {
        FundingLockerFactory  factory = new FundingLockerFactory();
        MintableToken  liquidityAsset = new MintableToken("TKN", "TKN");
        FundingLockerOwner      owner = new FundingLockerOwner();
        FundingLockerOwner   nonOwner = new FundingLockerOwner();

        IFundingLocker locker = IFundingLocker(owner.fundingLockerFactory_newLocker(address(factory), address(liquidityAsset)));

        // Validate the storage of factory.
        assertEq(factory.owner(address(locker)), address(owner), "Invalid owner");
        assertTrue(factory.isLocker(address(locker)),            "Invalid isLocker");

        // Validate the storage of locker.
        assertEq(locker.loan(), address(owner),                             "Incorrect loan address");
        assertEq(address(locker.liquidityAsset()), address(liquidityAsset), "Incorrect address of liquidity asset");

        // Assert that only the FundingLocker owner can access funds
        liquidityAsset.mint(address(locker), 1);
        assertTrue(!nonOwner.try_fundingLocker_pull(address(locker), address(owner), 1), "Pull succeeded from nonOwner");
        assertTrue(    owner.try_fundingLocker_pull(address(locker), address(owner), 1), "Pull failed from owner");

        // Assert that only the FundingLocker owner can drain funds
        liquidityAsset.mint(address(locker), 100);
        assertTrue(!nonOwner.try_fundingLocker_drain(address(locker)), "Drain succeeded from nonOwner");
        assertTrue(    owner.try_fundingLocker_drain(address(locker)), "Drain failed from owner");
    }

}
