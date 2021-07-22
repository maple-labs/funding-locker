pragma solidity ^0.6.7;

import "ds-test/test.sol";

import "./FundingLocker.sol";

contract FundingLockerTest is DSTest {
    FundingLocker locker;

    function setUp() public {
        locker = new FundingLocker();
    }

    function testFail_basic_sanity() public {
        assertTrue(false);
    }

    function test_basic_sanity() public {
        assertTrue(true);
    }
}
