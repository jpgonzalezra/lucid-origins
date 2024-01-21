// SPDX-License-Identifier: GNU GPLv3
pragma solidity 0.8.21;

contract Blush {
    function blush() internal pure returns (string memory) {
        return string(
            abi.encodePacked(
                '<circle id="circle-blush" r="6" fill="rgba(255,255,255,0.4)" />',
                '<animateMotion href="#circle-blush" dur="30s" begin="0s" ',
                'fill="freeze" repeatCount="indefinite" rotate="auto-reverse" ',
                '><mpath href="#head-stroke" /></animateMotion>'
            )
        );
    }
}
