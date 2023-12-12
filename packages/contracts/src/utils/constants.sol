// SPDX-License-Identifier: GNU GPLv3
pragma solidity 0.8.21;

library Constants {
    uint256 public constant BACKGROUND_INDEX = 0;

    uint256 public constant EYE_SIZE_INDEX = 1;
    uint256 public constant EYE_DNA_LAYER_INDEX = 2;
    uint256 public constant EYE_POSITION_X_INDEX = 3;
    uint256 public constant EYE_POSITION_Y_INDEX = 4;

    uint256 public constant BLOB_SIZE_INDEX = 5;
    uint256 public constant BLOB_MIN_GROWTH_INDEX = 6;
    uint256 public constant BLOB_EDGES_NUM_INDEX = 7;

    uint256 public constant BODY_RGB_INDEX = 8;
}

library DNA {
    struct Data {
        uint16 backgroundIndex;
        uint16 eyeSize;
        uint16 eyeDnaLayer;
        uint16 eyePositionX;
        uint16 eyePositionY;
        uint16 blobSize;
        uint16 blobMinGrowth;
        uint16 blobEdgesNum;
        uint16 bodyRgb;
    }
}
