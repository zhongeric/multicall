// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {console2} from "forge-std/console2.sol";
import {Test} from "forge-std/Test.sol";
import {IMockMulticallableContract} from "../src/interfaces/IMockMulticallableContract.sol";
import {MockMulticallableContract} from "../src/test/MockMulticallableContract.sol";

contract MulticallTest is Test {
    MockMulticallableContract mockMulticallableContract;

    function setUp() public {
        mockMulticallableContract = new MockMulticallableContract();
    }

    function testRevertWithCustomError() public {
        bytes[] memory data = new bytes[](1);
        data[0] = abi.encodeWithSignature("revertWithCustomError()");
        vm.expectRevert(IMockMulticallableContract.CustomError.selector);
        mockMulticallableContract.multicall(data);
    }

    function testRevertWithCustomErrorWithString(string memory reason) public {
        vm.assume(keccak256(abi.encodePacked(reason)) != keccak256(abi.encodePacked("")));
        bytes[] memory data = new bytes[](1);
        data[0] = abi.encodeWithSignature("revertWithCustomErrorWithString(string)", reason);
        vm.expectRevert(abi.encodePacked(reason));
        mockMulticallableContract.multicall(data);
    }

    function testRevertWithCustomErrorWithBytes(bytes memory reason) public {
        bytes[] memory data = new bytes[](1);
        data[0] = abi.encodeWithSignature("revertWithCustomErrorWithBytes(bytes)", reason);
        vm.expectRevert(reason);
        mockMulticallableContract.multicall(data);
    }

    function testRevertWithCustomErrorWithUint(uint256 reason) public {
        bytes[] memory data = new bytes[](1);
        data[0] = abi.encodeWithSignature("revertWithCustomErrorWithUint(uint256)", reason);
        vm.expectRevert(abi.encodePacked(reason));
        mockMulticallableContract.multicall(data);
    }

    function testRevertWithCustomErrorWithTwoPrimitives(uint256 reason1, bool reason2) public {
        bytes[] memory data = new bytes[](1);
        data[0] = abi.encodeWithSignature("revertWithCustomErrorWithTwoPrimitives(uint256,bool)", reason1, reason2);
        vm.expectRevert(abi.encodePacked(reason1, reason2));
        mockMulticallableContract.multicall(data);
    }
}
