// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract GasHelper_asm {
    function deploy(
        address logicContract
    ) external payable returns (address proxy, uint256 gasUsed) {
        uint256 gasBefore = gasleft();
        {
            bytes memory deploymentData = abi.encodePacked(
                hex"73",
                logicContract,
                hex"7f360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc55604280380380825f395ff37f360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc5473ffffffffffffffffffffffffffffffffffffffff16365f5f375f5f365f845af43d5f5f3e58600801573d5ffd5b3d5ff3"
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
