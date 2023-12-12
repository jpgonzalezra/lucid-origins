// SPDX-License-Identifier: GNU GPLv3
pragma solidity 0.8.21;

// import { console2 } from "forge-std/console2.sol";
import { String } from "../utils/String.sol";
import { DNA } from "../utils/constants.sol";

contract Eyes {
    using String for uint256;
    using String for int256;

    function eyes(DNA.Data memory dna) internal pure returns (string memory) {
        uint256 size = normalizeToRange2(dna.eyeSize, 9, 13);
        uint256 dnaEyesLayer = normalizeToRange2(dna.eyeDnaLayer, 0, 9);
        uint256 randPositionX = normalizeToRange2(dna.eyePositionX, 2, 8);
        uint256 randPositionY = normalizeToRange2(dna.eyePositionY, 2, 8);
        (int256 positionX, int256 positionY) = generatePositions(randPositionX, randPositionY);
        if (dnaEyesLayer < 5) {
            return string(
                abi.encodePacked(
                    '<g id="eye" transform = "translate(50, 50)"><circle id="iris" cx="0" cy="0" r="',
                    size.uint2str(),
                    '" stroke="#000" stroke-width="2" fill="#fff"></circle><circle id="pupil" cx="',
                    positionX.int2str(),
                    '" cy="',
                    positionY.int2str(),
                    '" r="',
                    (size / 2).uint2str(),
                    '" fill="#000"></circle></g>'
                )
            );
        } else {
            uint256 scaledDnaEyesLayer = (dnaEyesLayer * 100) / 10;
            uint256 pupilSize = calculatePupilSize(size, scaledDnaEyesLayer);
            return string(
                abi.encodePacked(
                    '<g><g transform = "translate(38, 50)"><circle cx="0" cy="0" r="',
                    size.uint2str(),
                    '" stroke="#000" stroke-width="2" fill="#fff"></circle><circle cx="',
                    positionX.int2str(),
                    '" cy="',
                    positionY.int2str(),
                    '" r="',
                    pupilSize.uint2str(),
                    '" fill="#000"></circle></g><g transform = "translate(58, 50)"><circle cx="0" cy="0" r="',
                    size.uint2str(),
                    '" stroke="#000" stroke-width="2" fill="#fff"></circle><circle cx="',
                    positionX.int2str(),
                    '" cy="',
                    positionY.int2str(),
                    '" r="',
                    pupilSize.uint2str(),
                    '" fill="#000"></circle></g></g>'
                )
            );
        }
    }

    function normalizeToRange2(uint256 value, uint256 minRange, uint256 maxRange) internal pure returns (uint8) {
        require(minRange <= maxRange, "invalid Min/Max range");
        uint256 adjustedRange = maxRange - minRange + 1;
        return uint8(minRange + (value % adjustedRange));
    }

    function generatePositions(uint256 randPositionX, uint256 randPositionY) internal pure returns (int256, int256) {
        int256 generatedX = int256(randPositionX % 5) - 2;
        int256 generatedY = int256(randPositionY % 5) - 2;
        return (generatedX, generatedY);
    }

    function calculatePupilSize(uint256 size, uint256 dnaEyesLayer) internal pure returns (uint256) {
        uint256 minValue = 3 * 100;
        uint256 maxValue = (size / 3) * 100;

        uint256 scaledRandom = (dnaEyesLayer * (maxValue - minValue) / 100) + minValue;

        return (scaledRandom + 100 / 2) / 100;
    }
}
