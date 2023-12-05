// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.0;

import {console2} from "forge-std/console2.sol";
import {Test} from "forge-std/Test.sol";
import {IMockMulticallableContract} from "../src/interfaces/IMockMulticallableContract.sol";
import {MockMulticallableContract} from "../src/test/MockMulticallableContract.sol";

contract MulticallTest is Test {
    MockMulticallableContract mockMulticallableContract;

    function setUp() public {
        mockMulticallableContract = new MockMulticallableContract();
    }

    function testEmptyRevert() public {
        bytes[] memory data = new bytes[](1);
        data[0] = abi.encodeWithSignature("emptyRevert()");
        vm.expectRevert();
        mockMulticallableContract.multicall(data);
    }

    function testLegacyRequire() public {
        bytes[] memory data = new bytes[](1);
        data[0] = abi.encodeWithSignature("legacyRequire()");
        vm.expectRevert("legacy require");
        mockMulticallableContract.multicall(data);
    }

    function testLegacyRevert() public {
        bytes[] memory data = new bytes[](1);
        data[0] = abi.encodeWithSignature("legacyRevert()");
        vm.expectRevert("legacy revert");
        mockMulticallableContract.multicall(data);
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
        vm.expectRevert(abi.encodeWithSelector(IMockMulticallableContract.CustomErrorWithString.selector, reason));
        mockMulticallableContract.multicall(data);
    }

    function testRevertWithCustomErrorWithBytes(bytes memory reason) public {
        bytes[] memory data = new bytes[](1);
        data[0] = abi.encodeWithSignature("revertWithCustomErrorWithBytes(bytes)", reason);
        vm.expectRevert(abi.encodeWithSelector(IMockMulticallableContract.CustomErrorWithBytes.selector, reason));
        mockMulticallableContract.multicall(data);
    }

    function testRevertWithCustomErrorWithUint(uint256 reason) public {
        bytes[] memory data = new bytes[](1);
        data[0] = abi.encodeWithSignature("revertWithCustomErrorWithUint(uint256)", reason);
        vm.expectRevert(abi.encodeWithSelector(IMockMulticallableContract.CustomErrorWithUint.selector, reason));
        mockMulticallableContract.multicall(data);
    }

    function testRevertWithCustomErrorWithTwoPrimitives(uint256 reason1, bool reason2) public {
        bytes[] memory data = new bytes[](1);
        data[0] = abi.encodeWithSignature("revertWithCustomErrorWithTwoPrimitives(uint256,bool)", reason1, reason2);
        vm.expectRevert(
            abi.encodeWithSelector(IMockMulticallableContract.CustomErrorWithTwoPrimitives.selector, reason1, reason2)
        );
        mockMulticallableContract.multicall(data);
    }

    function testReturnString(string memory reason) public {
        bytes[] memory data = new bytes[](1);
        data[0] = abi.encodeWithSignature("returnString(string)", reason);
        bytes[] memory results = mockMulticallableContract.multicall(data);
        assertEq(results[0], abi.encode(reason));
    }

    function testReturnBytes(bytes memory reason) public {
        bytes[] memory data = new bytes[](1);
        data[0] = abi.encodeWithSignature("returnBytes(bytes)", reason);
        bytes[] memory results = mockMulticallableContract.multicall(data);
        assertEq(results[0], abi.encode(reason));
    }

    function testReturnUint(uint256 reason) public {
        bytes[] memory data = new bytes[](1);
        data[0] = abi.encodeWithSignature("returnUint(uint256)", reason);
        bytes[] memory results = mockMulticallableContract.multicall(data);
        assertEq(results[0], abi.encode(reason));
    }

    function testAllResultsAreReturned() public {
        bytes[] memory data = new bytes[](3);
        data[0] = abi.encodeWithSignature("returnUint(uint256)", 0);
        data[1] = abi.encodeWithSignature("returnUint(uint256)", 1);
        data[2] = abi.encodeWithSignature("returnUint(uint256)", 2);
        bytes[] memory results = mockMulticallableContract.multicall(data);
        assertEq(results[0], abi.encode(uint256(0)));
        assertEq(results[1], abi.encode(uint256(1)));
        assertEq(results[2], abi.encode(uint256(2)));
    }

    function testFirstRevertIsBubbledUp() public {
        bytes[] memory data = new bytes[](3);
        data[0] = abi.encodeWithSignature("returnUint(uint256)", 0);
        data[1] = abi.encodeWithSignature("revertWithCustomError()");
        data[2] = abi.encodeWithSignature("legacyRequire()");
        vm.expectRevert(IMockMulticallableContract.CustomError.selector);
        mockMulticallableContract.multicall(data);
    }
}
