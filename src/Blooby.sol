// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import { ERC721A } from "ERC721A/ERC721A.sol";
import { Encoder } from "./Encoder.sol";
import { Owned } from "solmate/auth/Owned.sol";
import { ILayer } from "./interfaces/ILayer.sol";
import { console2 } from "forge-std/console2.sol";

contract Blooby is Owned, ERC721A {
    using Encoder for string;

    error InitItemsMismatch();

    // 0 => background
    // 1 => body
    // 2 => stroke
    // 3 => blush
    // 4 => eyes
    mapping(uint16 => address) public itemById;
    uint16[] public itemIds;

    constructor(
        uint16[] memory _itemIds,
        address[] memory _itemAddresses
    )
        Owned(msg.sender)
        ERC721A("Blooby", "BLOOBY")
    {
        if (_itemIds.length != _itemAddresses.length) {
            revert InitItemsMismatch();
        }
        for (uint256 i = 0; i < _itemIds.length; i++) {
            itemById[_itemIds[i]] = _itemAddresses[i];
        }

        itemIds = _itemIds;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        string memory name = string(abi.encodePacked("Blooby #", tokenId));
        string memory description = "Blooby, fully on-chain NFT";
        string memory header =
            '<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg" width="400" height="400">\n';
        string memory svg = header;

        for (uint256 i = 0; i < itemIds.length; i++) {
            address itemAddress = itemById[itemIds[i]];
            ILayer layer = ILayer(itemAddress);
            string memory itemSvg = layer.generate(8);
            svg = string(abi.encodePacked(svg, itemSvg));
        }

        string memory footer = "</svg>";
        svg = string(abi.encodePacked(svg, footer));

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
