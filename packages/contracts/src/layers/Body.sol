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
        string memory head,
        string memory head2,
        uint256 base
    )
        internal
        pure
        returns (string memory, string memory, string memory)
    {
        (string memory colorDefs, string memory fillColor) = getColor(r, g, b, r2, g2, b2, base);
        return (getBody(colorDefs, fillColor, head, head2), getStroke(head, head2), getBaseBody(colorDefs, fillColor));
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
        string memory head,
        string memory head2
    )
        internal
        pure
        returns (string memory)
    {
        return string(
            abi.encodePacked(
                colorDefs,
                '<path id="head" d="',
                head,
                'Z" transform-origin="center" fill="',
                fillColor,
                '">',
                '<animate attributeName="d" values="',
                head,
                ";",
                head2,
                ";",
                head,
                '" dur="15s" id="body-anim" repeatCount="indefinite"',
                ' keysplines=".42 0 1 1; 0 0 .59 1; .42 0 1 1; 0 0 .59 1;',
                ' .42 0 1 1; 0 0 .59 1; .42 0 1 1; 0 0 .59 1;"/>',
                '<animateTransform attributeName="transform" type="rotate" ',
                'from="0" to="10" dur="1000" repeatCount="indefinite" />',
                "</path>"
            )
        );
    }

    function getStroke(string memory head, string memory head2) internal pure returns (string memory) {
        return string(
            abi.encodePacked(
                '<path d="',
                head,
                'Z" id="body-stroke" stroke="',
                "black",
                '" stroke-width="2" fill="none" transform-origin="center">',
                '<animate attributeName="d" values="',
                head,
                ";",
                head2,
                ";",
                head,
                '" dur="16s" id="stroke-anim" repeatCount="indefinite" ',
                'begin="body-anim.begin + 2s" keysplines=".42 0 1 1; 0 0 .59 1; ',
                '.42 0 1 1; 0 0 .59 1; .42 0 1 1; 0 0 .59 1; .42 0 1 1; 0 0 .59 1;"/>',
                '<animateTransform attributeName="transform" type="rotate" from="0" ',
                'to="30" dur="1000" repeatCount="indefinite" />',
                "</path>"
            )
        );
    }

    function getBaseBody(string memory colorDefs, string memory fillColor) internal pure returns (string memory) {
        return string(
            abi.encodePacked(
                colorDefs,
                '<path id="body" fill="',
                fillColor,
                '" stroke-width="2" stroke="black" stroke-linecap="round" d="M42.695 51.68C48.086',
                "51.68 53.242 51.914 58.633 52.148 58.633 52.383 58.633 52.617 58.633 53.086 58.633 ",
                "54.023 58.867 55.195 58.867 56.367 58.867 56.836 58.867 57.305 58.867 57.773 59.102 ",
                "64.57 59.102 64.57 61.914 70.898 62.617 71.367 63.555 71.836 64.492 72.07 69.414 73.945 ",
                "72.93 77.227 75.508 81.914 77.617 86.602 77.852 92.227 77.852 97.383 77.852 97.852 ",
                "77.852 98.086 77.852 98.555 77.852 99.492 77.852 100.43 77.852 101.367 77.852 102.539 ",
                "77.852 103.711 77.852 104.883 77.852 106.523 77.852 108.398 77.852 110.039 74.805 110.039 ",
                "71.758 110.039 68.711 110.039 68.711 104.18 68.711 98.086 68.711 91.992 68.477 91.992 68.477 ",
                "91.992 68.242 91.992 68.242 97.852 68.242 103.945 68.242 110.039 59.57 110.039 51.133 110.039 ",
                "42.227 110.039 42.227 104.18 42.227 98.086 42.227 91.992 41.992 91.992 41.992 91.992 41.758 ",
                "91.992 41.758 97.852 41.758 103.945 41.758 110.039 36.133 110.039 36.133 110.039 33.789 ",
                "110.039 32.148 110.039 30.508 110.039 28.867 110.039 27.461 110.039 26.289 110.039 24.883 ",
                "110.039 24.414 110.039 23.945 110.039 23.477 110.039 22.773 110.039 22.07 110.039 21.367 ",
                "110.039 21.133 110.039 20.898 110.039 20.664 110.039 19.258 110.039 19.258 110.039 19.023 ",
                "109.805 19.023 109.336 19.023 108.867 19.023 108.633 19.023 108.164 19.023 108.164 19.023 ",
                "107.695 19.023 107.461 19.023 107.227 19.023 106.992 19.023 106.523 19.023 106.289 19.023 ",
                "106.055 19.023 105.352 19.023 104.648 19.023 103.945 19.023 103.477 19.023 102.773 19.023 ",
                "102.07 18.789 93.164 19.492 82.383 25.82 75.352 28.398 73.008 31.211 72.305 34.492 71.836 ",
                "38.008 71.367 38.008 71.367 41.289 69.727 41.992 68.086 41.758 66.211 41.992 64.57 41.992 ",
                "64.336 41.992 64.336 41.992 63.867 41.992 63.164 41.992 62.461 41.992 61.523 42.227 52.852 ",
                '42.227 52.852 42.695 51.68Z"/>"'
            )
        );
    }
}
