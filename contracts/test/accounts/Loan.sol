// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.6.11;

import { IFundingLocker }        from "../../interfaces/IFundingLocker.sol";
import { IFundingLockerFactory } from "../../interfaces/IFundingLockerFactory.sol";

contract Loan {

    /************************/
    /*** Direct Functions ***/
    /************************/

    function fundingLockerFactory_newLocker(address factory, address token) external returns (address) {
        return IFundingLockerFactory(factory).newLocker(token);
    }

    function fundingLocker_pull(address locker, address destination, uint256 amount) external {
        IFundingLocker(locker).pull(destination, amount);
    }

    function fundingLocker_drain(address locker) external {
        IFundingLocker(locker).drain();
    }

    /*********************/
    /*** Try Functions ***/
    /*********************/

    function try_fundingLockerFactory_newLocker(address factory, address token) external returns (bool ok) {
        (ok,) = factory.call(abi.encodeWithSelector(IFundingLockerFactory.newLocker.selector, token));
    }

    function try_fundingLocker_pull(address locker, address destination, uint256 amount) external returns (bool ok) {
        (ok,) = locker.call(abi.encodeWithSelector(IFundingLocker.pull.selector, destination, amount));
    }

    function try_fundingLocker_drain(address locker) external returns (bool ok) {
        (ok,) = locker.call(abi.encodeWithSelector(IFundingLocker.drain.selector));
    }

}
