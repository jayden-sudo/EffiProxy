// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../YulProxy.sol";

contract GasHelper_yul {
    function deploy(
        address logicContract
    ) external payable returns (address proxy, uint256 gasUsed) {
        uint256 gasBefore = gasleft();
        {
            bytes32 _logicContract = bytes32(uint256(uint160(logicContract)));
            bytes memory deploymentData = abi.encodePacked(
                type(YulProxy).creationCode,
                _logicContract
            );
            assembly ("memory-safe") {
                // proxy := create2(
                //     0x0,
                //     add(deploymentData, 0x20),
                //     mload(deploymentData),
                //     0
                // )
                proxy := create(
                    0x0,
                    add(deploymentData, 0x20),
                    mload(deploymentData)
                )
                if iszero(proxy) {
                    revert(0, 0)
                }
            }
        }
        uint256 gasAfter = gasleft();
        gasUsed = gasBefore - gasAfter;
    }
}
