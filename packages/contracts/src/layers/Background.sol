// SPDX-License-Identifier: GNU GPLv3
pragma solidity 0.8.21;

import { console2 } from "forge-std/console2.sol";
import { String } from "../utils/String.sol";

contract Background {
    int256 constant ONE = int256(0x100000000);
    uint256 constant USIZE = 100;
    int256 constant SIZE = int256(USIZE);
    int256 constant HALF_SIZE = SIZE / int256(2);

    using String for uint256;

    string[20] internal bgColors = [
        "#FAF4EF",
        "#EFFAEF",
        "#EFF4FA",
        "#FAEFFA",
        "#EFF4FA",
        "#F4EFFA",
        "#FAFAEF",
        "#FAEFF4",
        "#EFFAFA",
        "#EFF7EB",
        "#DBDBDB",
        "#EDF1F7",
        "#EFF7EB",
        "#F7F7E9",
        "#EFEFEF",
        "#F0E6E6",
        "#E6F0EE",
        "#F0E6F0",
        "#E6E6F0",
        "#F0EEDB"
    ];

    function background(uint256 dnaBgLayer) internal view returns (string memory) {
        return string(abi.encodePacked('<rect x="0" y="0" width="100" height="100" fill="', bgColors[dnaBgLayer], '"/>'));
        // return draw(dnaBgLayer, 1);
    }

    function draw(uint256 dnaBgLayer, uint256 index) internal view returns (string memory) {
        string memory svg = "";

        for (uint256 i = 0; i < USIZE; i++) {
            for (uint256 j = 0; j < USIZE; j++) {
                if (index == 1) {
                    svg = string(
                        abi.encodePacked(
                            svg,
                            "<rect x='",
                            uint256(i * 10).uint2str(),
                            "' y='",
                            uint256(j * 10).uint2str(),
                            "' width='10' height='10' fill='black' />"
                        )
                    );
                }
            }
        }

        return svg;
    }
}
