//    
//    ┌────────────────────────────────────────────────────────────────────────────────────────────┐
//    │                                                                                            ││
//    │                                                                                            │┼│
//    │      remark     PC     opcode     opcode name     code in bytecode     stack now           │┼┼│
//    │      ──┬───     ─┬     ───┬──     ────┬──────     ────────┬───────     ───┬─────           │┼┼│
//    │        │         │        │           │                   │               │                │┼┼│
//    │        │         │        │           │                   │               │                │┼┼│
//    │        │         │        │           │                   │               │                │┼┼│
//    │        │         │        │           │                   │               │                │┼┼│
//    │        │         │        │           │                   │               │                │┼┼│
//    │        │         │        │           │                   │               │                │┼┼│
//    │        │         │        │           │                   │               │                │┼┼│
//    │        ▼         │        │           │                   │               │                │┼┼│
//    │    ## Revert begi│        │           │                   │               │                │┼┼│
//    │                  │        │           │                   │               │                │┼┼│
//    │                  │        │           │                   │               │                │┼┼│
//    │           ┌──────┘┌───────┘  ┌────────┘                   │               │                │┼┼│
//    │           ▼       ▼          ▼                            │               │                │┼┼│
//    │          076   0x3D	RETURNDATASIZE                      │               │                │┼┼│
//    │                                                           │               │                │┼┼│
//    │                                                           │               │                │┼┼│
//    │                 CODE       3d  ◄──────────────────────────┘               │                │┼┼│
//    │                                                                           │                │┼┼│
//    │                                                                           │                │┼┼│
//    │                 Stack:      ◄─────────────────────────────────────────────┘                │┼┼│
//    │                     RETURNDATASIZE                                                         │┼┼│
//    │                     0x0000000000000000000000001111111111111111111111111111111111111111     │┼┼│
//    │                                                                                            │┼┼│
//    │                                                                                            │┼┼│
//    └──┬─────────────────────────────────────────────────────────────────────────────────────────┼┼┼│
//       │┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼│
//       └────────────────────────────────────────────────────────────────────────────────────────────┘
//    





#Constructor begin
      000   0x73	PUSH20 0x1111111111111111111111111111111111111111 // Assume logicContract address is 0x1111111111111111111111111111111111111111
            CODE       731111111111111111111111111111111111111111

      021   0x7F	PUSH32 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc
            CODE       7f360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc
            Stack:
                0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc
                0x0000000000000000000000001111111111111111111111111111111111111111

      054   0x55	SSTORE
            CODE       55
            Stack:
                <empty>

            # set runtime code
            # get code size
            # 0x38	CODESIZE
            # set constructor code size (66 = 0x65+1)
      055   0x60	PUSH1
            CODE       6042

      057   0x80    DUP1
            CODE       80
            Stack:
                constructor code size
                constructor code size

      058   0x38    CODESIZE
            CODE       38
            Stack:
                CODESIZE
                constructor code size
                constructor code size
            
            # get runtime code length
      059   0x03   SUB
            CODE       03
            Stack:
                runtime code length
                constructor code size

      060   0x80    DUP1
            CODE       80
            Stack:
                runtime code length
                runtime code length
                constructor code size
      
      061   0x82    DUP3
            CODE       82
            Stack:
                constructor code size
                runtime code length
                runtime code length
                constructor code size
      
      062   0x5F	PUSH0 
            CODE       5f
            Stack:
                dstOst = 0
                constructor code size
                runtime code length
                runtime code length
                constructor code size
            
            # 0x39	CODECOPY(dstOst, ost, len)
      063   0x39	CODECOPY
            CODE       39
            Stack:
                runtime code length
                constructor code size
      
      064   0x5F	PUSH0
            CODE       5f
            Stack:
                memory start offset = 0
                runtime code length
                constructor code size

      065   0xF3	RETURN
            CODE       f3
      
#Constructor end

#RuntimeCode begin

      000   0x7F	PUSH32 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc
            CODE       7f360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc
            Stack:
                0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc

      033   0x54	SLOAD
            CODE       54
            Stack:
                0x0000000000000000000000001111111111111111111111111111111111111111

      034   0x73	PUSH20 0xffffffffffffffffffffffffffffffffffffffff
            CODE       73ffffffffffffffffffffffffffffffffffffffff
            Stack:
                0x000000000000000000000000ffffffffffffffffffffffffffffffffffffffff
                0x0000000000000000000000001111111111111111111111111111111111111111
            
      055   0x16	AND
            CODE       16
            Stack:
                0x0000000000000000000000001111111111111111111111111111111111111111 (safe address)

            # delegatecall begin
            
            # copy calldata to memory:[0x00,] ,   37 CALLDATACOPY(dstOst, ost, len)
      056   0x36	CALLDATASIZE // set len
            CODE       36

      057   0x5F	PUSH0 // ost
            CODE       5f

      058   0x5F	PUSH0 // dstOst
            CODE       5f
            Stack:
                dstOst = 0
                ost = 0
                len = CALLDATASIZE
                0x0000000000000000000000001111111111111111111111111111111111111111

      059   0x37	CALLDATACOPY
            CODE       37

            # memory:[0x00,] = calldata:[0x00,]
            Stack:
                0x0000000000000000000000001111111111111111111111111111111111111111

            # F4	DELEGATECALL(gas, addr, argOst, argLen, retOst, retLen)

      060   0x5F	PUSH0 // retLen
            CODE       5f

      061   0x5F	PUSH0 // retOst
            CODE       5f

      062   0x36 CALLDATASIZE // argLen
            CODE       36

      063   0x5F	PUSH0 // argOst
            CODE       5f
            Stack:
                argOst = 0
                argLen
                retOst = 0
                retLen = 0
                0x0000000000000000000000001111111111111111111111111111111111111111

      064   0x84	DUP5
            CODE       84
            Stack:
                0x0000000000000000000000001111111111111111111111111111111111111111
                argOst = 0
                argLen
                retOst = 0
                retLen = 0
                0x0000000000000000000000001111111111111111111111111111111111111111

      065   0x5A	GAS // gas
            CODE       5a
            
      066   0xF4 DELEGATECALL
            CODE       f4
            Stack:
                DELEGATECALL result
                0x0000000000000000000000001111111111111111111111111111111111111111

            # copy returndata to memory:[0x00,]
            # get returndatasize
      067   0x3D	RETURNDATASIZE
            CODE       3d

      068   0x5F	PUSH0 // ost
            CODE       5f

      069   0x5F	PUSH0 // dstOst
            CODE       5f
            Stack:
                dstOst = 0
                ost = 0
                RETURNDATASIZE
                DELEGATECALL result
                0x0000000000000000000000001111111111111111111111111111111111111111

            # 0x3E	RETURNDATACOPY(dstOst, ost, len)
      070   0x3E	RETURNDATACOPY
            CODE       3e

            Stack:
                DELEGATECALL result
                0x0000000000000000000000001111111111111111111111111111111111111111

            # memory:[0x00,] = returndata:[0x00,]

            # check if revert or return
            # 0x57	JUMPI(dst, condition)
            # push DELEGATECALL result to stack

      071   0x58	PC
            CODE       58
            Stack:
                $PC
                DELEGATECALL result
                0x0000000000000000000000001111111111111111111111111111111111111111

      072   0x60	PUSH1 # push PC offset = 8
            CODE       6008
            Stack:
                06
                $PC
                DELEGATECALL result
                0x0000000000000000000000001111111111111111111111111111111111111111

      074   0x01	Add
            CODE       01
            Stack:
                $PC{return begin}
                DELEGATECALL result
                0x0000000000000000000000001111111111111111111111111111111111111111

            # 0x57	JUMPI(dst, condition)
      075   0x57	JUMPI 
            CODE       57
            Stack:
                0x0000000000000000000000001111111111111111111111111111111111111111

## Revert begin
      076   0x3D	RETURNDATASIZE
            CODE       3d
            Stack:
                RETURNDATASIZE
                0x0000000000000000000000001111111111111111111111111111111111111111

      077   0x5F	PUSH0
            CODE       5f
            Stack:
                memory start offset = 0
                RETURNDATASIZE
                0x0000000000000000000000001111111111111111111111111111111111111111

      078   0xFD	REVERT
            CODE       fd

## Return begin
      079   0x5B	JUMPDEST
            CODE       5b
      
      080   0x3D	RETURNDATASIZE
            CODE       3d
            Stack:
                RETURNDATASIZE
                0x0000000000000000000000001111111111111111111111111111111111111111

      081   0x5F	PUSH0
            CODE       5f
            Stack:
                memory start offset = 0
                RETURNDATASIZE
                0x0000000000000000000000001111111111111111111111111111111111111111

      082   0xF3	RETURN
            CODE       f3

#RuntimeCode end