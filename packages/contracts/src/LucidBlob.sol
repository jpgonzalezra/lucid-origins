// SPDX-License-Identifier: GNU GPLv3
pragma solidity 0.8.21;

import { ERC721A } from "ERC721A/ERC721A.sol";
import { Encoder } from "./Encoder.sol";
import { Owned } from "solmate/auth/Owned.sol";
import { console2 } from "forge-std/console2.sol";
import { Background } from "./layers/Background.sol";
import { Eyes } from "./layers/Eyes.sol";
import { Face } from "./layers/Face.sol";
import { Body } from "./layers/Body.sol";
import { Blob } from "./layers/Blob.sol";
import { Blush } from "./layers/Blush.sol";
import { String } from "./utils/String.sol";
import { Constants } from "./utils/constants.sol";

contract LucidBlob is Owned, ERC721A, Background, Face, Body, Blob, Blush {
    using Encoder for string;
    using String for string;
    using String for uint256;

    constructor() Owned(msg.sender) ERC721A("LucidBlob", "LucidBlob") { }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        uint16[] memory dna = getDna(uint256(keccak256(abi.encodePacked(tokenId))));

        string memory name = string(abi.encodePacked("LucidBlob #", tokenId.uint2str()));
        string memory header = '<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg" width="400" height="400">';

        uint256 r = normalizeToRange(dna[Constants.BODY_R_INDEX], 1, 255);
        uint256 g = normalizeToRange(dna[Constants.BODY_G_INDEX], 1, 255);
        uint256 b = normalizeToRange(dna[Constants.BODY_B_INDEX], 1, 255);

        uint256 r2 = normalizeToRange(dna[Constants.EYE_SIZE_INDEX], 1, 255);
        uint256 g2 = normalizeToRange(dna[Constants.EYE_POSITION_X_INDEX], 1, 255);
        uint256 b2 = normalizeToRange(dna[Constants.BLOB_MIN_GROWTH_INDEX], 1, 255);
        string memory linesColor = isColorDark(r, g, b) ? "#FFF" : "#000";

        string memory background = background(normalizeToRange(dna[Constants.BACKGROUND_INDEX], 0, 16));

        string memory face = face(
            normalizeToRange(dna[Constants.EYE_SIZE_INDEX], 4, 7),
            normalizeToRange(dna[Constants.EYE_DNA_LAYER_INDEX], 1, 4),
            normalizeToRange(dna[Constants.EYE_POSITION_X_INDEX], 20, 30),
            normalizeToRange(dna[Constants.EYE_POSITION_Y_INDEX], 0, 20),
            normalizeToRange(dna[Constants.BLOB_MIN_GROWTH_INDEX], 0, 6),
            normalizeToRange(dna[Constants.BLOB_EDGES_NUM_INDEX], 1, 5),
            linesColor
        );

        (string memory blob, string memory blob2) = blob(
            normalizeToRange(dna[Constants.BLOB_SIZE_INDEX], 85, 90),
            normalizeToRange(dna[Constants.BLOB_SIZE_INDEX], 1, 2),
            normalizeToRange(dna[Constants.BLOB_MIN_GROWTH_INDEX], 6, 8),
            normalizeToRange(dna[Constants.BLOB_EDGES_NUM_INDEX], 4, 12)
        );

        (string memory body, string memory stroke) = body(r, g, b, r2, g2, b2, blob, blob2);

        string memory footer = "</svg>";
        string memory svg = string(abi.encodePacked(header, background, body, stroke, blush(), face, footer));

        console2.log(svg);
        return metadata(name, svg);
    }

    function metadata(string memory name, string memory svg) internal pure returns (string memory) {
        string memory description = "LucidBlob, fully on-chain NFT";
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
}
