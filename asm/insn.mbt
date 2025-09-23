///|
typealias Int as Opcode

///|
pub(all) struct Label(String) derive(Show)

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
} derive(Show)

///|
pub(all) enum BranchLookup {
  Table(TableSwitch)
  Lookup(LookupSwitch)
} derive(Show)

///|
pub(all) struct TableSwitch {
  default_label : Label
  low : Int
  high : Int
  labels : FixedArray[Label] // len: high - low + 1
} derive(Show)

///|
pub(all) struct LookupSwitch {
  default_label : Label
  match_offset_pairs : FixedArray[(Int, Label)] // len: npairs
} derive(Show)

///|
pub(all) enum Invocation {
  Dynamic(@classfile.ConstantInvokeDynamicInfo)
  Interface(@classfile.ConstantInterfaceMethodRefInfo)
  // invokespecial, invokevirtual, invokestatic
  Normal(@classfile.ConstantMethodRefInfo)
} derive(Show)

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
  LabelInsn(Label)
  // opcode, operand(index).
  VarInsn(Opcode, UInt?) // aload, astore
  // opcode, descriptor
  FieldInsn(Opcode, @classfile.ConstantFieldRefInfo) // getfield, putfield
  // var index, increment
  IincInsn(UInt, Int)
  // var index.
  // RET and JSR has been deprecated for a long time. When writing bytecodes, do not use them.
  // do not mix with RETURN insn.
  RetInsn(UInt)
  SwitchInsn(BranchLookup)
  // opcode, descriptor
  InvocationInsn(Opcode, Invocation) // invokevirtual, invokeinterface
  Insn(Opcode) // insns that have no operands. d2i i2d
}

///|
pub fn to_string(self : Instruction) -> String {
  let sb = StringBuilder::new()
  let s = match self {
    InvocationInsn(opcode, target) =>
      "\{int_to_opcode_name(opcode)} target:\{target.invocation_to_string()}"
    SwitchInsn(branch) => "\{branch}"
    RetInsn(rt) => "RET index:\{rt}"
    IincInsn(op, i) => "IINC index:\{op} by \{i}"
    FieldInsn(op, field) =>
      "\{int_to_opcode_name(op)} \{field.name_and_type().map(it=>it.get_name()).unwrap()} type: \{field.name_and_type().map(it=>it.descriptor()).unwrap()}"
    LabelInsn(label) => "Label \{label}:"
    VarInsn(var, index) =>
      "\{int_to_opcode_name(var)} index:\{index.map(it => it.to_string())}"
    ControlFlowInsn(cf, label) =>
      "\{int_to_opcode_name(cf)} #\{label.map(it => it.0)}"
    LdcInsn(ldc) => "LDC \{ldc.to_string()}"
    ConstInsn(c, value) =>
      "\{int_to_opcode_name(c)} \{value.map(it => it.to_string())}"
    NewArrayInsn(op, dim, arrayType) =>
      "\{int_to_opcode_name(op)} \{arrayType}[dim: \{dim}]"
    TypeInsn(opcode, _type) => "\{int_to_opcode_name(opcode)} \{_type}"
    Insn(opcode) => int_to_opcode_name(opcode)
  }
  sb.write_string(s)
  sb.to_string()
}

///|
fn invocation_to_string(self : Invocation) -> String {
  match self {
    Dynamic(dyn) => "\{dyn.bootstrap_method_attr_index}}"
    Interface(intf) =>
      intf.interface_class_info().unwrap().name() +
      " " +
      intf.interface_name_and_type().unwrap().get_name().unwrap()
    Normal(norm) => norm.method_class_info().unwrap().name()+" "+norm.method_name_and_type().unwrap().descriptor().unwrap()
  }
}
