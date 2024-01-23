// SPDX-License-Identifier: GNU GPLv3
pragma solidity 0.8.21;

import { Blob } from "./Blob.sol";

contract Head is Blob {

    function head(
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
        string memory h1 = createSvgPath(points);
        string memory h2 = createSvgPath(createPoints(size + animation, minGrowth, edgesNum));
        return build("head", colorDefs, fillColor, h1, h2);
    }

    function calculatePointY(uint256 outerRad) internal view virtual override returns (uint256 y) {
        y = outerRad < 35 ? 45 : 50;
    }
}
