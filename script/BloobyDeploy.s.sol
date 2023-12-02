// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.21 <0.9.0;

import { Blooby } from "../src/Blooby.sol";
import { Background } from "../src/layers/Background.sol";

import { BaseScript } from "./Base.s.sol";

/// @dev See the Solidity Scripting tutorial: https://book.getfoundry.sh/tutorials/solidity-scripting
contract BloobyDeploy is BaseScript {
    function run() public broadcast returns (Blooby blooby) {
        Background backgraound = new Background();
        uint16[] memory itemIds = new uint16[](1);
        itemIds[0] = 0;
        address[] memory itemAddresses = new address[](1);
        itemAddresses[0] = address(backgraound);
        blooby = new Blooby(itemIds, itemAddresses);
    }
}
