// SPDX-License-Identifier: GNU GPLv3
pragma solidity 0.8.23;

import { LibString } from "solmate/utils/LibString.sol";

contract Background {
    using LibString for int256;

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

    function hydrateBlog(string[3] memory paths, string[4] memory colors) internal pure returns (string memory) {
        return string.concat(
            '<g id="bg" opacity="0.4"><rect width="100" height="100" fill="',
            colors[0],
            '" />',
            '<path d="',
            paths[0],
            '" fill="',
            colors[2],
            '" /><path d="',
            paths[1],
            '" fill="',
            colors[3],
            '" /><path d="',
            paths[2],
            '" fill="',
            colors[1],
            '" /></g>'
        );
    }

    function background(
        uint256[6] memory bgShapeMatrix,
        string[4] memory bgColorMatrix,
        uint256 base
    )
        internal
        pure
        returns (string memory)
    {
        bool isPlain = base < 55;
        bool isBiTone = base < 70;

        string[3] memory paths = [
            generatePath(int256(bgShapeMatrix[0]), int256(bgShapeMatrix[1]), 2),
            generatePath(int256(bgShapeMatrix[2]), int256(bgShapeMatrix[3]), 1),
            generatePath(int256(bgShapeMatrix[4]), int256(bgShapeMatrix[5]), 0)
        ];

        string[4] memory colors = isPlain
            ? [bgColorMatrix[0], bgColorMatrix[0], bgColorMatrix[0], bgColorMatrix[0]]
            : isBiTone ? [bgColorMatrix[0], bgColorMatrix[3], bgColorMatrix[0], bgColorMatrix[3]] : bgColorMatrix;

        return hydrateBlog(paths, colors);
    }
}
