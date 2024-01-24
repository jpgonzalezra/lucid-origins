// SPDX-License-Identifier: GNU GPLv3
pragma solidity 0.8.21;

import { ERC721A } from "ERC721A/ERC721A.sol";
import { Encoder } from "./Encoder.sol";
import { Owned } from "solmate/auth/Owned.sol";
import { console2 } from "forge-std/console2.sol";
import { Background } from "./layers/Background.sol";
import { Face } from "./layers/Face.sol";
import { Body } from "./layers/Body.sol";
import { Head } from "./layers/Head.sol";
import { Blush } from "./layers/Blush.sol";
import { LibString } from "solmate/utils/LibString.sol";
import { Constants } from "./utils/constants.sol";

contract LucidOrigins is Owned, ERC721A, Background, Face, Body, Head, Blush {
    using Encoder for string;
    using LibString for uint256;

    constructor() Owned(msg.sender) ERC721A("LucidOrigins", "LucidOrigins") { }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        uint16[] memory dna = getDna(uint256(keccak256(abi.encodePacked(tokenId))));

        string memory name = string(abi.encodePacked("LucidOrigins #", tokenId.toString()));
        string memory header = '<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg" width="400" height="400">';

        uint256 r = normalizeToRange(dna[Constants.R_INDEX], 1, 255);
        uint256 g = normalizeToRange(dna[Constants.G_INDEX], 1, 255);
        uint256 b = normalizeToRange(dna[Constants.B_INDEX], 1, 255);

        uint256 r2 = normalizeToRange(dna[Constants.R2_INDEX], 1, 255);
        uint256 g2 = normalizeToRange(dna[Constants.G2_INDEX], 1, 255);
        uint256 b2 = normalizeToRange(dna[Constants.B2_INDEX], 1, 255);

        string memory background = background(normalizeToRange(dna[Constants.BACKGROUND_INDEX], 0, 16));

        string memory linesColor = isColorDark(r, g, b) ? "#FFF" : "#000";

        string memory face = face(
            normalizeToRange(dna[Constants.EYE_RADIUS_INDEX], 7, 7),
            normalizeToRange(dna[Constants.EYE_BROW_LENGHT_INDEX], 2, 4),
            normalizeToRange(dna[Constants.EYE_SEPARATION_INDEX], 20, 25),
            normalizeToRange(dna[Constants.EYE_BROW_ROTATION_INDEX], 0, 20),
            normalizeToRange(dna[Constants.MOUNTH_ROTATION], 0, 6),
            normalizeToRange(dna[Constants.EYE_BROW_SIZE_INDEX], 1, 5),
            linesColor,
            r2,
            g2,
            b2
        );

        (string memory colorDefs, string memory fillColor) =
            getColor(r, g, b, r2, g2, b2, normalizeToRange(dna[Constants.BASE_INDEX], 0, 100));

        string memory head = head(
            normalizeToRange(dna[Constants.HEAD_SIZE_INDEX], 60, 78),
            normalizeToRange(dna[Constants.HEAD_SIZE_INDEX], 1, 3),
            normalizeToRange(dna[Constants.HEAD_MIN_GROWTH_INDEX], 6, 9),
            normalizeToRange(dna[Constants.HEAD_EDGES_NUM_INDEX], 5, 15),
            colorDefs,
            fillColor
        );

        string memory body = body(
            normalizeToRange(dna[Constants.HEAD_SIZE_INDEX], 95, 125),
            normalizeToRange(dna[Constants.HEAD_SIZE_INDEX], 1, 3),
            normalizeToRange(dna[Constants.HEAD_MIN_GROWTH_INDEX], 9, 12),
            normalizeToRange(dna[Constants.HEAD_EDGES_NUM_INDEX], 10, 55),
            colorDefs,
            fillColor
        );

        string memory footer = "</svg>";

        string memory svgContent = string(abi.encodePacked(body, head, face, blush()));

        uint256 rotation = normalizeToRange(dna[Constants.HEAD_SIZE_INDEX], 0, 3);
        string memory svg = string(abi.encodePacked(header, background, rotationWrapper(rotation, svgContent), footer));

        return metadata(name, svg);
    }

    function rotationWrapper(uint256 rotation, string memory content) internal pure returns (string memory) {
        string memory rotationDegree = rotation == 0 ? "0" : rotation == 1 ? "90" : rotation == 2 ? "180" : "-90";
        return string(
            abi.encodePacked(
                '<g transform="scale(0.99) rotate(', rotationDegree, ", 50, 50) translate(0 0)\">", content, "</g>"
            )
        );
    }

    function metadata(string memory name, string memory svg) internal pure returns (string memory) {
        string memory description = "LucidOrigins, fully on-chain NFT";
        string memory json = string(
            abi.encodePacked(
                '{"name":"',
                name,
                '","description":"',
                description,
                '","image": "data:image/svg+xml;base64,',
                Encoder.base64(bytes(svg)),
                '"}'
            )
        );
        return string(abi.encodePacked("data:application/json;base64,", Encoder.base64(bytes(json))));
    }

    function getDna(uint256 preDna) internal pure returns (uint16[] memory) {
        if (preDna == 0) {
            return new uint16[](1);
        }

        uint256 count = 0;
        uint256 aux = preDna;
        while (aux != 0) {
            count++;
            aux /= 10;
        }

        uint256 arraySize = (count + 2) / 3;
        uint16[] memory digits = new uint16[](arraySize);
        uint256 index = arraySize - 1;

        while (preDna != 0) {
            uint16 threeDigits = uint16(preDna % 1000);
            digits[index] = threeDigits;
            preDna /= 1000;
            if (index > 0) {
                index--;
            }
        }

        return digits;
    }

    function normalizeToRange(uint256 value, uint256 minRange, uint256 maxRange) internal pure returns (uint256) {
        require(minRange <= maxRange, "invalid Min/Max range");
        uint256 adjustedRange = maxRange - minRange + 1;
        return minRange + (value % adjustedRange);
    }

    function isColorDark(uint256 r, uint256 g, uint256 b) public pure returns (bool) {
        return (2126 * r + 7152 * g + 722 * b) / 10_000 < 128;
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
        bool isPlain = base < 80;
        string memory colorDefs = isPlain
            ? ""
            : string(
                abi.encodePacked(
                    "<defs>",
                    '<linearGradient id="linear-grad">',
                    '<stop offset="0" stop-color="',
                    "rgb(",
                    r.toString(),
                    ",",
                    g.toString(),
                    ",",
                    b.toString(),
                    ')"/>',
                    '<stop offset="1" stop-color="',
                    "rgb(",
                    r2.toString(),
                    ",",
                    g2.toString(),
                    ",",
                    b2.toString(),
                    ')"/>',
                    "</linearGradient>",
                    "</defs>"
                )
            );

        string memory fillColor = isPlain
            ? string(abi.encodePacked("rgb(", r.toString(), ",", g.toString(), ",", b.toString(), ")"))
            : "url(#linear-grad)";

        return (colorDefs, fillColor);
    }
}
