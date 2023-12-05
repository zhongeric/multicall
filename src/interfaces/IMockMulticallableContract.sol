// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.20;

interface IMockMulticallableContract {
    error CustomError();
    error CustomErrorWithString(string reason);
    error CustomErrorWithBytes(bytes reason);
    error CustomErrorWithUint(uint256 reason);
    error CustomErrorWithTwoPrimitives(uint256 reason1, bool reason2);
}
