// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import { ERC721A } from "ERC721A/ERC721A.sol";
import { Encoder } from "./Encoder.sol";

contract Blooby is ERC721A {
    using Encoder for string;

    constructor() ERC721A("Blooby", "BLOOBY") { }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        string memory name = string(abi.encodePacked("Blooby #", tokenId));
        string memory description = "Blooby, fully on-chain NFT";
        string memory svg =
            '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1000 1000"><circle cx={500} cy={500} r={400} fill="papayawhip" /></svg>';

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
}
