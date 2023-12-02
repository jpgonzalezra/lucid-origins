// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import { ILayer } from "../interfaces/ILayer.sol";
import { Colors } from "../utils/Colors.sol";

contract Background is ILayer, Colors {
    string[] bgColors = [
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
        "#EFEFEF"
    ];

    function generate(uint256 dnaBgLayer) external view returns (string memory) {
        string memory color = bgColors[dnaBgLayer % bgColors.length];
        return string(abi.encodePacked('<rect x="0" y="0" width="100" height="100" fill="', color, '"/>'));
    }
}
