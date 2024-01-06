// SPDX-License-Identifier: GNU GPLv3
pragma solidity 0.8.21;

// import { console2 } from "forge-std/console2.sol";
import { String } from "../utils/String.sol";

contract Body {
    using String for uint256;
    using String for int256;

    function body(
        uint256 r,
        uint256 g,
        uint256 b,
        uint256 r2,
        uint256 g2,
        uint256 b2,
        string memory blob,
        string memory blob2,
        uint256 base
    )
        internal
        pure
        returns (string memory, string memory)
    {
        (string memory colorDefs, string memory fillColor) = getColor(r, g, b, r2, g2, b2, base);

        return (getBody(colorDefs, fillColor, blob, blob2), getStroke(blob, blob2));
    }

    function getColor(
        uint256 r,
        uint256 g,
        uint256 b,
        uint256 r2,
        uint256 g2,
        uint256 b2,
        uint256 base
    )
        internal
        pure
        returns (string memory, string memory)
    {
        bool isPlain = base < 20;
        string memory colorDefs = isPlain
            ? ""
            : string(
                abi.encodePacked(
                    "<defs>",
                    '<linearGradient id="linear-grad">',
                    '<stop offset="0" stop-color="',
                    "rgb(",
                    r.uint2str(),
                    ",",
                    g.uint2str(),
                    ",",
                    b.uint2str(),
                    ')"/>',
                    '<stop offset="1" stop-color="',
                    "rgb(",
                    r2.uint2str(),
                    ",",
                    g2.uint2str(),
                    ",",
                    b2.uint2str(),
                    ')"/>',
                    "</linearGradient>",
                    "</defs>"
                )
            );

        string memory fillColor = isPlain
            ? string(abi.encodePacked("rgb(", r.uint2str(), ",", g.uint2str(), ",", b.uint2str(), ")"))
            : "url(#linear-grad)";

        return (colorDefs, fillColor);
    }

    function getBody(
        string memory colorDefs,
        string memory fillColor,
        string memory blob,
        string memory blob2
    )
        internal
        pure
        returns (string memory)
    {
        return string(
            abi.encodePacked(
                colorDefs,
                '<path d="',
                blob,
                'Z" transform-origin="center" fill="',
                fillColor,
                '">',
                '<animate attributeName="d" values="',
                blob,
                ";",
                blob2,
                ";",
                blob,
                '" dur="15s" id="body-anim" repeatCount="indefinite"',
                ' keysplines=".42 0 1 1; 0 0 .59 1; .42 0 1 1; 0 0 .59 1;',
                ' .42 0 1 1; 0 0 .59 1; .42 0 1 1; 0 0 .59 1;"/>',
                '<animateTransform attributeName="transform" type="rotate" ',
                'from="0" to="10" dur="1000" repeatCount="indefinite" />',
                "</path>"
            )
        );
    }

    function getStroke(string memory blob, string memory blob2) internal pure returns (string memory) {
        return string(
            abi.encodePacked(
                '<path d="',
                blob,
                'Z" id="body-stroke" stroke="',
                "black",
                '" stroke-width="2" fill="none" transform-origin="center">',
                '<animate attributeName="d" values="',
                blob,
                ";",
                blob2,
                ";",
                blob,
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
