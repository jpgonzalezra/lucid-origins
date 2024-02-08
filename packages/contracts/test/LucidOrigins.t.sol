// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.23;

import { PRBTest } from "@prb/test/PRBTest.sol";
// import { console2 } from "forge-std/console2.sol";
import { StdCheats } from "forge-std/StdCheats.sol";

import { LucidOrigins } from "../src/LucidOrigins.sol";

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
}

contract LucidOriginsTest is PRBTest, StdCheats {
    LucidOrigins internal lucidOrigins;

    /// @dev A function invoked before each test case is run.
    function setUp() public virtual {
        // Instantiate the contract-under-test.
        lucidOrigins = new LucidOrigins();
    }

    /// @dev Basic test. Run it with `forge test -vvv` to see the console log.
    function test_tokenUri() external view {
        for (uint256 i = 0; i < 4844; i++) {
            lucidOrigins.tokenURI(i);
        }
    }
}
