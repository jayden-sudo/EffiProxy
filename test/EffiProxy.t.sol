// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {DemoLogicContract} from "../src/dev/DemoLogicContract.sol";
import {GasHelper_asm} from "../src/dev/gasHelper_asm.sol";
import {GasHelper_yul} from "../src/dev/gasHelper_yul.sol";
import {GasHelper_solady} from "../src/dev/GasHelper_solady.sol";
import {GasHelper_asm_withoutSafeAddress} from "../src/dev/gasHelper_asm_withoutSafeAddress.sol";

contract EffiPoxyTest is Test {
    GasHelper_asm gasHelper_asm;
    GasHelper_yul gasHelper_yul;
    GasHelper_asm_withoutSafeAddress gasHelper_asm_withoutSafeAddress;
    GasHelper_solady gasHelper_solady;

    function setUp() public {
        gasHelper_asm = new GasHelper_asm();
        gasHelper_yul = new GasHelper_yul();
        gasHelper_asm_withoutSafeAddress = new GasHelper_asm_withoutSafeAddress();
        gasHelper_solady = new GasHelper_solady();
    }

    function test_gasDiff() public {
        address demoLogicContract = address(new DemoLogicContract());
        console2.log("demoLogicContract", demoLogicContract);

        uint256 yul_deploy_gas;
        uint256 asm_deploy_gas;
        uint256 asm_unsafe_deploy_gas;
        uint256 solady_deploy_gas;

        uint256 yul_call_gas1;
        uint256 asm_call_gas1;
        uint256 asm_unsafe_call_gas1;
        uint256 solady_call_gas1;

        uint256 yul_call_gas2;
        uint256 asm_call_gas2;
        uint256 asm_unsafe_call_gas2;
        uint256 solady_call_gas2;

        uint256 yul_call_gas3;
        uint256 asm_call_gas3;
        uint256 asm_unsafe_call_gas3;
        uint256 solady_call_gas3;

        uint256 yul_call_gas4;
        uint256 asm_call_gas4;
        uint256 asm_unsafe_call_gas4;
        uint256 solady_call_gas4;

        uint256 snapshotId = vm.snapshot();

        {
            // asm
            // deploy
            (address proxy, uint256 gasUsed) = gasHelper_asm.deploy(
                demoLogicContract
            );
            console2.log("gasused-deploy-asm", gasUsed);
            asm_deploy_gas = gasUsed;

            {
                // test call
                DemoLogicContract demoLogic = DemoLogicContract(proxy);
                {
                    uint256 gasBefore = gasleft();
                    bytes32 re = demoLogic.getData(1);
                    uint256 gasAfter = gasleft();
                    assertEq(re, 0);
                    asm_call_gas1 = gasBefore - gasAfter;
                    console2.log("gasused-call1-asm", asm_call_gas1);
                }
                bytes32 _b = keccak256(hex"");
                {
                    uint256 gasBefore = gasleft();
                    demoLogic.setData(1, _b);
                    uint256 gasAfter = gasleft();
                    asm_call_gas2 = gasBefore - gasAfter;
                    console2.log("gasused-call2-asm", asm_call_gas2);
                }
                {
                    uint256 gasBefore = gasleft();
                    bytes32 re = demoLogic.getData(1);
                    uint256 gasAfter = gasleft();
                    assertEq(re, _b);
                    asm_call_gas3 = gasBefore - gasAfter;
                    console2.log("gasused-call3-asm", asm_call_gas3);
                }

                {
                    uint256 gasBefore = gasleft();
                    try demoLogic.setData(0, _b) {
                        revert("should revert");
                    } catch Error(string memory revertReason) {
                        assertEq(revertReason, "key cannot be 0");
                    }
                    uint256 gasAfter = gasleft();
                    asm_call_gas4 = gasBefore - gasAfter;
                    console2.log("gasused-call4-asm", asm_call_gas4);
                }
            }
        }
        vm.revertTo(snapshotId);
        {
            // yul
            // deploy
            (address proxy, uint256 gasUsed) = gasHelper_yul.deploy(
                demoLogicContract
            );
            console2.log("gasused-deploy-yul", gasUsed);
            yul_deploy_gas = gasUsed;

            {
                // test call
                DemoLogicContract demoLogic = DemoLogicContract(proxy);
                {
                    uint256 gasBefore = gasleft();
                    bytes32 re = demoLogic.getData(1);
                    uint256 gasAfter = gasleft();
                    assertEq(re, 0);
                    yul_call_gas1 = gasBefore - gasAfter;
                    console2.log("gasused-call1-yul", yul_call_gas1);
                }
                bytes32 _b = keccak256(hex"");
                {
                    uint256 gasBefore = gasleft();
                    demoLogic.setData(1, _b);
                    uint256 gasAfter = gasleft();
                    yul_call_gas2 = gasBefore - gasAfter;
                    console2.log("gasused-call2-yul", yul_call_gas2);
                }
                {
                    uint256 gasBefore = gasleft();
                    bytes32 re = demoLogic.getData(1);
                    uint256 gasAfter = gasleft();
                    assertEq(re, _b);
                    yul_call_gas3 = gasBefore - gasAfter;
                    console2.log("gasused-call3-yul", yul_call_gas3);
                }
                {
                    uint256 gasBefore = gasleft();
                    try demoLogic.setData(0, _b) {
                        revert("should revert");
                    } catch Error(string memory revertReason) {
                        assertEq(revertReason, "key cannot be 0");
                    }
                    uint256 gasAfter = gasleft();
                    yul_call_gas4 = gasBefore - gasAfter;
                    console2.log("gasused-call4-yul", yul_call_gas4);
                }
            }
        }
        vm.revertTo(snapshotId);

        {
            // asm_withoutSafeAddress
            // deploy
            (address proxy, uint256 gasUsed) = gasHelper_asm_withoutSafeAddress
                .deploy(demoLogicContract);
            console2.log("gasused-deploy-asm-unsafe", gasUsed);
            asm_unsafe_deploy_gas = gasUsed;

            {
                // test call
                DemoLogicContract demoLogic = DemoLogicContract(proxy);
                {
                    uint256 gasBefore = gasleft();
                    bytes32 re = demoLogic.getData(1);
                    uint256 gasAfter = gasleft();
                    assertEq(re, 0);
                    asm_unsafe_call_gas1 = gasBefore - gasAfter;
                    console2.log(
                        "gasused-call1-asm_unsafe",
                        asm_unsafe_call_gas1
                    );
                }
                bytes32 _b = keccak256(hex"");
                {
                    uint256 gasBefore = gasleft();
                    demoLogic.setData(1, _b);
                    uint256 gasAfter = gasleft();
                    asm_unsafe_call_gas2 = gasBefore - gasAfter;
                    console2.log(
                        "gasused-call2-asm_unsafe",
                        asm_unsafe_call_gas2
                    );
                }
                {
                    uint256 gasBefore = gasleft();
                    bytes32 re = demoLogic.getData(1);
                    uint256 gasAfter = gasleft();
                    assertEq(re, _b);
                    asm_unsafe_call_gas3 = gasBefore - gasAfter;
                    console2.log(
                        "gasused-call3-asm_unsafe",
                        asm_unsafe_call_gas3
                    );
                }

                {
                    uint256 gasBefore = gasleft();
                    try demoLogic.setData(0, _b) {
                        revert("should revert");
                    } catch Error(string memory revertReason) {
                        assertEq(revertReason, "key cannot be 0");
                    }
                    uint256 gasAfter = gasleft();
                    asm_unsafe_call_gas4 = gasBefore - gasAfter;
                    console2.log(
                        "gasused-call4-asm_unsafe",
                        asm_unsafe_call_gas4
                    );
                }
            }
        }
        vm.revertTo(snapshotId);

        {
            // solady
            // deploy
            (address proxy, uint256 gasUsed) = gasHelper_solady.deploy(
                demoLogicContract
            );
            console2.log("gasused-deploy-solady", gasUsed);
            solady_deploy_gas = gasUsed;

            {
                // test call
                DemoLogicContract demoLogic = DemoLogicContract(proxy);
                {
                    uint256 gasBefore = gasleft();
                    bytes32 re = demoLogic.getData(1);
                    uint256 gasAfter = gasleft();
                    assertEq(re, 0);
                    solady_call_gas1 = gasBefore - gasAfter;
                    console2.log("gasused-call1-solady", solady_call_gas1);
                }
                bytes32 _b = keccak256(hex"");
                {
                    uint256 gasBefore = gasleft();
                    demoLogic.setData(1, _b);
                    uint256 gasAfter = gasleft();
                    solady_call_gas2 = gasBefore - gasAfter;
                    console2.log("gasused-call2-solady", solady_call_gas2);
                }
                {
                    uint256 gasBefore = gasleft();
                    bytes32 re = demoLogic.getData(1);
                    uint256 gasAfter = gasleft();
                    assertEq(re, _b);
                    solady_call_gas3 = gasBefore - gasAfter;
                    console2.log("gasused-call3-solady", solady_call_gas3);
                }

                {
                    uint256 gasBefore = gasleft();
                    try demoLogic.setData(0, _b) {
                        revert("should revert");
                    } catch Error(string memory revertReason) {
                        assertEq(revertReason, "key cannot be 0");
                    }
                    uint256 gasAfter = gasleft();
                    solady_call_gas4 = gasBefore - gasAfter;
                    console2.log("gasused-call4-solady", solady_call_gas4);
                }
            }
        }
        vm.revertTo(snapshotId);

        console2.log("gasDiff-deploy", yul_deploy_gas - asm_deploy_gas);
        console2.log(
            "gasDiff-call(4 times)",
            (yul_call_gas1 + yul_call_gas2 + yul_call_gas3 + yul_call_gas4) -
                (asm_call_gas1 + asm_call_gas2 + asm_call_gas3 + asm_call_gas4)
        );
    }
}
