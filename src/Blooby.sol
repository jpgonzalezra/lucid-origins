// SPDX-License-Identifier: GNU GPLv3
pragma solidity 0.8.21;

import { ERC721A } from "ERC721A/ERC721A.sol";
import { Encoder } from "./Encoder.sol";
import { Owned } from "solmate/auth/Owned.sol";
// import { console2 } from "forge-std/console2.sol";
import { Background } from "./layers/Background.sol";
import { Eyes } from "./layers/Eyes.sol";
import { Blob } from "./layers/Blob.sol";

contract Blooby is Owned, ERC721A, Background, Eyes, Blob {
    using Encoder for string;

    error InitItemsMismatch();

    constructor() Owned(msg.sender) ERC721A("Blooby", "BLOOBY") { }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        string memory name = string(abi.encodePacked("Blooby #", tokenId));
        string memory description = "Blooby, fully on-chain NFT";
        string memory header =
            '<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg" width="400" height="400">\n';

        string memory background = this.background(10);
        string memory eyes = this.eyes(9, 8, 5, 4);

        string memory bloob = this.blob(105, 5, 8, 8);
        string memory footer = "</svg>";

        string memory svg = string(abi.encodePacked(header, background, bloob, eyes, footer));

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
