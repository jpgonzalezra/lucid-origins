// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import { ILayer } from "../interfaces/ILayer.sol";

contract Background is ILayer {
    function generate(uint256 dnaLayer) external view override returns (string memory) {
        return "<svg>...</svg>";
    }
}
