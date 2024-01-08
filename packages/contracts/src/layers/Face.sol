// SPDX-License-Identifier: GNU GPLv3
pragma solidity 0.8.21;

// import { console2 } from "forge-std/console2.sol";
import { String } from "../utils/String.sol";

contract Face {
    using String for uint256;
    using String for int256;

    function face(
        uint256 eyeRadius,
        uint256 eyebrowLength,
        uint256 eyeSeparation,
        uint256 eyebrowRotation,
        uint256 mouthRotation,
        uint256 eyebrowSize,
        string memory linesColor
    )
        internal
        pure
        returns (string memory)
    {
        string memory eyes = getEyes(eyeRadius, eyeSeparation, eyebrowRotation, linesColor);
        string memory eyebrows = getEyebrows(eyebrowLength, eyebrowRotation, eyebrowSize, mouthRotation, linesColor);
        string memory mouth = getMouth(eyeSeparation, eyebrowRotation, eyebrowSize, mouthRotation, linesColor);

        return string(
            abi.encodePacked('<g id="face" transform="scale(0.6) translate(25 25)">', eyes, eyebrows, mouth, "</g>")
        );
    }

    function getEyes(
        uint256 eyeRadius,
        uint256 eyeSeparation,
        uint256 eyebrowRotation,
        string memory linesColor
    )
        internal
        pure
        returns (string memory)
    {
        return string(
            abi.encodePacked(
                '<g id="face">',
                '<circle cx="',
                (50 - eyeSeparation / 2).uint2str(),
                '" cy="40" r="',
                eyeRadius.uint2str(),
                '" fill="',
                linesColor,
                '" transform="rotate(',
                eyebrowRotation.uint2str(),
                " ",
                (50 - eyeSeparation / 2).uint2str(),
                ' 40)"/>',
                '<circle cx="',
                (50 + eyeSeparation / 2).uint2str(),
                '" cy="40" r="',
                eyeRadius.uint2str(),
                '" fill="',
                linesColor,
                '" transform="rotate(',
                eyebrowRotation.uint2str(),
                " ",
                (50 + eyeSeparation / 2).uint2str(),
                ' 40)"/>',
                "</g>"
            )
        );
    }

    function getEyebrows(
        uint256 eyebrowLength,
        uint256 eyebrowRotation,
        uint256 eyebrowSize,
        uint256 mouthRotation,
        string memory linesColor
    )
        internal
        pure
        returns (string memory)
    {
        uint256 leftEyebrowScale = eyebrowRotation > 10 ? 0 : 1;
        uint256 rightEyebrowScale = mouthRotation > 3 ? 0 : 1;
        return string(
            abi.encodePacked(
                '<g id="eyebrows">',
                '<line x1="',
                (35 - eyebrowSize).uint2str(),
                '" y1="',
                (30 - eyebrowLength).uint2str(),
                '" x2="',
                (45 + eyebrowSize).uint2str(),
                '" y2="',
                (30 - eyebrowLength).uint2str(),
                '" stroke="',
                linesColor,
                '" stroke-width="4" stroke-linecap="round" transform="rotate(',
                eyebrowRotation.uint2str(),
                " 35 ",
                (30 - eyebrowLength).uint2str(),
                ") scale(",
                leftEyebrowScale.uint2str(),
                ')"/>',
                '<line x1="',
                (60 - eyebrowSize).uint2str(),
                '" y1="',
                (30 - eyebrowLength).uint2str(),
                '" x2="',
                (65 + eyebrowSize).uint2str(),
                '" y2="',
                (30 - eyebrowLength).uint2str(),
                '" stroke="',
                linesColor,
                '" stroke-width="4" stroke-linecap="round" transform="rotate(',
                eyebrowRotation.uint2str(),
                " 65 ",
                (30 - eyebrowLength).uint2str(),
                ") scale(",
                rightEyebrowScale.uint2str(),
                ')"/>',
                "</g>"
            )
        );
    }

    function getMouth(
        uint256 eyeSeparation,
        uint256 eyebrowRotation,
        uint256 eyebrowSize,
        uint256 mouthRotation,
        string memory linesColor
    )
        internal
        pure
        returns (string memory)
    {
        uint256 controlY = 5 + mouthRotation;
        uint256 size = eyeSeparation - eyebrowRotation;

        uint256 x1 = 40 - mouthRotation;
        uint256 x3 = 60 + eyebrowSize;
        uint256 x2 = (x1 + x3) / 2;
        uint256 y1 = 50 + controlY;
        uint256 y2 = eyeSeparation > 25 ? 50 + size : 50 - size;
        uint256 y3 = 50 + controlY;

        return string(
            abi.encodePacked(
                '<g id="mouth">',
                '<path d="M',
                x1.uint2str(),
                " ",
                y1.uint2str(),
                " Q",
                x2.uint2str(),
                " ",
                y2.uint2str(),
                " ",
                x3.uint2str(),
                " ",
                y3.uint2str(),
                '" stroke="',
                linesColor,
                '" stroke-width="4" fill="transparent" stroke-linecap="round" transform="rotate(',
                mouthRotation.uint2str(),
                " 50 ",
                (50 + controlY).uint2str(),
                ')"/>',
                "</g>"
            )
        );
    }
}
