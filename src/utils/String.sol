// SPDX-License-Identifier: GNU GPLv3
pragma solidity 0.8.21;

library String {
    function uint2str(uint256 _i) internal pure returns (string memory) {
        if (_i == 0) {
            return "0";
        }
        uint256 j = _i;
        uint256 len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint256 k = len;
        while (_i != 0) {
            k = k - 1;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }

    function int2str(int256 _i) internal pure returns (string memory) {
        if (_i >= 0) {
            return uint2str(uint256(_i));
        } else {
            return string(abi.encodePacked("-", uint2str(uint256(-_i))));
        }
    }

    function str2uint(string memory _str) internal pure returns (uint256 res) {
        for (uint256 i = 0; i < bytes(_str).length; i++) {
            if ((uint8(bytes(_str)[i]) - 48) < 0 || (uint8(bytes(_str)[i]) - 48) > 9) {
                return 0;
            }
            res += (uint8(bytes(_str)[i]) - 48) * 10 ** (bytes(_str).length - i - 1);
        }

        return res;
    }
}
