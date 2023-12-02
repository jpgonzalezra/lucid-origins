// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

// import { console2 } from "forge-std/console2.sol";
import { String } from "../utils/String.sol";

contract Eyes {
    using String for uint256;
    using String for int256;

    error InvalidEyesDna();

    function eyes(
        uint256 size,
        uint256 dnaEyesLayer,
        uint256 randPositionX,
        uint256 randPositionY
    )
        external
        pure
        returns (string memory)
    {
        if (dnaEyesLayer >= 10) {
            revert InvalidEyesDna();
        }

        uint256 randNum = dnaEyesLayer * 10;
        (int256 positionX, int256 positionY) = generatePositions(randPositionX, randPositionY);

        if (randNum < 5) {
            return string(
                abi.encodePacked(
                    '<g id="eye" transform = "translate(50, 50)"><circle id="iris" cx="0" cy="0" r="',
                    size,
                    '" stroke="#000" stroke-width="2" fill="#fff"></circle><circle id="pupil" cx="',
                    positionX,
                    '" cy="',
                    positionY,
                    '" r="',
                    size / 2,
                    '" fill="#000"></circle></g>'
                )
            );
        } else {
            int256 pupilSize = calculatePupilSize(size, dnaEyesLayer);
            return string(
                abi.encodePacked(
                    '<g><g transform = "translate(38, 50)"><circle cx="0" cy="0" r="',
                    size.uint2str(),
                    '" stroke="#000" stroke-width="2" fill="#fff"></circle><circle cx="',
                    positionX.int2str(),
                    '" cy="',
                    positionY.int2str(),
                    '" r="',
                    pupilSize.int2str(),
                    '" fill="#000"></circle></g><g transform = "translate(58, 50)"><circle cx="0" cy="0" r="',
                    size.uint2str(),
                    '" stroke="#000" stroke-width="2" fill="#fff"></circle><circle cx="',
                    positionX.int2str(),
                    '" cy="',
                    positionY.int2str(),
                    '" r="',
                    pupilSize.int2str(),
                    '" fill="#000"></circle></g></g>'
                )
            );
        }
    }

    function generatePositions(uint256 randPositionX, uint256 randPositionY) internal pure returns (int256, int256) {
        int256 generatedX = int256(randPositionX % 5) - 2;
        int256 generatedY = int256(randPositionY % 5) - 2;
        return (generatedX, generatedY);
    }

    function calculatePupilSize(uint256 size, uint256 dnaEyesLayer) internal pure returns (int256) {
        return int256(dnaEyesLayer) * (int256(size) / 3 - 3) + 3;
    }
}
