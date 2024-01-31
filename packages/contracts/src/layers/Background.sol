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

        int256 part1x = 33 + pos + 66 * index;
        int256 part3x = 66 - pos - 66 * index;
        int256 part5x = 33 + pos + 66 * index;

        return string.concat(
            "m 50 ",
            part1x.toString(),
            " Q ",
            bigC.toString(),
            " ",
            cVal.toString(),
            " ",
            part3x.toString(),
            " 50 Q ",
            bigC.toString(),
            " ",
            bigC.toString(),
            " 50 ",
            part3x.toString(),
            " Q ",
            cVal.toString(),
            " ",
            bigC.toString(),
            " ",
            part5x.toString(),
            " 50 Q ",
            cVal.toString(),
            " ",
            cVal.toString(),
            " 50 ",
            part5x.toString(),
            " z"
        );
    }

    function hydrateBlog(string[3] memory paths, string[3] memory colors) internal pure returns (string memory) {
        return string.concat(
            '<path d="',
            paths[0],
            '" fill="',
            colors[1],
            '" /><path d="',
            paths[1],
            '" fill="',
            colors[2],
            '" /><path d="',
            paths[2],
            '" fill="',
            colors[0],
            '" />'
        );
    }

    function background(uint256 dnaBgLayer) internal view returns (string memory) {
        string[3] memory paths = [generatePath(68, 23, 2), generatePath(11, 70, 1), generatePath(38, 67, 0)];
        string[3] memory colors = ["#27b4f6", "#D84B09", "#F67094"];
        console2.log(hydrateBlog(paths, colors));
        return hydrateBlog(paths, colors);
    }
}
