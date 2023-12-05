// SPDX-License-Identifier: GNU GPLv3
pragma solidity 0.8.21;

import { ERC721A } from "ERC721A/ERC721A.sol";
import { Encoder } from "./Encoder.sol";
import { Owned } from "solmate/auth/Owned.sol";
// import { console2 } from "forge-std/console2.sol";
import { Background } from "./layers/Background.sol";
import { Colors } from "./utils/Colors.sol";
import { Eyes } from "./layers/Eyes.sol";
import { Blob } from "./layers/Blob.sol";

contract Blobby is Owned, ERC721A, Background, Eyes, Blob, Colors {
    using Encoder for string;

    constructor() Owned(msg.sender) ERC721A("Blobby", "BLOBBY") { }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        string memory name = string(abi.encodePacked("Blobby #", tokenId));
        string memory description = "Blobby, fully on-chain NFT";
        string memory header =
            '<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg" width="400" height="400">\n';

        string memory background = this.background(10);
        string memory eyes = this.eyes(9, 3, 2, 5);
        string memory blob = this.blob(105, 5, 6);
        string memory body = string(
            abi.encodePacked('<path stroke="transparent" stroke-width="0" fill = "', colors[5], '" d="', blob, 'Z" />')
        );
        string memory stroke = string(
            abi.encodePacked(
                '<path transform="translate(-3, -3)" stroke="#000" stroke-width="2" fill = "none" d="', blob, '" />'
            )
        );
        string memory blush = string(
            abi.encodePacked(
                '<g><circle  transform = "translate(70, 65)" cx="0" cy="0" r="6" fill="rgba(255,255,255,0.4)" ></circle><circle  transform = "translate(30, 65)" cx="0" cy="0" r="6" fill="rgba(255,255,255,0.4)"></circle></g>'
            )
        );
        string memory footer = "</svg>";

        string memory svg = string(abi.encodePacked(header, background, body, blush, stroke, eyes, footer));

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
                // Encoder.base64(bytes(svg)),
                svg,
                '"}'
            )
        );
        // return string(abi.encodePacked("data:application/json;base64,", Encoder.base64(bytes(json))));
        return string(abi.encodePacked("data:application/json;base64,", json));
    }
}
