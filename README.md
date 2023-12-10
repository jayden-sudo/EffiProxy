# EffiProxy
[ZH-cn](README_ZH-cn.md) | [EN](README.md)


## Overview

EffiProxy is a  `EIP-1967` standard gas optimization implementation.



## Background
In the realm of upgradable contracts, especially for contract wallets, the gas efficiency of a contract plays a pivotal role in user experience. Notable examples include [Safe-global::SafeProxy.sol](https://github.com/safe-global/safe-contracts/blob/8b9023d9a2627ecbb5c40592e762857980f8e880/contracts/proxies/SafeProxy.sol) and [SoulWallet::SoulWalletProxy.sol](https://github.com/SoulWallet/soul-wallet-contract/blob/1b5a55f904a259332eed0ce6ff72b5c08448c259/contracts/SoulWalletProxy.sol).




## Key Features
 - ✨**Gas Efficiency**: Compared to Yul versions, EffiProxy reduces deployment cost by over 13k gas, achieving a 15% reduction.

   

   Note: Writing code that is hard to read is generally not a good practice. However, for contracts like proxy, which have fixed logic and are inherently minimalistic in code, it is indeed possible to improve gas efficiency by writing low-level code without adversely affecting any other components.
   
   
   
   The [opcode](src/EffiProxy_v2.asm) for EffiProxy is as follows: ```60518060225f395f73111111111111111111111111111111111111111160165155f373ffffffffffffffffffffffffffffffffffffffff7f360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc5416365f5f375f5f365f845af43d5f5f3e604d573d5ffd5b3d5ff3```
   
   
   
   For an explanation of the above opcode, please see [EffiProxy_v2.asm](src/EffiProxy_v2.asm).
   
   
   
   Note: `1111111111111111111111111111111111111111` in the code is a constructor parameter. You will need to replace it with your own specified logic contract address when using it.
   
   
   
   The functionality of the above opcode is equivalent to the following [Solidity code](src/YulProxy.sol):
   
   ```solidity
   pragma solidity ^0.8.20;
   contract YulProxy {
       bytes32 private constant _IMPLEMENTATION_SLOT =
           0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
   
       constructor(address logic) {
           assembly ("memory-safe") {
               sstore(_IMPLEMENTATION_SLOT, logic)
           }
       }
   
       fallback() external payable {
           assembly {
               calldatacopy(0, 0, calldatasize())
               let _singleton := and(
                   sload(_IMPLEMENTATION_SLOT),
                   0xffffffffffffffffffffffffffffffffffffffff
               )
               let success := delegatecall(
                   gas(),
                   _singleton,
                   0,
                   calldatasize(),
                   0,
                   0
               )
               returndatacopy(0, 0, returndatasize())
               if iszero(success) {
                   revert(0, returndatasize())
               }
               return(0, returndatasize())
           }
       }
   }
   
   ```
   
   

## GAS

- Test

```shell
forge test -vv | grep 'deploy'
```

- Test result:

| Name                                            | GAS       |
| ----------------------------------------------- | --------- |
| Yul version [[code]](src/YulProxy.sol)          | 83754 gas |
| asm version [[code]](src/EffiProxy_v2.asm) | 70570 gas |

We can see that the Asm version reduces gas by more than 15% at deployment time compared to the Yul version.



## Usage

Reference: [gasHelper_asm.sol](src/dev/gasHelper_asm.sol)



## Note

The Asm is written with the PUSH0 opcode, so it can only be deployed with EVM version >= Shanghai. 

