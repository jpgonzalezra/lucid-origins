// SPDX-License-Identifier: GNU GPLv3
pragma solidity 0.8.21;

// import { console2 } from "forge-std/console2.sol";
import { LibString } from "solmate/utils/LibString.sol";
import { Trigonometry } from "solidity-trigonometry/Trigonometry.sol";

contract Head {
    struct Point {
        int256 x;
        int256 y;
    }

    using LibString for int256;
    using Trigonometry for uint256;

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
        returns (string memory, string memory)
    {
        Point[] memory points = createPoints(size, minGrowth, edgesNum);
        string memory h1 = createSvgPath(points);
        string memory h2 = createSvgPath(createPoints(size + animation, minGrowth, edgesNum));
        return (buildHead(colorDefs, fillColor, h1, h2), buildStroke(h1, h2));
    }

    function createPoints(uint256 size, uint256 minGrowth, uint256 edgesNum) internal view returns (Point[] memory) {
        Point[] memory points = new Point[](edgesNum);

        uint256 outerRad = size / 2;
        uint256 innerRad = minGrowth * (outerRad / 10);
        uint256 center = size / 2;
        uint256 deg = 360 / edgesNum;

        for (uint256 i = 0; i < edgesNum; i++) {
            uint256 degree = i * deg;
            uint256 radius = randPoint(i, innerRad, outerRad);
            Point memory point = calculatePoint(center, radius, degree);
            points[i] = point;
        }

        return points;
    }

    function calculatePoint(uint256 origin, uint256 radius, uint256 degree) internal pure returns (Point memory) {
        uint256 scaledDegree = degree * 1e18;
        uint256 scaledPI = Trigonometry.PI;

        int256 cosValue = uint256(scaledDegree * scaledPI / 180 / 1e18).cos();
        int256 sinValue = (scaledDegree * scaledPI / 180 / 1e18).sin();

        int256 x = int256(origin) + int256(radius) * cosValue / 1e18;
        int256 y = int256(origin) + int256(radius) * sinValue / 1e18;

        return Point(x, y);
    }

    function randPoint(uint256 i, uint256 minv, uint256 maxv) internal view returns (uint256) {
        uint256 random = uint256(keccak256(abi.encodePacked(block.number, block.timestamp, i, minv, maxv))) % maxv;
        return (random >= minv) ? random : minv + (random % (maxv - minv));
    }

    function createSvgPath(Point[] memory points) internal pure returns (string memory) {
        string memory svgPath;
        Point memory mid = Point({ x: (points[0].x + points[1].x) / 2, y: (points[0].y + points[1].y) / 2 });

        svgPath = string(abi.encodePacked("M", mid.x.toString(), ",", mid.y.toString()));

        for (uint256 i = 0; i < points.length; i++) {
            Point memory p1 = points[(i + 1) % points.length];
            Point memory p2 = points[(i + 2) % points.length];
            Point memory midPoint = Point({ x: (p1.x + p2.x) / 2, y: (p1.y + p2.y) / 2 });

            svgPath = string(
                abi.encodePacked(
                    svgPath,
                    "Q",
                    p1.x.toString(),
                    ",",
                    p1.y.toString(),
                    ",",
                    midPoint.x.toString(),
                    ",",
                    midPoint.y.toString()
                )
            );
        }

        return string(abi.encodePacked(svgPath, "Z"));
    }

    function buildHead(
        string memory colorDefs,
        string memory fillColor,
        string memory h1,
        string memory h2
    )
        private
        pure
        returns (string memory)
    {
        return string(
            abi.encodePacked(
                colorDefs,
                '<path id="head" d="',
                h1,
                'Z" transform-origin="center" fill="',
                fillColor,
                '">',
                '<animate attributeName="d" values="',
                h1,
                ";",
                h2,
                ";",
                h1,
                '" dur="15s" id="body-anim" repeatCount="indefinite"',
                ' keysplines=".42 0 1 1; 0 0 .59 1; .42 0 1 1; 0 0 .59 1;',
                ' .42 0 1 1; 0 0 .59 1; .42 0 1 1; 0 0 .59 1;"/>',
                '<animateTransform attributeName="transform" type="rotate" ',
                'from="0" to="10" dur="1000" repeatCount="indefinite" />',
                "</path>"
            )
        );
    }

    function buildStroke(string memory h, string memory h2) private pure returns (string memory) {
        return string(
            abi.encodePacked(
                '<path d="',
                h,
                'Z" id="body-stroke" stroke="',
                "black",
                '" stroke-width="2" fill="none" transform-origin="center">',
                '<animate attributeName="d" values="',
                h,
                ";",
                h2,
                ";",
                h,
                '" dur="16s" id="stroke-anim" repeatCount="indefinite" ',
                'begin="body-anim.begin + 2s" keysplines=".42 0 1 1; 0 0 .59 1; ',
                '.42 0 1 1; 0 0 .59 1; .42 0 1 1; 0 0 .59 1; .42 0 1 1; 0 0 .59 1;"/>',
                '<animateTransform attributeName="transform" type="rotate" from="0" ',
                'to="30" dur="1000" repeatCount="indefinite" />',
                "</path>"
            )
        );
    }
}
