// SPDX-License-Identifier: GNU GPLv3
pragma solidity 0.8.21;

import { Blob } from "./Blob.sol";

contract Body is Blob {
    function body(
        uint256 size,
        uint256 animation,
        uint256 minGrowth,
        uint256 edgesNum,
        string memory colorDefs,
        string memory fillColor
    )
        internal
        view
        returns (string memory)
    {
        Point[] memory points = createPoints(size, minGrowth, edgesNum);
        string memory b1 = createSvgPath(points);
        string memory b2 = createSvgPath(createPoints(size + animation, minGrowth, edgesNum));

        Point[] memory points2 = createPoints(size - 30, minGrowth - 2, edgesNum / 2);
        string memory bi1 = createSvgPath(points2);
        string memory bi2 = createSvgPath(createPoints(size - 30 + animation, minGrowth - 2, edgesNum / 2));

        string memory id = "body";
        return
            string(abi.encodePacked(build(id, colorDefs, fillColor, b1, b2), build(id, colorDefs, fillColor, bi1, bi2)));
    }

    function calculatePointY(uint256 outerRad) internal view virtual override returns (uint256 y) {
        y = outerRad > 40 ? 110 : 80;
    }
}
