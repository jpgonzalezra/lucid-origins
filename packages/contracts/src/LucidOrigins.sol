// SPDX-License-Identifier: GNU GPLv3
pragma solidity 0.8.23;

import { ERC721A } from "ERC721A/ERC721A.sol";
import { Encoder } from "./Encoder.sol";
import { Owned } from "solmate/auth/Owned.sol";
import { console2 } from "forge-std/console2.sol";
import { Background } from "./layers/Background.sol";
import { Face } from "./layers/Face.sol";
import { Blush } from "./layers/Blush.sol";
import { Blob } from "./layers/Blob.sol";
import { LibString } from "solmate/utils/LibString.sol";
import { Constants } from "./utils/constants.sol";
import { Colors } from "./utils/Colors.sol";

contract LucidOrigins is Owned, ERC721A, Background, Face, Blob, Blush, Colors {
    using Encoder for string;
    using LibString for uint256;

    constructor() Owned(msg.sender) ERC721A("LucidOrigins", "LucidOrigins") { }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        uint16[] memory dna = getDna(uint256(keccak256(abi.encodePacked(tokenId))));
        string memory name = string.concat("LucidOrigins #", tokenId.toString());
        int256[6] memory backgroundShapeMatrix = [
            int256(normalizeToRange(dna[1], 0, 100)),
            int256(normalizeToRange(dna[2], 0, 100)),
            int256(normalizeToRange(dna[3], 0, 100)),
            int256(normalizeToRange(dna[4], 0, 100)),
            int256(normalizeToRange(dna[5], 0, 100)),
            int256(normalizeToRange(dna[6], 0, 100))
        ];
        string[4] memory backgroundColorMatrix = [
            colors[normalizeToRange(dna[1], 0, 71)],
            colors[normalizeToRange(dna[2], 0, 71)],
            colors[normalizeToRange(dna[3], 0, 71)],
            colors[normalizeToRange(dna[4], 0, 71)]
        ];

        string memory background = background(backgroundShapeMatrix, backgroundColorMatrix, normalizeToRange(dna[Constants.BASE_INDEX], 0, 100));

        string memory layers = "";
        uint256 layersLength = normalizeToRange(dna[Constants.BASE_INDEX], 2, 6);
        uint256 size = normalizeToRange(dna[Constants.SIZE_INDEX], 125, 135);
        string memory colorDefs;
        string memory fillColor;
        for (uint256 i = 1; i <= layersLength; i++) {
            (colorDefs, fillColor) = resolveDefsAndFillColor(
                normalizeToRange(dna[Constants.COLOR1_INDEX] * i, 0, 71),
                normalizeToRange(dna[Constants.COLOR2_INDEX] * i, 0, 71),
                normalizeToRange(dna[Constants.BASE_INDEX] * i, 0, 100)
            );
            uint256 minGrowth = normalizeToRange(dna[Constants.MIN_GROWTH_INDEX] * i, 6, 9);
            uint256 edgesNum = normalizeToRange(dna[Constants.EDGES_NUM_INDEX] * i, 10, 15);
            string memory path1 = createSvgPath(createPoints(size, 50, 0, minGrowth, edgesNum));
            string memory path2 = createSvgPath(createPoints(size + 1, 50, 0, minGrowth, edgesNum));
            layers = string.concat(layers, build(i, colorDefs, fillColor, path1, path2));
            unchecked {
                size = size - 30;
            }
        }
        string memory face = face(
            normalizeToRange(dna[Constants.EYE_RADIUS_INDEX], 7, 7),
            normalizeToRange(dna[Constants.EYE_SEPARATION_INDEX], 20, 25),
            normalizeToRange(dna[Constants.EYE_PUPIL_RADIUS_INDEX], 0, 6),
            fillColor
        );
        string memory svgContent = string.concat(layers, face, blush(normalizeToRange(dna[Constants.SIZE_INDEX], 2, layersLength).toString()));
        uint256 rotation = normalizeToRange(dna[Constants.SIZE_INDEX], 0, 3);
        string memory svg = string.concat(
            '<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg" width="400" height="400">',
            background,
            rotationWrapper(rotation, svgContent),
            "</svg>"
        );

        return metadata(name, svg);
    }

    function rotationWrapper(uint256 rotation, string memory content) internal pure returns (string memory) {
        string memory rotationDegree = rotation == 0 ? "0" : rotation == 1 ? "90" : rotation == 2 ? "180" : "-90";
        return string.concat(
            '<g transform="scale(0.99) rotate(', rotationDegree, ", 50, 50) translate(0 0)\">", content, "</g>"
        );
    }

    function metadata(string memory name, string memory svg) internal pure returns (string memory) {
        string memory description = "LucidOrigins, fully on-chain NFT";
        string memory json = string.concat(
            '{"name":"',
            name,
            '","description":"',
            description,
            '","image": "data:image/svg+xml;base64,',
            Encoder.base64(bytes(svg)),
            '"}'
        );
        return string.concat("data:application/json;base64,", Encoder.base64(bytes(json)));
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

    function resolveDefsAndFillColor(
        uint256 color1,
        uint256 color2,
        uint256 base
    )
        internal
        view
        returns (string memory, string memory)
    {
        bool isPlain = base < 80;
        string memory colorDefs = isPlain
            ? ""
            : string.concat(
                "<defs>",
                '<linearGradient id="linear-grad">',
                '<stop offset="0" stop-color="',
                colors[color1],
                '"/>',
                '<stop offset="1" stop-color="',
                colors[color2],
                '"/>',
                "</linearGradient>",
                "</defs>"
            );

        string memory fillColor = isPlain ? colors[color1] : "url(#linear-grad)";

        return (colorDefs, fillColor);
    }
}
