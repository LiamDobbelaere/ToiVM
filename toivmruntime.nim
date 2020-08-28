import toivmtypes
import tables

type
  ToiVMRuntime* = ref object
    stack: seq[uint8]      # Stack of variable size
    program: seq[uint8]     # Program code
    pc: uint16              # Program counter

proc op_PRT(vm: ToiVMRuntime) =
    {.noSideEffect}:
        echo vm.stack.pop()

proc op_ECH(vm: ToiVMRuntime) =
    {.noSideEffect}:
        echo vm.stack[^1]

proc op_PSH(vm: ToiVMRuntime) =
    vm.pc += 1    
    vm.stack.add(vm.program[vm.pc])

proc op_ADD(vm: ToiVMRuntime) =
    vm.stack.add(vm.stack.pop() + vm.stack.pop())

proc op_MUL(vm: ToiVMRuntime) =
    vm.stack.add(vm.stack.pop() * vm.stack.pop())

const opcodeToProc = {
    Opcode.PSH: op_PSH,
    Opcode.ADD: op_ADD,
    Opcode.MUL: op_MUL,
    Opcode.ECH: op_ECH,
    Opcode.PRT: op_PRT
}.toTable

proc init(self: ToiVMRuntime) =
    self.stack = @[]
    self.pc = 0

proc load*(self: ToiVMRuntime, byteCode: seq[uint8]) =
    self.init()
    self.program = byteCode

proc step*(self: ToiVMRuntime) =
    let op: Opcode = Opcode(self.program[self.pc])
    opcodeToProc[op](self)

    self.pc += 1
    
proc run*(self: ToiVMRuntime) =
    while self.pc < uint16(len(self.program)):
        self.step()