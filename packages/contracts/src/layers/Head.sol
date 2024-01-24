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
        uint256 x = 50;
        uint256 y = 0;

        Point[] memory points = createPoints(size, x, y, minGrowth, edgesNum);
        string memory h1 = createSvgPath(points);
        string memory h2 = createSvgPath(createPoints(size + animation, x, y, minGrowth, edgesNum));
        return build("head", colorDefs, fillColor, h1, h2);
    }
}
