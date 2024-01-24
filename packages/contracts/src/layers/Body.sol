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
        uint256 x = 50;
        uint256 y = 0;
        string memory b1 = createSvgPath(createPoints(size, x, y, minGrowth, edgesNum));
        string memory b2 = createSvgPath(createPoints(size + animation, x, y, minGrowth, edgesNum));

        uint256 resize = size - 30;
        string memory bi1 = createSvgPath(createPoints(resize, x, y, minGrowth - 2, edgesNum / 2));
        string memory bi2 = createSvgPath(createPoints(resize + animation, x, y, minGrowth - 2, edgesNum / 2));

        return string(
            abi.encodePacked(
                build("body", colorDefs, fillColor, b1, b2), build("inner-body", colorDefs, fillColor, bi1, bi2)
            )
        );
    }
}
