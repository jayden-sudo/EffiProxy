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
            # set runtime code size
      000   0x60	PUSH1 # push 081(0x51)
            CODE       6051
            Stack:
                  runtime code length = 0x51

      002   0x80	DUP1
            CODE       80
            Stack:
                  runtime code length
                  runtime code length

            # set runtime code offset = (033+1) = 0x22
      003   0x60	PUSH1
            CODE       6022
            Stack:
                  runtime code offset
                  runtime code length
                  runtime code length
      
      005   0x5F	PUSH0 
            CODE       5f
            Stack:
                dstOst = 0
                runtime code offset
                runtime code length
                runtime code length
            
            # 0x39	CODECOPY(dstOst, ost, len)
      006   0x39	CODECOPY
            CODE       39
            Stack:
                runtime code length
      
      007   0x5F	PUSH0
            CODE       5f
            Stack:
                memory start offset = 0
                runtime code length

      008   0x73	PUSH20 0x1111111111111111111111111111111111111111 // Assume logicContract address is 0x1111111111111111111111111111111111111111
            CODE       731111111111111111111111111111111111111111
            Stack:
                0x0000000000000000000000001111111111111111111111111111111111111111
                memory start offset = 0
                runtime code length = 0x51

      029   0x60	PUSH1 # (21+1) = 0x16
            CODE       6016
            Stack:
                0x01
                0x0000000000000000000000001111111111111111111111111111111111111111
                memory start offset = 0
                runtime code length = 0x51

      031   0x51	MLOAD
            CODE       51
            Stack:
                0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc
                0x0000000000000000000000001111111111111111111111111111111111111111
                memory start offset = 0
                runtime code length = 0x51

      032   0x55	SSTORE
            CODE       55
            Stack:
                memory start offset = 0
                runtime code length = 0x51

      033   0xF3	RETURN
            CODE       f3
      
#Constructor end

#RuntimeCode begin, length = (80+1)(0x51)

      000   0x73	PUSH20 0xffffffffffffffffffffffffffffffffffffffff
            CODE       73ffffffffffffffffffffffffffffffffffffffff
            Stack:
                0x000000000000000000000000ffffffffffffffffffffffffffffffffffffffff

      021   0x7F	PUSH32 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc
            CODE       7f360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc
            Stack:
                0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc
                0x000000000000000000000000ffffffffffffffffffffffffffffffffffffffff

      054   0x54	SLOAD
            CODE       54
            Stack:
                0x0000000000000000000000001111111111111111111111111111111111111111
                0x000000000000000000000000ffffffffffffffffffffffffffffffffffffffff

            
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

      071   0x60	PUSH1 # push 077(0x4d)
            CODE       604d
            Stack:
                $PC(## Return begin)
                DELEGATECALL result
                0x0000000000000000000000001111111111111111111111111111111111111111

            # 0x57	JUMPI(dst, condition)
      073   0x57	JUMPI 
            CODE       57
            Stack:
                0x0000000000000000000000001111111111111111111111111111111111111111

## Revert begin
      074   0x3D	RETURNDATASIZE
            CODE       3d
            Stack:
                RETURNDATASIZE
                0x0000000000000000000000001111111111111111111111111111111111111111

      075   0x5F	PUSH0
            CODE       5f
            Stack:
                memory start offset = 0
                RETURNDATASIZE
                0x0000000000000000000000001111111111111111111111111111111111111111

      076   0xFD	REVERT
            CODE       fd

## Return begin
      077   0x5B	JUMPDEST
            CODE       5b
      
      078   0x3D	RETURNDATASIZE
            CODE       3d
            Stack:
                RETURNDATASIZE
                0x0000000000000000000000001111111111111111111111111111111111111111

      079   0x5F	PUSH0
            CODE       5f
            Stack:
                memory start offset = 0
                RETURNDATASIZE
                0x0000000000000000000000001111111111111111111111111111111111111111

      080   0xF3	RETURN
            CODE       f3

#RuntimeCode end