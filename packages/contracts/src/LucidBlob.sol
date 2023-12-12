// SPDX-License-Identifier: GNU GPLv3
pragma solidity 0.8.21;

import { ERC721A } from "ERC721A/ERC721A.sol";
import { Encoder } from "./Encoder.sol";
import { Owned } from "solmate/auth/Owned.sol";
// import { console2 } from "forge-std/console2.sol";
import { Background } from "./layers/Background.sol";
import { Colors } from "./utils/Colors.sol";
import { Eyes } from "./layers/Eyes.sol";
import { Body } from "./layers/Body.sol";
import { String } from "./utils/String.sol";
import { Constants, DNA } from "./utils/constants.sol";

contract LucidBlob is Owned, ERC721A, Background, Eyes, Body, Colors {
    using Encoder for string;
    using String for string;
    using String for uint256;

    constructor() Owned(msg.sender) ERC721A("LucidBlob", "LucidBlob") { }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        DNA.Data memory dna = extractDNAData(getDna(uint256(keccak256(abi.encodePacked(tokenId)))));
        (string memory body, string memory blob, string memory blob2) = body(dna);
        return metadata(
            tokenId,
            string(
                abi.encodePacked(
                    string(
                        abi.encodePacked(
                            '<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg" width="400" height="400">'
                        )
                    ),
                    background(normalizeToRange(dna.backgroundIndex, 0, 16)),
                    body,
                    string(
                        abi.encodePacked(
                            '<path d="',
                            blob,
                            'Z" id="body-stroke" stroke="#000" stroke-width="2" fill="none" transform-origin="center"><animate attributeName="d" values="',
                            blob,
                            ";",
                            blob2,
                            ";",
                            blob,
                            '" dur="16s" id="stroke-anim" repeatCount="indefinite" begin="body-anim.begin + 1s" keysplines=".42 0 1 1; 0 0 .59 1; .42 0 1 1; 0 0 .59 1; .42 0 1 1; 0 0 .59 1; .42 0 1 1; 0 0 .59 1;"/><animateTransform attributeName="transform" type="rotate" from="0" to="360" dur="100" repeatCount="indefinite" /></path>'
                        )
                    ),
                    '<circle id="circle-blush" r="6" fill="rgba(255,255,255,0.4)" /><animateMotion href="#circle-blush" dur="30s" begin="0s" fill="freeze" repeatCount="indefinite" rotate="auto-reverse" ><mpath href="#body-stroke" /></animateMotion>',
                    eyes(dna),
                    "</svg>"
                )
            )
        );
    }

    function metadata(uint256 tokenId, string memory svg) internal pure returns (string memory) {
        string memory json = string(
            abi.encodePacked(
                '{"name":"',
                string(abi.encodePacked("LucidBlob #", tokenId.uint2str())),
                '","description":"',
                "LucidBlob, fully on-chain NFT",
                '","image": "data:image/svg+xml;base64,',
                Encoder.base64(bytes(svg)),
                '"}'
            )
        );
        return string(abi.encodePacked("data:application/json;base64,", Encoder.base64(bytes(json))));
    }

    function extractDNAData(uint16[] memory dna) internal pure returns (DNA.Data memory) {
        return DNA.Data({
            backgroundIndex: dna[Constants.BACKGROUND_INDEX],
            eyeSize: dna[Constants.EYE_SIZE_INDEX],
            eyeDnaLayer: dna[Constants.EYE_DNA_LAYER_INDEX],
            eyePositionX: dna[Constants.EYE_POSITION_X_INDEX],
            eyePositionY: dna[Constants.EYE_POSITION_Y_INDEX],
            blobSize: dna[Constants.BLOB_SIZE_INDEX],
            blobMinGrowth: dna[Constants.BLOB_MIN_GROWTH_INDEX],
            blobEdgesNum: dna[Constants.BLOB_EDGES_NUM_INDEX],
            bodyRgb: dna[Constants.BODY_RGB_INDEX]
        });
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
}
