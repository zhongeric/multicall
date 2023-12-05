// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.20;
import {console2} from "forge-std/console2.sol";
/// @title Multicall
/// @notice Code from https://github.com/Uniswap/v3-periphery/blob/main/contracts/base/Multicall.sol
/// @notice Enables calling multiple methods in a single call to the contract
abstract contract Multicall {
    function multicall(bytes[] calldata data) public payable virtual returns (bytes[] memory results) {
        results = new bytes[](data.length);
        for (uint256 i = 0; i < data.length; i++) {
            (bool success, bytes memory result) = address(this).delegatecall(data[i]);
            console2.logBytes(result);
            console2.logUint(result.length);
            if (!success) {
                // handle custom errors
                if (result.length == 4) {
                    assembly {
                        revert(add(result, 0x20), mload(result))
                    }
                }
                // Next 5 lines from https://ethereum.stackexchange.com/a/83577
                if (result.length < 68) revert();
                assembly {
                    result := add(result, 0x04)
                }
                revert(abi.decode(result, (string)));
            }

            results[i] = result;
        }
    }
}