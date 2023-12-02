// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

interface ILayer {
    function generate(uint256 dnaLayer) external view returns (string memory);
}
