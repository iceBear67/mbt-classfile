///|
typealias Int as Opcode

///|
pub(all) struct Label(String)

///|
pub(all) enum ArrayType {
  T_BOOLEAN
  T_CHAR
  T_FLOAT
  T_DOUBLE
  T_BYTE
  T_SHORT
  T_INT
  T_LONG
  Reference(String)
}

///|
pub(all) enum Invocation {
  Dynamic(@classfile.ConstantInvokeDynamicInfo)
  Interface(@classfile.ConstantInterfaceMethodRefInfo)
  // invokespecial, invokevirtual, invokestatic
  Normal(@classfile.ConstantMethodRefInfo)
}

///|
pub(all) enum Instruction {
  // opcode, type
  TypeInsn(Opcode, String) //checkcast, instanceof, new, newarry
  // opcode, dimention, 
  NewArrayInsn(Opcode, Int, ArrayType) // multinewarray todo
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
  // var index, increment
  IincInsn(UInt, Int)
  // var index.
  // RET and JSR has been deprecated for a long time. When writing bytecodes, do not use them.
  RetInsn(UInt)

  // opcode, descriptor
  InvocationInsn(Opcode, Invocation) // invokevirtual, invokeinterface
  Insn(Opcode) // insns that have no operands. d2i i2d
}
