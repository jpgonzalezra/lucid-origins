// SPDX-License-Identifier: GNU GPLv3
pragma solidity 0.8.21;

// import { console2 } from "forge-std/console2.sol";

contract Background {
    string[20] internal bgColors = [
        "#FAF4EF",
        "#EFFAEF",
        "#EFF4FA",
        "#FAEFFA",
        "#EFF4FA",
        "#F4EFFA",
        "#FAFAEF",
        "#FAEFF4",
        "#EFFAFA",
        "#EFF7EB",
        "#DBDBDB",
        "#EDF1F7",
        "#EFF7EB",
        "#F7F7E9",
        "#EFEFEF",
        "#F0E6E6",
        "#E6F0EE",
        "#F0E6F0",
        "#E6E6F0",
        "#F0EEDB"
    ];

    function background(uint256 dnaBgLayer) internal view returns (string memory) {
        return
                
            string(abi.encodePacked('<defs><pattern id="star" fill="', bgColors[dnaBgLayer], '" viewBox="0,0,10,10" width="10%" height="10%"><polygon points="0,0 2,5 0,10 5,8 10,10 8,5 10,0 5,2" /></pattern></defs>','<rect x="0" y="0" width="100" height="100" fill="url(#star)"/>'));
    }
}
