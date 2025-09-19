///|
typealias Int as Opcode

pub struct Label(String)

///|
pub enum Instruction {
  // opcode, type
  TypeInsn(Opcode, String) //checkcast, instanceof, new, newarry
  // opcode, index
  ArrayInsn(Opcode, UInt?) //aaload aastore
  ArrayNewInsn // multinewarray todo
  // opcode, value.
  // for reference types the value must be None, otherwise always Some number.
  ConstInsn(Opcode, UInt?) // [..]const_01234
  // constant content
  LdcInsn(@classfile.ConstantType) //ldc constant string
  // opcode, flow target
  ControlFlowInsn(Opcode, Label?) // ifge, goto, return
  // opcode, operand(index).
  VarInsn(Opcode, UInt?) // aload, astore
  // opcode, descriptor
  FieldInsn(Opcode, @classfile.ConstantFieldRefInfo) // getfield, putfield

  // opcode, descriptor
  InvocationInsn(Opcode, String) // invokevirtual, invokeinterface
  InvokeDynamicInsn(String) //todo args

  Insn(Opcode) // insns that have no operands. d2i i2d
}
