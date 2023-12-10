# EffiProxy
[ZH-cn](README_ZH-cn.md) | [EN](README.md)

## 概览

EffiProxy 是一个 `EIP-1967` 标准的燃气优化实现。



## 背景
在可升级合约领域，特别是对于合约钱包，合约的燃气效率在用户体验中扮演着关键角色。值得注意的例子包括 [Safe-global::SafeProxy.sol](https://github.com/safe-global/safe-contracts/blob/8b9023d9a2627ecbb5c40592e762857980f8e880/contracts/proxies/SafeProxy.sol) 和 [SoulWallet::SoulWalletProxy.sol](https://github.com/SoulWallet/soul-wallet-contract/blob/1b5a55f904a259332eed0ce6ff72b5c08448c259/contracts/SoulWalletProxy.sol)。



## 关键特性
 - ✨**燃气效率**：与 Yul 版本相比，EffiProxy 降低了超过 13k 的部署成本，达到了 15% 的降低。

   注意：编写难以阅读的代码通常不是一个好习惯。但是，对于像代理这样的合约，它们具有固定的逻辑并且本质上代码极其简洁，通过编写低级代码确实可以提高燃气效率，而不会对任何其他组件产生不良影响。
   
   
   
   EffiProxy 的 [opcode](src/EffiProxy_v2.asm) 如下：```60518060225f395f73111111111111111111111111111111111111111160165155f373ffffffffffffffffffffffffffffffffffffffff7f360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc5416365f5f375f5f365f845af43d5f5f3e604d573d5ffd5b3d5ff3```
   
   
   
   关于以上 opcode 的解释，请见 [EffiProxy_v2.asm](src/EffiProxy_v2.asm)。
   
   
   
   注意：代码中的 `1111111111111111111111111111111111111111` 是构造参数，使用时您需要替换为您自己指定的逻辑合约地址。
   
   
   
   以上 opcode 功能与以下 [Solidity 代码](src/YulProxy.sol)等价：
   
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



## 燃气

- 测试

```shell
forge test -vv | grep 'deploy'
```

- 测试结果：

| 名称                                            | 燃气       |
| ----------------------------------------------- | --------- |
| Yul 版本 [[代码]](src/YulProxy.sol)             | 83754 燃气 |
| asm 版本 [[代码]](src/EffiProxy_v2.asm)            | 70570 燃气 |

我们可以看到，与 Yul 版本相比，Asm 版本在部署时降低了超过 15% 的燃气。



## 使用

参考：[gasHelper_asm.sol](src/dev/gasHelper_asm.sol)



## 注意

Asm 中使用了 PUSH0 opcode，所以对于 EVM版本的要求是 >= Shanghai