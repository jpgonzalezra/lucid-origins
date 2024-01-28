// SPDX-License-Identifier: GNU GPLv3
pragma solidity 0.8.23;

// import { console2 } from "forge-std/console2.sol";
import { LibString } from "solmate/utils/LibString.sol";

contract Face {
    using LibString for uint256;

    function face(
        uint256 eyeRadius,
        uint256 eyeSeparation,
        uint256 pupilRadius,
        string memory pupilColor
    )
        internal
        pure
        returns (string memory)
    {
        string memory eyes = getEyes(eyeRadius, eyeSeparation, pupilRadius, pupilColor);
        return string(abi.encodePacked('<g id="face" >', eyes, "</g>"));
    }

    function getEyes(
        uint256 eyeRadius,
        uint256 eyeSeparation,
        uint256 pupilRadius,
        string memory pupilColor
    )
        internal
        pure
        returns (string memory)
    {
        return string(
            abi.encodePacked(
                '<g id="face">',
                '<circle cx="',
                (50 - eyeSeparation / 2).toString(),
                '" cy="40" r="',
                eyeRadius.toString(),
                '" fill="white"/>',
                '<circle cx="',
                (50 - eyeSeparation / 2).toString(),
                '" cy="40" r="',
                pupilRadius.toString(),
                '" fill="',
                string(abi.encodePacked(pupilColor)),
                '"/>' '<circle cx="',
                (50 + eyeSeparation / 2).toString(),
                '" cy="40" r="',
                eyeRadius.toString(),
                '" fill="white"/>',
                '<circle cx="',
                (50 + eyeSeparation / 2).toString(),
                '" cy="40" r="',
                pupilRadius.toString(),
                '" fill="',
                string(abi.encodePacked(pupilColor)),
                '"/>' "</g>"
            )
        );
    }

    function _getEyes(
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
                '<g id="eyes">',
                '<circle cx="',
                (50 - eyeSeparation / 2).toString(),
                '" cy="40" r="',
                eyeRadius.toString(),
                '" fill="',
                linesColor,
                '" transform="rotate(',
                eyebrowRotation.toString(),
                " ",
                (50 - eyeSeparation / 2).toString(),
                ' 40)"/>',
                '<circle cx="',
                (50 + eyeSeparation / 2).toString(),
                '" cy="40" r="',
                eyeRadius.toString(),
                '" fill="',
                linesColor,
                '" transform="rotate(',
                eyebrowRotation.toString(),
                " ",
                (50 + eyeSeparation / 2).toString(),
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
                (35 - eyebrowSize).toString(),
                '" y1="',
                (30 - eyebrowLength).toString(),
                '" x2="',
                (45 + eyebrowSize).toString(),
                '" y2="',
                (30 - eyebrowLength).toString(),
                '" stroke="',
                linesColor,
                '" stroke-width="2" stroke-linecap="round" transform="rotate(',
                eyebrowRotation.toString(),
                " 35 ",
                (30 - eyebrowLength).toString(),
                ") scale(",
                leftEyebrowScale.toString(),
                ')"/>',
                '<line x1="',
                (60 - eyebrowSize).toString(),
                '" y1="',
                (30 - eyebrowLength).toString(),
                '" x2="',
                (65 + eyebrowSize).toString(),
                '" y2="',
                (30 - eyebrowLength).toString(),
                '" stroke="',
                linesColor,
                '" stroke-width="2" stroke-linecap="round" transform="rotate(',
                eyebrowRotation.toString(),
                " 65 ",
                (30 - eyebrowLength).toString(),
                ") scale(",
                rightEyebrowScale.toString(),
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
                x1.toString(),
                " ",
                y1.toString(),
                " Q",
                x2.toString(),
                " ",
                y2.toString(),
                " ",
                x3.toString(),
                " ",
                y3.toString(),
                '" stroke="',
                linesColor,
                '" stroke-width="2" fill="transparent" stroke-linecap="round" transform="rotate(',
                mouthRotation.toString(),
                " 50 ",
                (50 + controlY).toString(),
                ')"/>',
                "</g>"
            )
        );
    }
}
