// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.21 <0.9.0;

import { LucidBlob } from "../src/LucidBlob.sol";
import { Background } from "../src/layers/Background.sol";
import { BaseScript } from "./Base.s.sol";

/// @dev See the Solidity Scripting tutorial: https://book.getfoundry.sh/tutorials/solidity-scripting
contract LucidBlobDeploy is BaseScript {
    function run() public broadcast returns (LucidBlob lucidBlob) {
        lucidBlob = new LucidBlob();
    }
}
