// SPDX-License-Identifier: GNU GPLv3
pragma solidity 0.8.21;

import { ERC721A } from "ERC721A/ERC721A.sol";
import { Encoder } from "./Encoder.sol";
import { Owned } from "solmate/auth/Owned.sol";
import { console2 } from "forge-std/console2.sol";
import { Background } from "./layers/Background.sol";
import { Colors } from "./utils/Colors.sol";
import { Eyes } from "./layers/Eyes.sol";
import { Blob } from "./layers/Blob.sol";
import { String } from "./utils/String.sol";

contract LucidBlob is Owned, ERC721A, Background, Eyes, Blob, Colors {
    using Encoder for string;
    using String for string;
    using String for uint256;

    constructor() Owned(msg.sender) ERC721A("LucidBlob", "LucidBlob") { }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        uint16[] memory dna = getDna(uint256(keccak256(abi.encodePacked(tokenId))));

        string memory name = string(abi.encodePacked("LucidBlob #", tokenId.uint2str()));
        string memory description = "LucidBlob, fully on-chain NFT";
        string memory header = '<svg viewBox="0 0 100 100"',
            'xmlns="http://www.w3.org/2000/svg" width="400" height="400">';

        string memory background = background(normalizeToRange(dna[0], 0, 19));
        string memory eyes = eyes(
            normalizeToRange(dna[1], 9, 13),
            normalizeToRange(dna[2], 0, 9),
            normalizeToRange(dna[3], 2, 8),
            normalizeToRange(dna[4], 2, 8)
        );

        (string memory blob, string memory blob2) = blob(
            normalizeToRange(dna[5], 95, 105),
            normalizeToRange(dna[5], 1, 2),
            normalizeToRange(dna[6], 5, 9),
            normalizeToRange(dna[7], 6, 9)
        );
        string memory body = string(
            abi.encodePacked(
                '<path d="',
                blob,
                'Z" fill="',
                colors[normalizeToRange(dna[7], 0, colors.length)],
                '">',
                '<animate attributeName="d" values="',
                blob,
                ";",
                blob2,
                ";",
                blob,
                '" dur="5s" repeatCount="indefinite"/>',
                "</path>"
            )
        );

        string memory stroke = string(
            abi.encodePacked(
                '<path d="',
                blob,
                'Z" stroke="#000" stroke-width="2" fill="none">',
                '<animate attributeName="d" values="',
                blob,
                ";",
                blob2,
                ";",
                blob,
                '" dur="5s" repeatCount="indefinite"/>',
                "</path>"
            )
        );
        string memory blush = string(
            abi.encodePacked(
                "<g>",
                '<circle  transform = "translate(70, 65)" cx="0" cy="0" r="6" fill="rgba(255,255,255,0.4)" ></circle><circle  transform = "translate(30, 65)" cx="0" cy="0" r="6" fill="rgba(255,255,255,0.4)"></circle>',
                "</g>"
            )
        );
        string memory footer = "</svg>";
        string memory svg = string(abi.encodePacked(header, background, body, stroke, blush, eyes, footer));

        console2.log(svg);
        return metadata(name, description, svg);
    }

    function metadata(
        string memory name,
        string memory desciption,
        string memory svg
    )
        internal
        pure
        returns (string memory)
    {
        string memory json = string(
            abi.encodePacked(
                '{"name":"',
                name,
                '","description":"',
                desciption,
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

    function normalizeToRange(uint256 value, uint256 minRange, uint256 maxRange) internal pure returns (uint8) {
        require(minRange <= maxRange, "invalid Min/Max range");
        uint256 adjustedRange = maxRange - minRange + 1;
        return uint8(minRange + (value % adjustedRange));
    }
}
