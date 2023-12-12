// SPDX-License-Identifier: GNU GPLv3
pragma solidity 0.8.21;

import { Constants, DNA } from "../utils/constants.sol";
import { Blob } from "./Blob.sol";

contract Body is Blob {
    function body(DNA.Data memory dna) internal view returns (string memory, string memory, string memory) {
        (string memory blob, string memory blob2) = blob(dna);
        uint256 rgb = normalizeToRange(dna.bodyRgb, 1, 255);
        return (
            string(
                abi.encodePacked(
                    '<path d="',
                    blob,
                    'Z" transform-origin="center" fill="',
                    "rgba(",
                    rgb,
                    ",",
                    rgb,
                    ",",
                    rgb,
                    ")",
                    '">',
                    '<animate attributeName="d" values="',
                    blob,
                    ";",
                    blob2,
                    ";",
                    blob,
                    '" dur="15s" id="body-anim" repeatCount="indefinite"',
                    ' keysplines=".42 0 1 1; 0 0 .59 1; .42 0 1 1; 0 0 .59 1;',
                    ' .42 0 1 1; 0 0 .59 1; .42 0 1 1; 0 0 .59 1;"/>',
                    '<animateTransform attributeName="transform" type="rotate" ',
                    'from="0" to="360" dur="100" repeatCount="indefinite" />',
                    "</path>"
                )
                ),
            blob,
            blob2
        );
    }
}
