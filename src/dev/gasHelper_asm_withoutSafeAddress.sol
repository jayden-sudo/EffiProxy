// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract GasHelper_asm_withoutSafeAddress {
    function deploy(
        address logicContract
    ) external payable returns (address proxy, uint256 gasUsed) {
        uint256 gasBefore = gasleft();
        {
            
            //# EffiProxy_v2_withoutSafeAddress
            // 603b8060225f395f73111111111111111111111111111111111111111160015155f37f360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc54365f5f375f5f365f845af43d5f5f3e6037573d5ffd5b3d5ff3
            bytes memory deploymentData = abi.encodePacked(
                hex"603b8060225f395f73",
                logicContract,
                hex"60015155f37f360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc54365f5f375f5f365f845af43d5f5f3e6037573d5ffd5b3d5ff3"
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
