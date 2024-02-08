// SPDX-License-Identifier: GNU GPLv3
pragma solidity 0.8.23;

import { LibString } from "solmate/utils/LibString.sol";

contract Blush {
    using LibString for uint256;

    function blush(uint256 layerId) internal pure returns (string memory) {
        return string.concat(
            '<circle id="circle-blush" r="6" fill="rgba(255,255,255,0.4)" />',
            '<animateMotion href="#circle-blush" dur="30s" begin="0s" ',
            'fill="freeze" repeatCount="indefinite" rotate="auto-reverse" ',
            '><mpath href="#',
            layerId.toString(),
            '" /></animateMotion>'
        );
    }
}
