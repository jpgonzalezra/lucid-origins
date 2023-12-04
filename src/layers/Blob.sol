// SPDX-License-Identifier: GNU GPLv3
pragma solidity 0.8.21;

// import { console2 } from "forge-std/console2.sol";
import { String } from "../utils/String.sol";
import { Colors } from "../utils/Colors.sol";
import { Trigonometry } from "solidity-trigonometry/Trigonometry.sol";

contract Blob is Colors {
    struct Point {
        int256 x;
        int256 y;
    }

    using String for int256;
    using String for uint256;
    using Trigonometry for uint256;

    function blob(
        uint256 size,
        uint256 minGrowth,
        uint256 edgesNum,
        uint256 randColorIndex
    )
        external
        view
        returns (string memory)
    {
        require(size >= 95 && size <= 105, "Invalid Blob Size");
        require(randColorIndex < colors.length, "Invalid Blob randColorIndex");

        Point[] memory points = createPoints(size, minGrowth, edgesNum);

        return string(
            abi.encodePacked(
                '<path stroke="transparent" stroke-width="0" fill = "',
                colors[randColorIndex],
                '" d="',
                createSvgPath(points),
                'Z" />'
            )
        );
    }

    function createPoints(uint256 size, uint256 minGrowth, uint256 edgesNum) internal view returns (Point[] memory) {
        Point[] memory points = new Point[](edgesNum);
        uint256 outerRad = size / 2;
        uint256 innerRad = minGrowth * (outerRad / 10);
        uint256 center = size / 2;
        uint256 deg = 360 / edgesNum;

        for (uint256 i = 0; i < edgesNum; i++) {
            uint256 degree = i * deg;
            uint256 radius = randPoint(innerRad, outerRad);
            points[i] = calculatePoint(center, radius, degree);
        }

        return points;
    }

    function randPoint(uint256 minv, uint256 maxv) internal view returns (uint256) {
        // Simple randomization.
        uint256 random = uint256(keccak256(abi.encodePacked(block.timestamp, minv, maxv))) % maxv;
        return (random >= minv) ? random : minv + (random % (maxv - minv));
    }

    function calculatePoint(uint256 origin, uint256 radius, uint256 degree) internal pure returns (Point memory) {
        int256 cosValue = (degree * Trigonometry.PI / 180).cos() / 1e18;
        int256 sinValue = (degree * Trigonometry.PI / 180).sin() / 1e18;

        int256 x = int256(origin) + int256(radius) * cosValue;
        int256 y = int256(origin) + int256(radius) * sinValue;

        return Point(x, y);
    }

    function createSvgPath(Point[] memory points) internal pure returns (string memory) {
        string memory svgPath;
        Point memory mid = Point({ x: (points[0].x + points[1].x) / 2, y: (points[0].y + points[1].y) / 2 });

        svgPath = string(abi.encodePacked("M", mid.x.int2str(), ",", mid.y.int2str()));

        for (uint256 i = 0; i < points.length; i++) {
            Point memory p1 = points[(i + 1) % points.length];
            Point memory p2 = points[(i + 2) % points.length];
            Point memory midPoint = Point({ x: (p1.x + p2.x) / 2, y: (p1.y + p2.y) / 2 });

            svgPath = string(
                abi.encodePacked(
                    svgPath,
                    "Q",
                    p1.x.int2str(),
                    ",",
                    p1.y.int2str(),
                    ",",
                    midPoint.x.int2str(),
                    ",",
                    midPoint.y.int2str()
                )
            );
        }

        return string(abi.encodePacked(svgPath, "Z"));
    }
}
