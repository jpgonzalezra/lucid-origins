// SPDX-License-Identifier: GNU GPLv3
pragma solidity 0.8.23;

import { console2 } from "forge-std/console2.sol";
import { LibString } from "solmate/utils/LibString.sol";

contract Background {
    using LibString for int256;

    string[20] internal bgColors = [
        "#F8F8F8",
        "#F0F0F0",
        "#E8E8E8",
        "#E0E0E0",
        "#D8D8D8",
        "#D0D0D0",
        "#C8C8C8",
        "#C0C0C0",
        "#B8B8B8",
        "#B0B0B0",
        "#A8A8A8",
        "#A0A0A0",
        "#989898",
        "#909090",
        "#888888",
        "#808080",
        "#787878",
        "#707070",
        "#686868",
        "#606060"
    ];

    function generatePath(int256 curveVal, int256 pos, int256 index) internal pure returns (string memory) {
        int256 cVal = curveVal % 100;
        int256 bigC = 100 - cVal;

        return string(
            abi.encodePacked(
                "m 50 ",
                ((50 + pos + 50 * index) % 100).toString(),
                " Q ",
                bigC.toString(),
                " ",
                cVal.toString(),
                " ",
                ((100 - pos - 50 * index) % 100).toString(),
                " 50 Q ",
                bigC.toString(),
                " ",
                bigC.toString(),
                " 50 ",
                ((100 - pos - 50 * index) % 100).toString(),
                " Q ",
                cVal.toString(),
                " ",
                bigC.toString(),
                " ",
                ((50 + pos + 50 * index) % 100).toString(),
                " 50 Q ",
                cVal.toString(),
                " ",
                cVal.toString(),
                " 50 ",
                ((50 + pos + 50 * index) % 100).toString(),
                " z"
            )
        );
    }

    function hydrateBlog(string[3] memory paths, string[3] memory colors) internal pure returns (string memory) {
        return string(
            abi.encodePacked(
                '<path d="',
                paths[0],
                '" fill="rgb(',
                colors[1],
                ')" /><path d="',
                paths[1],
                '" fill="rgb(',
                colors[2],
                ')" /><path d="',
                paths[2],
                '" fill="rgb(',
                colors[0],
                ')" />'
            )
        );
    }

    function background(uint256 dnaBgLayer) internal view returns (string memory) {
        string[3] memory paths = [
            generatePath(int256(dnaBgLayer * 10), 30, 0),
            generatePath(int256(dnaBgLayer * 20), 40, 1),
            generatePath(int256(dnaBgLayer * 30), 20, 2)
        ];

        string memory elColor = bgColors[dnaBgLayer * 10 % 20];
        string[3] memory colors = [elColor, bgColors[dnaBgLayer % 20], bgColors[dnaBgLayer * 30 % 20]];
        // console2.log(hydrateBlog(paths, colors));
        return hydrateBlog(paths, colors);
    }
}
