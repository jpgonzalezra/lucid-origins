// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.23;

import { LucidOrigins } from "../src/LucidOrigins.sol";
import { BaseScript } from "./Base.s.sol";

/// @dev See the Solidity Scripting tutorial: https://book.getfoundry.sh/tutorials/solidity-scripting
contract LucidOriginsDeploy is BaseScript {
    function run() public broadcast returns (LucidOrigins lucidOrigins) {
        lucidOrigins = new LucidOrigins();
    }
}
