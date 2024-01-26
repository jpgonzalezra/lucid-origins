// SPDX-License-Identifier: GNU GPLv3
pragma solidity 0.8.21;

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

contract LucidOrigins is Owned, ERC721A, Background, Face, Blob, Blush {
    using Encoder for string;
    using LibString for uint256;

    string[71] internal colors = [
        "#FEFEFE",
        "#EFE3D8",
        "#7E6966",
        "#000000",
        "#2B3C3D",
        "#A5B5C6",
        "#5D6224",
        "#BF8B3B",
        "#5C7E92",
        "#81A79A",
        "#1E2113",
        "#9E4F42",
        "#DEC209",
        "#F8E6CD",
        "#E29F0C",
        "#F5DBAE",
        "#EBF8FE",
        "#C34229",
        "#3767B5",
        "#DCD996",
        "#829F6C",
        "#A49165",
        "#9B5349",
        "#F8E6CE",
        "#2B3E44",
        "#CDBDA2",
        "#9C7959",
        "#131B2B",
        "#F7F5EB",
        "#96661C",
        "#881B17",
        "#CAC77A",
        "#5C5254",
        "#D7B468",
        "#335C9B",
        "#D7AAAC",
        "#A5B19D",
        "#B34534",
        "#F8E4D0",
        "#101517",
        "#768691",
        "#BD986A",
        "#9F2E23",
        "#EDD0AC",
        "#696A67",
        "#DFC39B",
        "#796331",
        "#A76131",
        "#3A2C1A",
        "#515036",
        "#93947E",
        "#31334D",
        "#8C8C94",
        "#AC4C41",
        "#F4C033",
        "#0B0607",
        "#5D798F",
        "#C8867E",
        "#DC7313",
        "#C17A7C",
        "#9AA9B5",
        "#4C7C8E",
        "#4F6B1D",
        "#7AA2BA",
        "#E6A826",
        "#0C0805",
        "#E4E7B5",
        "#AE5935",
        "#B9C07D",
        "#DA7316",
        "#C4441F"
    ];

    constructor() Owned(msg.sender) ERC721A("LucidOrigins", "LucidOrigins") { }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        uint16[] memory dna = getDna(uint256(keccak256(abi.encodePacked(tokenId))));

        string memory name = string(abi.encodePacked("LucidOrigins #", tokenId.toString()));
        string memory background = background(normalizeToRange(dna[Constants.BACKGROUND_INDEX], 0, 16));

        string memory layers = "";
        uint256 size = normalizeToRange(dna[Constants.SIZE_INDEX], 125, 135);
        for (uint256 i = 1; i <= 3; i++) {
            (string memory colorDefs, string memory fillColor) = resolveDefsAndFillColor(
                normalizeToRange(dna[Constants.COLOR1_INDEX] * i, 0, 71),
                normalizeToRange(dna[Constants.COLOR2_INDEX] * i, 0, 71),
                normalizeToRange(dna[Constants.BASE_INDEX] * i, 0, 100)
            );
            uint256 minGrowth = normalizeToRange(dna[Constants.MIN_GROWTH_INDEX] * i, 6, 9);
            uint256 edgesNum = normalizeToRange(dna[Constants.EDGES_NUM_INDEX] * i, 10, 15);
            string memory path1 = createSvgPath(createPoints(size, 50, 0, minGrowth, edgesNum));
            string memory path2 = createSvgPath(createPoints(size + 1, 50, 0, minGrowth, edgesNum));
            layers = string(abi.encodePacked(layers, build(i, colorDefs, fillColor, path1, path2)));
            unchecked {
                size = size - 30;
            }
        }
        string memory face = face(
            normalizeToRange(dna[Constants.EYE_RADIUS_INDEX], 7, 7),
            normalizeToRange(dna[Constants.EYE_BROW_LENGHT_INDEX], 2, 4),
            normalizeToRange(dna[Constants.EYE_SEPARATION_INDEX], 20, 25),
            normalizeToRange(dna[Constants.EYE_BROW_ROTATION_INDEX], 0, 20),
            normalizeToRange(dna[Constants.MOUNTH_ROTATION], 0, 6),
            normalizeToRange(dna[Constants.EYE_BROW_SIZE_INDEX], 1, 5)
        );
        string memory svgContent = string(abi.encodePacked(layers, face, blush()));
        uint256 rotation = normalizeToRange(dna[Constants.SIZE_INDEX], 0, 3);
        string memory svg = string(
            abi.encodePacked(
                '<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg" width="400" height="400">',
                background,
                rotationWrapper(rotation, svgContent),
                "</svg>"
            )
        );

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
            : string(
                abi.encodePacked(
                    "<defs>",
                    '<linearGradient id="linear-grad">',
                    '<stop offset="0" stop-color="',
                    '"',
                    colors[color1],
                    '"/>',
                    '<stop offset="1" stop-color="',
                    '"',
                    colors[color2],
                    '"/>',
                    "</linearGradient>",
                    "</defs>"
                )
            );

        string memory fillColor = isPlain ? colors[color1] : "url(#linear-grad)";

        return (colorDefs, fillColor);
    }
}
