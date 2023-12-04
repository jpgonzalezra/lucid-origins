// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

library MathLibrary {
    //=== add two floating points. Input and output are all unsigned integers
    function addFloat(
        string memory _str1,
        string memory _str2
    )
        public
        pure
        returns (uint256 wp, uint256 dp, string memory _str)
    {
        uint256 wp1;
        uint256 dp1;
        uint256 wp2;
        uint256 dp2;
        bool isUint;

        string memory str1;
        string memory str2;

        if (bytes(_str1)[0] == "-" && bytes(_str2)[0] == "-") {
            str1 = substring(_str1, 1, lengthOfString(_str1));
            str2 = substring(_str2, 1, lengthOfString(_str2));

            (str1, str2) = normalizeNumbers(str1, str2);
        } else {
            (str1, str2) = normalizeNumbers(_str1, _str2);
        }

        (wp1, dp1) = splitDecimalStringToIntegers(str1);
        (wp2, dp2) = splitDecimalStringToIntegers(str2);

        dp = dp1 + dp2;

        if (bytes(uintToString(dp))[1] != "0") {
            wp = wp1 + wp2 + 1;
        } else {
            wp = wp1 + wp2;
        }

        if (bytes(_str1)[0] == "-" && bytes(_str2)[0] == "-") {
            _str = string(
                abi.encodePacked(
                    "-",
                    uintToString(wp),
                    ".",
                    substring(string(bytes(uintToString(dp))), 2, bytes(uintToString(dp)).length)
                )
            );
        } else {
            _str = string(
                abi.encodePacked(
                    uintToString(wp), ".", substring(string(bytes(uintToString(dp))), 2, bytes(uintToString(dp)).length)
                )
            );
        }

        (dp, isUint) = strToUint(substring(string(bytes(uintToString(dp))), 2, bytes(uintToString(dp)).length));
    }

    //=== substraction with two floating points. Input and output are all unsigned integers
    function subFloat(
        string memory _str1,
        string memory _str2
    )
        public
        pure
        returns (uint256 wp, uint256 dp, string memory _str)
    {
        uint256 wp1;
        uint256 dp1;
        uint256 wp2;
        uint256 dp2;
        uint256 num1;
        uint256 num2;
        bool isUint;

        string memory str1;
        string memory str2;

        (str1, str2) = normalizeNumbers(_str1, _str2);

        (num1, num2) = removeDotAndNormalize(str1, str2);

        if (num1 == num2) {
            wp = 0;
            dp = 0;
            _str = "0.0";
        } else if (num1 > num2) {
            (wp1, dp1) = splitDecimalStringToIntegers(str1);
            (wp2, dp2) = splitDecimalStringToIntegers(str2);

            dp = dp1 - dp2;

            if (bytes(uintToString(dp))[1] != "0") {
                wp = wp1 - wp2 - 1;
            } else {
                wp = wp1 - wp2;
            }

            _str = string(
                abi.encodePacked(
                    uintToString(wp), ".", substring(string(bytes(uintToString(dp))), 2, bytes(uintToString(dp)).length)
                )
            );
            (dp, isUint) = strToUint(substring(string(bytes(uintToString(dp))), 2, bytes(uintToString(dp)).length));
        } else {
            (wp1, dp1) = splitDecimalStringToIntegers(str1);
            (wp2, dp2) = splitDecimalStringToIntegers(str2);

            dp = dp2 - dp1;

            if (bytes(uintToString(dp))[1] != "0") {
                wp = wp2 - wp1 - 1;
            } else {
                wp = wp2 - wp1;
            }

            _str = string(
                abi.encodePacked(
                    "-",
                    uintToString(wp),
                    ".",
                    substring(string(bytes(uintToString(dp))), 2, bytes(uintToString(dp)).length)
                )
            );
            (dp, isUint) = strToUint(substring(string(bytes(uintToString(dp))), 2, bytes(uintToString(dp)).length));
        }
    }

    //=== Multiplication of two floating points. Input and output are all unsigned integers
    function mulFloat(
        string memory _str1,
        string memory _str2
    )
        public
        pure
        returns (uint256 wp, uint256 dp, string memory _str)
    {
        string memory wpStr1;
        string memory dpStr1;
        string memory wpStr2;
        string memory dpStr2;
        string memory sign1;
        string memory sign2;

        (wpStr1, dpStr1) = splitstring(_str1);
        (wpStr2, dpStr2) = splitstring(_str2);

        if (bytes(wpStr1)[0] == "-") {
            wpStr1 = substring(wpStr1, 1, lengthOfString(wpStr1));
            sign1 = "-";
            _str1 = substring(_str1, 1, lengthOfString(_str1));
        } else {
            sign1 = "+";
        }

        if (bytes(wpStr2)[0] == "-") {
            wpStr2 = substring(wpStr2, 1, lengthOfString(wpStr2));
            sign2 = "-";
            _str2 = substring(_str2, 1, lengthOfString(_str2));
        } else {
            sign2 = "+";
        }

        if (
            (strToUintV2(wpStr1) == 0 && strToUintV2(dpStr1) == 0)
                || (strToUintV2(wpStr2) == 0 && strToUintV2(dpStr2) == 0)
        ) {
            wp = 0;
            dp = 0;
            _str = string(abi.encodePacked("0", ".", "0"));
        } else {
            wp = removeDot(_str1); // if _str1 = "3.14" => wp = 314 and _str1 = 0.01 => wp = 1
            dp = removeDot(_str2); // if _str2 = "3.14" => dp = 314 and _str2 = 0.10 => dp = 10

            _str = uintToString(wp * dp);

            wp = (lengthOfString(_str1) - 1) - lengthOfUint(wp); // returns the number of zeros lost in wp => _str1
            dp = (lengthOfString(_str2) - 1) - lengthOfUint(dp); // returns the number of zeros lost in dp => _str2

            if ((wp + dp) != 0) {
                for (uint256 i = 0; i < (wp + dp); i++) {
                    _str = string(abi.encodePacked("0", _str));
                }
            }

            wp = strToUintV2(
                substring(_str, 0, lengthOfString(_str) - (lengthOfString(dpStr1) + lengthOfString(dpStr2)))
            );
            dp = strToUintV2(
                substring(
                    _str, lengthOfString(_str) - (lengthOfString(dpStr1) + lengthOfString(dpStr2)), lengthOfString(_str)
                )
            );

            if (
                (bytes(sign1)[0] == "+" && bytes(sign2)[0] == "+") || (bytes(sign1)[0] == "-" && bytes(sign2)[0] == "-")
            ) {
                //_str = string(abi.encodePacked(uintToString(wp), ".", uintToString(dp)));
                _str = string(
                    abi.encodePacked(
                        substring(_str, 0, lengthOfString(_str) - (lengthOfString(dpStr1) + lengthOfString(dpStr2))),
                        ".",
                        substring(
                            _str,
                            lengthOfString(_str) - (lengthOfString(dpStr1) + lengthOfString(dpStr2)),
                            lengthOfString(_str)
                        )
                    )
                );
            } else if (
                (bytes(sign1)[0] == "+" && bytes(sign2)[0] == "-") || (bytes(sign1)[0] == "-" && bytes(sign2)[0] == "+")
            ) {
                //_str = string(abi.encodePacked("-", uintToString(wp), ".", uintToString(dp)));
                _str = string(
                    abi.encodePacked(
                        "-",
                        substring(_str, 0, lengthOfString(_str) - (lengthOfString(dpStr1) + lengthOfString(dpStr2))),
                        ".",
                        substring(
                            _str,
                            lengthOfString(_str) - (lengthOfString(dpStr1) + lengthOfString(dpStr2)),
                            lengthOfString(_str)
                        )
                    )
                );
            }
        }
    }

    //=== Division of two floating points. Input and output are all unsigned integers
    function divFloat(
        string memory _str1,
        string memory _str2
    )
        public
        pure
        returns (uint256 wp, uint256 dp, string memory _str)
    {
        string memory wpStr1;
        string memory dpStr1;
        string memory wpStr2;
        string memory dpStr2;
        uint256 sign1;
        uint256 sign2;
        //string memory sign;

        (wpStr1, dpStr1) = splitstring(_str1);
        (wpStr2, dpStr2) = splitstring(_str2);

        if (bytes(wpStr1)[0] == "-") {
            wpStr1 = substring(wpStr1, 1, lengthOfString(wpStr1));
            _str1 = substring(_str1, 1, lengthOfString(_str1));
            sign1 = 1;
        }

        if (bytes(wpStr2)[0] == "-") {
            wpStr2 = substring(wpStr2, 1, lengthOfString(wpStr2));
            _str2 = substring(_str2, 1, lengthOfString(_str2));
            sign2 = 1;
        }

        wp = removeDot(_str1); // uint obtained by removing the dot in numerator
        dp = removeDot(_str2); // uint obtained by removing the dot in the denominator

        require(dp != 0, "Cannot divide by zero");

        wp = wp * 10 ** (30) * 10 ** (lengthOfString(dpStr2)) * 10 ** (lengthOfUint(dp))
            / (dp * 10 ** (lengthOfString(dpStr1)));
        _str = uintToString(wp);

        if (lengthOfString(_str) <= 30 + lengthOfUint(dp)) {
            _str = paddLeft(_str, "0", (30 + lengthOfUint(dp) - lengthOfString(_str) + 1));
        }

        if ((sign1 == 0 && sign2 == 0) || (sign1 == 1 && sign2 == 1)) {
            _str = string(
                abi.encodePacked(
                    substring(_str, 0, lengthOfString(_str) - (30 + lengthOfUint(dp))),
                    ".",
                    substring(_str, lengthOfString(_str) - (30 + lengthOfUint(dp)), lengthOfString(_str))
                )
            );
        } else {
            _str = string(
                abi.encodePacked(
                    "-",
                    substring(_str, 0, lengthOfString(_str) - (30 + lengthOfUint(dp))),
                    ".",
                    substring(_str, lengthOfString(_str) - (30 + lengthOfUint(dp)), lengthOfString(_str))
                )
            );
        }
    }

    //==== Logarithm of a floating point
    function log(string memory _str) public pure returns (uint256 wp, uint256 dp, string memory str) {
        (wp, dp, str) = toPowerOf("10.0", 2);
        (wp, dp, str) = toPowerOf(_str, wp);
        (wp, dp, str) = divFloat("1.0", str);
        (wp, dp, str) = subFloat(str, "1.0");
        (wp, dp, str) = mulFloat(str, "100");
    }

    //==== Power root of a floating point number. Input and output are all unsigned integers
    function toPowerOf(
        string memory _str,
        uint256 _powerRoot
    )
        public
        pure
        returns (uint256 wp, uint256 dp, string memory str)
    {
        if (_powerRoot == 0) {
            str = "1.0";
        } else {
            str = _str;
            for (uint256 i = 1; i < _powerRoot; i++) {
                (wp, dp, str) = mulFloat(_str, str);
            }
        }
    }

    //=== Find the Fibonacci number
    function fibonacci(uint256 _n) public pure returns (string memory str) {
        if (_n == 0) {
            str = "0.0";
        } else if (_n == 1) {
            str = "1.0";
        } else {
            (,, str) = addFloat(fibonacci(_n - 1), fibonacci(_n - 2));
        }
    }

    // Factorial
    function factorial(uint256 _n) public pure returns (uint256 n) {
        if (_n == 0) {
            n = 1;
        } else {
            n = _n * factorial(_n - 1);
        }
    }

    //=== Calculate (x^n / n!)
    function expoSerie(string memory _s, uint256 _n) public pure returns (string memory str) {
        (,, str) = toPowerOf(_s, _n);
        (,, str) = divFloat(str, string(abi.encodePacked(uintToString(factorial(_n)), ".0")));
    }

    //=== Calculate 1 / (2n + 1) * [(x -1) / (x + 1)]^(2n + 1)
    function logSerie(string memory _x, uint256 _n) public pure returns (string memory str) {
        string memory str1;
        string memory str2;

        (,, str1) = subFloat(_x, "1.0");
        (,, str2) = addFloat(_x, "1.0");
        (,, str) = divFloat(str1, str2);
        (,, str) = toPowerOf(str, 2 * _n + 1);

        str2 = string(abi.encodePacked(uintToString(_n), ".0"));
        (,, str1) = mulFloat("2.0", str2);
        (,, str1) = addFloat(str1, "1.0");

        (,, str) = divFloat(str, str1);
    }

    //=== Exponential
    function exp(string memory _str) public pure returns (string memory str) {
        uint256 N = 12;
        string memory strTemp = "0.0";

        for (uint256 i = 1; i <= N; i++) {
            (,, strTemp) = addFloat(strTemp, expoSerie(_str, i));
        }

        (,, str) = addFloat(strTemp, "1.0");
    }

    /**
     * @notice This function calculate b^x
     * @param _b number: uinsigned integer
     * @param _x power root: string
     */
    function powerRoot(uint256 _b, string memory _x) public pure returns (string memory str) {
        string memory str1;
        string memory str2;
        uint256 wp;
        uint256 dp;
        uint256 len;
        uint256 w;
        uint256 res;

        (str1, str2) = splitstring(_x);
        (wp, dp) = splitDecimalStringToIntegers(_x);
        len = lengthOfString(str2);

        w = _b ** wp;

        str = string(abi.encodePacked(uintToString(_b), ".0"));
        (,, str) = toPowerOf(str, dp);

        (wp, dp) = splitDecimalStringToIntegers(str);

        wp = nthRoot(wp, 10 ** len, 6, 15);
        res = w * wp;

        str = uintToString(res);
        str = string(abi.encodePacked(bytes(str)[0], ".", substring(str, 1, lengthOfString(str) - 1)));
    }

    //=== Nth root
    function nthRoot(uint256 _a, uint256 _n, uint256 _dp, uint256 _maxIts) public pure returns (uint256) {
        assert(_n > 1);

        // The scale factor is a crude way to turn everything into integer calcs.
        // Actually do (a * (10 ^ ((dp + 1) * n))) ^ (1/n)
        // We calculate to one extra dp and round at the end
        uint256 one = 10 ** (1 + _dp);
        uint256 a0 = one ** _n * _a;

        // Initial guess: 1.0
        uint256 xNew = one;

        uint256 iter = 0;
        while (xNew != a0 && iter < _maxIts) {
            uint256 x = xNew;
            uint256 t0 = x ** (_n - 1);
            if (x * t0 > a0) {
                xNew = x - (x - a0 / t0) / _n;
            } else {
                xNew = x + (a0 / t0 - x) / _n;
            }
            ++iter;
        }

        // Round to nearest in the last dp.
        return (xNew + 5) / 10;
    }

    //=== Find the length of an unsigned integer
    function lengthOfUint(uint256 _num) internal pure returns (uint256 length) {
        while (_num != 0) {
            length++;
            _num /= 10;
        }
    }

    //=== Find the number of bytes in a string
    function lengthOfString(string memory _str) internal pure returns (uint256) {
        return bytes(_str).length;
    }

    //=== Return the maximum number
    function max(uint256 _num1, uint256 _num2) internal pure returns (uint256 maxNumber) {
        _num1 >= _num2 ? maxNumber = _num1 : maxNumber = _num2;
    }

    //=== Separates decimal number (string) to whole number (string) and decimal parts (string)
    function splitstring(string memory _str) internal pure returns (string memory, string memory) {
        uint256 n = bytes(_str).length;

        uint256 limit;

        for (uint256 i = 0; i < n; i++) {
            if (keccak256(abi.encodePacked(bytes(_str)[i])) == keccak256(abi.encodePacked(bytes(".")))) {
                limit = i;
            }
        }

        bytes memory wholeNumberPart = new bytes(limit);
        bytes memory decimalPart = new bytes(n - limit - 1);

        for (uint256 i = 0; i < n; i++) {
            if (i < limit) {
                wholeNumberPart[i] = bytes(_str)[i];
            }

            if (i > limit) {
                decimalPart[i - limit - 1] = bytes(_str)[i];
            }
        }

        return (string(wholeNumberPart), string(decimalPart));
    }

    //=== extract part of string starting at _startIndex and ending at _endIndex
    function substring(
        string memory _str,
        uint256 _startIndex,
        uint256 _endIndex
    )
        internal
        pure
        returns (string memory)
    {
        bytes memory result = new bytes(_endIndex - _startIndex);

        for (uint256 i = _startIndex; i < _endIndex; i++) {
            result[i - _startIndex] = bytes(_str)[i];
        }

        return string(result);
    }

    //=== Convert a string to a uint with error handling
    function strToUint(string memory _str) internal pure returns (uint256 res, bool err) {
        for (uint256 i = 0; i < bytes(_str).length; i++) {
            if ((uint8(bytes(_str)[i]) - 48) < 0 || (uint8(bytes(_str)[i]) - 48) > 9) {
                return (0, false);
            }
            res += (uint8(bytes(_str)[i]) - 48) * 10 ** (bytes(_str).length - i - 1);
        }

        return (res, true);
    }

    //=== Convert a string to a uint without error handling
    function strToUintV2(string memory _str) public pure returns (uint256 res) {
        for (uint256 i = 0; i < bytes(_str).length; i++) {
            if ((uint8(bytes(_str)[i]) - 48) < 0 || (uint8(bytes(_str)[i]) - 48) > 9) {
                return 0;
            }
            res += (uint8(bytes(_str)[i]) - 48) * 10 ** (bytes(_str).length - i - 1);
        }

        return res;
    }

    function splitDecimalStringToIntegers(string memory _str) internal pure returns (uint256 wp, uint256 dp) {
        bool wpBool;
        bool dpBool;
        string memory wholeNumberPart;
        string memory decimalPart;

        (wholeNumberPart, decimalPart) = splitstring(_str);

        (wp, wpBool) = strToUint(wholeNumberPart);
        (dp, dpBool) = strToUint(decimalPart);

        return (wp, dp);
    }

    //=== Separates decimal number (string) to whole number (uint) and decimal (uint) parts
    function uintToString(uint256 _i) internal pure returns (string memory str) {
        if (_i == 0) return "0";

        uint256 j = _i;
        uint256 length;

        length = lengthOfUint(j);

        bytes memory bstr = new bytes(length);
        uint256 k = length;
        j = _i;

        while (j != 0) {
            bstr[--k] = bytes1(uint8(48 + (j % 10)));
            j /= 10;
        }

        str = string(bstr);

        return str;
    }

    // Add 10 and 30 at the bigining of the decimal parts and add zero at the end to have same number of digits for the
    // two Input
    function normalizeNumbers(
        string memory _str1,
        string memory _str2
    )
        public
        pure
        returns (string memory, string memory)
    {
        string memory wpStr1;
        string memory dpStr1;
        string memory wpStr2;
        string memory dpStr2;

        uint256 num1;
        uint256 num2;
        //bool isUint;

        (wpStr1, dpStr1) = splitstring(_str1);
        (wpStr2, dpStr2) = splitstring(_str2);

        if (lengthOfString(dpStr1) < lengthOfString(dpStr2)) {
            dpStr1 = paddRight(dpStr1, "0", lengthOfString(dpStr2) - lengthOfString(dpStr1));
        }

        if (lengthOfString(dpStr2) < lengthOfString(dpStr1)) {
            dpStr2 = paddRight(dpStr2, "0", lengthOfString(dpStr1) - lengthOfString(dpStr2));
        }

        (num1, num2) = removeDotAndNormalize(_str1, _str2);

        if (num1 == num2) {
            dpStr1 = string(abi.encodePacked("10", dpStr1));
            dpStr2 = string(abi.encodePacked("10", dpStr2));
        } else if (num1 > num2) {
            dpStr1 = string(abi.encodePacked("30", dpStr1));
            dpStr2 = string(abi.encodePacked("10", dpStr2));
        } else {
            dpStr1 = string(abi.encodePacked("10", dpStr1));
            dpStr2 = string(abi.encodePacked("30", dpStr2));
        }

        return (string(abi.encodePacked(wpStr1, ".", dpStr1)), string(abi.encodePacked(wpStr2, ".", dpStr2)));
    }

    //=== Put numbers to equal number of digits
    function equalDigitsRight(uint256 _num1, uint256 _num2) internal pure returns (uint256 num1, uint256 num2) {
        if (lengthOfUint(_num1) == lengthOfUint(_num2)) {
            num1 = _num1;
            num2 = _num2;
        } else {
            if (lengthOfUint(_num1) > lengthOfUint(_num2)) {
                string memory str2 = uintToString(_num2);
                bool isUint;

                str2 = paddRight(str2, "0", lengthOfUint(_num1) - lengthOfUint(_num2));

                num1 = _num1;
                (num2, isUint) = strToUint(str2);
            } else {
                string memory str1 = uintToString(_num1);
                bool isUint;

                str1 = paddRight(str1, "0", lengthOfUint(_num2) - lengthOfUint(_num1));

                (num1, isUint) = strToUint(str1);
                num2 = _num2;
            }
        }
    }

    //=== Put zeros to equal number of digits
    function equalDigitsLeft(uint256 _num1, uint256 _num2) internal pure returns (uint256 num1, uint256 num2) {
        if (lengthOfUint(_num1) == lengthOfUint(_num2)) {
            num1 = _num1;
            num2 = _num2;
        } else {
            if (lengthOfUint(_num1) > lengthOfUint(_num2)) {
                string memory str2 = uintToString(_num2);
                bool isUint;

                str2 = paddLeft(str2, "0", lengthOfUint(_num1) - lengthOfUint(_num2));

                num1 = _num1;
                (num2, isUint) = strToUint(str2);
            } else {
                string memory str1 = uintToString(_num1);
                bool isUint;

                str1 = paddLeft(str1, "0", lengthOfUint(_num2) - lengthOfUint(_num1));

                (num1, isUint) = strToUint(str1);
                num2 = _num2;
            }
        }
    }

    //=== Removing the dot "." of a floating point number. Ex: "12.45 => 1245"
    function removeDot(string memory _str) public pure returns (uint256) {
        string memory wp;
        string memory dp;

        (wp, dp) = splitstring(_str);

        return strToUintV2(string(abi.encodePacked(wp, dp)));
    }

    //=== Removing the dot "." of two floating point numbers and normalizing. Ex: "(3.141, 14.3) => (3141, 1430)"
    function removeDotAndNormalize(string memory _str1, string memory _str2) public pure returns (uint256, uint256) {
        string memory wp1;
        string memory dp1;
        string memory wp2;
        string memory dp2;
        bool isUint;
        uint256 num1;
        uint256 num2;

        (wp1, dp1) = splitstring(_str1);
        (wp2, dp2) = splitstring(_str2);

        if (lengthOfString(dp1) < lengthOfString(dp2)) {
            dp1 = paddRight(dp1, "0", lengthOfString(dp2) - lengthOfString(dp1));
        }

        if (lengthOfString(dp2) < lengthOfString(dp1)) {
            dp2 = paddRight(dp2, "0", lengthOfString(dp1) - lengthOfString(dp2));
        }

        (num1, isUint) = strToUint(string(abi.encodePacked(wp1, dp1)));
        (num2, isUint) = strToUint(string(abi.encodePacked(wp2, dp2)));

        return (num1, num2);
    }

    // remove zeros at the end of the decimal part
    /*
    function removeZerosAtEnd(string memory _str) public pure returns(string memory str) {
        string memory wpStr;
        string memory dpStr;

        (wpStr, dpStr) = splitstring(_str);
        
        for (uint i = lengthOfString(dpStr) - 1; i > 1; i-- ) {
            if (bytes(dpStr)[i] == "0" && bytes(dpStr)[i - 1] == "0") {
               dpStr = substring(dpStr, 0, i - 2); 
            }
        }
        //dpStr = substring(dpStr, 0, 2);


        return dpStr;
    }
    */

    //=== Padding Right
    function paddRight(
        string memory _str,
        string memory _padStr,
        uint256 _padSize
    )
        internal
        pure
        returns (string memory str)
    {
        for (uint256 i = 0; i < _padSize; i++) {
            str = string(abi.encodePacked(str, _padStr));
        }

        return string(abi.encodePacked(_str, str));
    }

    //=== Padding Left
    function paddLeft(
        string memory _str,
        string memory _padStr,
        uint256 _padSize
    )
        internal
        pure
        returns (string memory str)
    {
        for (uint256 i = 0; i < _padSize; i++) {
            str = string(abi.encodePacked(str, _padStr));
        }

        return string(abi.encodePacked(str, _str));
    }
}
