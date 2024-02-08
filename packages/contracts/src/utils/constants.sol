// SPDX-License-Identifier: GNU GPLv3
pragma solidity 0.8.23;

library Constants {
    uint16 public constant X = 50;
    uint16 public constant Y = 0;

    uint16 public constant BACKGROUND_INDEX = 0;

    // FACE
    uint16 public constant EYE_RADIUS_INDEX = 1;
    uint16 public constant EYE_SEPARATION_INDEX = 3;
    uint16 public constant EYE_PUPIL_RADIUS_INDEX = 6;

    //HEAD
    uint16 public constant SIZE_INDEX = 7;
    uint16 public constant MIN_GROWTH_INDEX = 8;
    uint16 public constant EDGES_NUM_INDEX = 9;

    uint16 public constant BASE_INDEX = 10;

    uint16 public constant COLOR1_INDEX = 11;
    uint16 public constant COLOR2_INDEX = 12;
}
