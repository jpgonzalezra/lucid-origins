// SPDX-License-Identifier: GNU GPLv3
pragma solidity >=0.8.21 <0.9.0;

import { PRBTest } from "@prb/test/PRBTest.sol";
import { console2 } from "forge-std/console2.sol";
import { StdCheats } from "forge-std/StdCheats.sol";

import { Blobby } from "../src/Blobby.sol";
import { Background } from "../src/layers/Background.sol";

/// @dev If this is your first time with Forge, read this tutorial in the Foundry Book:
/// https://book.getfoundry.sh/forge/writing-tests
contract BloobyTest is PRBTest, StdCheats {
    Blobby internal blooby;

    /// @dev A function invoked before each test case is run.
    function setUp() public virtual {
        // Instantiate the contract-under-test.
        blooby = new Blobby();
    }

    /// @dev Basic test. Run it with `forge test -vvv` to see the console log.
    function test_Example() external {
        // string memory alchemyApiKey = vm.envOr("API_KEY_ALCHEMY", string(""));
        // if (bytes(alchemyApiKey).length == 0) {
        //     return;
        // }

        // // Otherwise, run the test against the mainnet fork.
        // vm.createSelectFork({ urlOrAlias: "mainnet", blockNumber: 16_428_000 });
        console2.log(blooby.tokenURI(1));
        console2.log(blooby.tokenURI(2));
        console2.log(blooby.tokenURI(3));
        console2.log(blooby.tokenURI(4));
        console2.log(blooby.tokenURI(5));
    }
}
