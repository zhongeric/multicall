// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.0;

import {Multicall} from "../Multicall.sol";
import {IMockMulticallableContract} from "../interfaces/IMockMulticallableContract.sol";

contract MockMulticallableContract is IMockMulticallableContract, Multicall {
    function legacyRequire() external pure {
        require(false, "legacy require");
    }

    function legacyRevert() external pure {
        revert("legacy revert");
    }

    function revertWithCustomError() external pure {
        revert CustomError();
    }

    function revertWithCustomErrorWithString(string memory reason) external pure {
        revert CustomErrorWithString(reason);
    }

    function revertWithCustomErrorWithBytes(bytes memory reason) external pure {
        revert CustomErrorWithBytes(reason);
    }

    function revertWithCustomErrorWithUint(uint256 reason) external pure {
        revert CustomErrorWithUint(reason);
    }

    function revertWithCustomErrorWithTwoPrimitives(uint256 reason1, bool reason2) external pure {
        revert CustomErrorWithTwoPrimitives(reason1, reason2);
    }

    function returnString(string memory reason) external pure returns (string memory) {
        return reason;
    }

    function returnBytes(bytes memory reason) external pure returns (bytes memory) {
        return reason;
    }

    function returnUint(uint256 reason) external pure returns (uint256) {
        return reason;
    }
}
