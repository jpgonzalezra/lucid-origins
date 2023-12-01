// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.21 <0.9.0;

import { Blooby } from "../src/Blooby.sol";

import { BaseScript } from "./Base.s.sol";

/// @dev See the Solidity Scripting tutorial: https://book.getfoundry.sh/tutorials/solidity-scripting
contract CreateBlooby is BaseScript {
    function tokenURI(address bloobyAddr, uint256 index) public view returns (string memory tokenUri) {
        Blooby blooby = Blooby(bloobyAddr);
        tokenUri = blooby.tokenURI(index);
    }
}
