// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

library Strings {
    function toString(uint value) internal pure returns (string memory) {
        if (value == 0) {
            return "0";
        }

        uint temp = value;
        uint digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }
}
