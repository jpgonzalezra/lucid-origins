// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

contract Background {
    error InvalidBackgroundDna();

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
        "#EFEFEF",
        "#F0E6E6",
        "#E6F0EE",
        "#F0E6F0",
        "#E6E6F0",
        "#F0EEDB"
    ];

    function background(uint256 dnaBgLayer) external view returns (string memory) {
        if (dnaBgLayer >= bgColors.length) {
            revert InvalidBackgroundDna();
        }
        return
            string(abi.encodePacked('<rect x="0" y="0" width="100" height="100" fill="', bgColors[dnaBgLayer], '"/>'));
    }
}
