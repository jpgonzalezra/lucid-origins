// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.21 <0.9.0;

import { PRBTest } from "@prb/test/PRBTest.sol";
import { console2 } from "forge-std/console2.sol";
import { StdCheats } from "forge-std/StdCheats.sol";

import { Blooby } from "../src/Blooby.sol";
import { Background } from "../src/layers/Background.sol";


/// @dev If this is your first time with Forge, read this tutorial in the Foundry Book:
/// https://book.getfoundry.sh/forge/writing-tests
contract BloobyTest is PRBTest, StdCheats {
    Blooby internal blooby;

    /// @dev A function invoked before each test case is run.
    function setUp() public virtual {
        // Instantiate the contract-under-test.
        Background backgraound = new Background();
        uint16[] memory itemIds = new uint16[](1);
        itemIds[0] = 0;
        address[] memory itemAddresses = new address[](1);
        itemAddresses[0] = address(backgraound);
        blooby = new Blooby(itemIds, itemAddresses);
    }

    /// @dev Basic test. Run it with `forge test -vvv` to see the console log.
    function test_Example() external {
        console2.log(blooby.tokenURI(1));
    }
}
