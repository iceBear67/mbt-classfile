// When the code array is read into memory on a byte-addressable machine, 
// if the first byte of the array is aligned on a 4-byte boundary, the tableswitch and lookupswitch 32-bit offsets will be 4-byte aligned. 
// (Refer to the descriptions of those instructions for more information on the consequences of code array alignment.)

///|
priv struct Disassembler {
  code : &@bytebuf.ByteBuf
  class : @classfile.ClassFile
  found : Array[Instruction]
  jump_table : Map[Int, (Opcode, Label)]
  offsets : Array[Int]
}

///|
pub struct DisassembleResult {
  offsetToIndex : Map[Int, Int]
  instructions : Array[Instruction]
}

///|
pub fn disassemble(
  code : &@bytebuf.ByteBuf,
  class : @classfile.ClassFile,
) -> DisassembleResult raise {
  let disasm = Disassembler::{
    code,
    class,
    found: Array::makei(0, _ => panic()),
    jump_table: {},
    offsets: Array::makei(0, _ => panic()),
  }
  disasm.parse_code()
  let jmp = disasm.jump_table
  let offsets = disasm.offsets
  let mut insertedInsns = 0
  let offsetToIndex : Map[Int, Int] = {}
  for i = 0; i < offsets.length(); i = i + 1 {
    let offset = offsets[i]
    guard jmp.get(offset) is Some((_, label)) else { continue }
    offsetToIndex[offset] = i + insertedInsns
    disasm.found.insert(i + insertedInsns, LabelInsn(label))
    insertedInsns = insertedInsns + 1
  }
  DisassembleResult::{ offsetToIndex, instructions: disasm.found }
}

///|
fn parse_code(self : Disassembler) -> Unit raise {
  let constant = self.class.constant_pool
  let code = self.code
  let offsets = self.offsets
  while code.has_remaining() {
    offsets.push(code.position())
    guard code.read_byte() is Some(opcode)
    let insn = opcode.to_int()
    let insn = match insn {
      ACONST_NULL => Instruction::ConstInsn(ACONST_NULL, None)
      42..=43 as index =>
        Instruction::VarInsn(ALOAD, Some(index.reinterpret_as_uint() - 42)) // aload_0
      ANEWARRAY => {
        let name = code
          .read_uint()
          .fmap(c => constant.at(c.reinterpret_as_int()).class_info())
          .fmap(c => constant.at(c.name_index.reinterpret_as_int()).utf8_info())
          .unwrap()
        Instruction::NewArrayInsn(ANEWARRAY, 1, Reference(name))
      }
      LRETURN | IRETURN | DRETURN | ARETURN | FRETURN =>
        Instruction::ControlFlowInsn(insn, None)
      75..=78 as index =>
        Instruction::VarInsn(ASTORE, (index.reinterpret_as_uint() - 75) |> Some)
      BIPUSH =>
        Instruction::ConstInsn(
          BIPUSH,
          code.read_byte().unwrap().to_uint() |> Some,
        )
      SIPUSH => ConstInsn(SIPUSH, code.read_uint16().map(it => it.to_uint()))
      NEW | INSTANCEOF | CHECKCAST =>
        Instruction::TypeInsn(
          insn,
          code
          .read_uint16()
          .fmap(c => constant.at(c.to_int()).class_info())
          .fmap(c => constant.at(c.name_index.reinterpret_as_int()).utf8_info())
          .unwrap(),
        )
      DREM
      | DNEG
      | DMUL
      | DDIV
      | DCMPG
      | DCMPL
      | FCMPG
      | FCMPL
      | D2F
      | ATHROW
      | D2I
      | DSUB
      | DUP
      | DUP_X1
      | SWAP
      | DUP_X2
      | DUP2
      | DUP2_X1
      | DUP2_X2
      | F2D
      | F2I
      | F2L
      | FMUL
      | FNEG
      | FREM
      | FDIV
      | I2B
      | ISHL
      | ISHR
      | I2C
      | I2D
      | I2F
      | I2L
      | I2S
      | LSHL
      | LSHR
      | IAND
      | IADD
      | IDIV
      | FADD
      | IOR
      | IREM
      | IMUL
      | INEG
      | ISUB
      | IUSHR
      | IXOR
      | L2D
      | L2F
      | LCMP
      | L2I
      | LADD
      | LAND
      | LDIV
      | LMUL
      | LNEG
      | LSUB
      | LUSHR
      | LXOR
      | NOP
      | POP
      | POP2
      | MONITORENTER
      | MONITOREXIT
      | LOR
      | D2L
      | FSUB
      | DASTORE
      | DALOAD
      | LALOAD
      | CALOAD
      | CASTORE
      | SALOAD
      | SASTORE
      | LASTORE
      | IASTORE
      | BALOAD
      | FALOAD
      | IALOAD
      | FASTORE
      | BASTORE
      | ARRAYLENGTH
      | AALOAD
      | AASTORE
      | DADD => Instruction::Insn(insn)
      NEWARRAY =>
        Instruction::NewArrayInsn(
          insn,
          1,
          code.read_byte().fmap(it => to_array_type(it)).unwrap(),
        )
      DCONST_0 => Instruction::ConstInsn(DCONST_0, Some(0))
      DCONST_1 => Instruction::ConstInsn(DCONST_1, Some(1))
      LLOAD | ILOAD | DLOAD | FLOAD | ALOAD =>
        Instruction::VarInsn(insn, code.read_byte().unwrap().to_uint() |> Some)
      30..=33 => VarInsn(LLOAD, Some(insn.reinterpret_as_uint() - 30))
      26..=29 as i => VarInsn(ILOAD, Some(i.reinterpret_as_uint() - 26))
      38..=41 as i =>
        VarInsn(DLOAD, Some(i - 38).map(it => it.reinterpret_as_uint())) // dload
      LSTORE | ISTORE | DSTORE | FSTORE | ASTORE =>
        Instruction::VarInsn(insn, code.read_byte().map(it => it.to_uint()))
      63..=66 => VarInsn(LSTORE, Some(insn.reinterpret_as_uint() - 63))
      59..=62 as i => VarInsn(ISTORE, Some(i.reinterpret_as_uint() - 59))
      71..=74 as i =>
        Instruction::VarInsn(DSTORE, Some(i.reinterpret_as_uint() - 71))
      FCONST_0..=FCONST_2 as i =>
        ConstInsn(insn, Some(i.reinterpret_as_uint() - 11)) // fconst_n
      34..=37 as i =>
        Instruction::VarInsn(FLOAD, Some(i.reinterpret_as_uint() - 34))
      67..=70 as i => VarInsn(FSTORE, Some(i.reinterpret_as_uint() - 67))
      PUTSTATIC | PUTFIELD | GETSTATIC | GETFIELD =>
        FieldInsn(
          insn,
          code
          .read_uint16()
          .fmap(c => constant.at(c.to_int()).field_ref_info())
          .unwrap(),
        )
      ICONST_M1..=ICONST_5 as index =>
        VarInsn(index, Some(index.reinterpret_as_uint() - 3))
      LCONST_0 | LCONST_1 =>
        ConstInsn(insn, Some(insn.reinterpret_as_uint() - 9))
      LDC =>
        LdcInsn(code.read_byte().map(c => constant.at(c.to_int())).unwrap())
      LDC2_W | LDC_W =>
        LdcInsn(code.read_uint16().map(c => constant.at(c.to_int())).unwrap())
      IINC =>
        IincInsn(
          code.read_byte().map(it => it.to_uint()).unwrap(),
          code.read_byte().unwrap().to_int(),
        )
      INVOKEDYNAMIC =>
        InvocationInsn(
          INVOKEDYNAMIC,
          Dynamic(
            code
            .read_uint16()
            .fmap(c => constant.at(c.to_int()).invoke_dynamic_info())
            .unwrap(),
          ),
        )
      INVOKESPECIAL | INVOKESTATIC | INVOKEVIRTUAL =>
        InvocationInsn(
          insn,
          Normal(
            code
            .read_uint16()
            .fmap(c => constant.at(c.to_int()).method_ref_info())
            .unwrap(),
          ),
        )
      INVOKEINTERFACE =>
        InvocationInsn(
          INVOKEINTERFACE,
          Interface(
            code
            .read_uint16()
            .fmap(c => constant.at(c.to_int()).interface_method_ref_info())
            .unwrap(),
          ),
        )
      MULTIANEWARRAY => {
        let name = code
          .read_uint16()
          .fmap(c => constant.at(c.to_int()).class_info())
          .fmap(c => constant.at(c.name_index.reinterpret_as_int()).utf8_info())
          .unwrap()
        let dim = code.read_byte().unwrap().to_int()
        Instruction::NewArrayInsn(MULTIANEWARRAY, dim, Reference(name))
      }
      WIDE => parse_wide(code)
      RETURN => ControlFlowInsn(insn, None)
      RET => RetInsn(code.read_byte().map(it => it.to_uint()).unwrap())
      c => self.parse_flow_insn(c)
    }
    self.found.push(insn)
  }
}

///|
fn assign_new_label(self : Disassembler) -> Label {
  Label("L\{self.jump_table.size()}")
}

///|
fn parse_flow_insn(self : Disassembler, insn : Int) -> Instruction {
  fn read_offset() -> Int {
    self.code.read_int16().map(it => it.to_int()).unwrap() +
    self.code.position()
  }

  fn read_offset_32() -> Int {
    self.code.read_int().unwrap() + self.code.position()
  }

  match insn {
    GOTO
    | IF_ICMPEQ
    | IF_ICMPGE
    | IF_ACMPEQ
    | IF_ACMPNE
    | IF_ICMPGT
    | IF_ICMPLE
    | IF_ICMPLT
    | IF_ICMPNE
    | IFNE
    | IFEQ
    | IFGE
    | IFGT
    | IFLT
    | IFLE
    | IFNONNULL
    | IFNULL
    | JSR => {
      let label = self.assign_new_label()
      self.jump_table[read_offset()] = (insn, label)
      ControlFlowInsn(insn, Some(label))
    }
    GOTO_W | JSR_W => {
      let label = self.assign_new_label()
      self.jump_table[read_offset_32()] = (insn, label)
      ControlFlowInsn(insn, Some(label))
    }
    TABLESWITCH => {
      guard self.code.read_bytes(3) is Some([0, 0, 0])  // JVMS requirement
      let default = read_offset_32()
      let defaultLabel = self.assign_new_label()
      self.jump_table[default] = (insn, defaultLabel)
      let low = self.code.read_int().unwrap()
      let high = self.code.read_int().unwrap()
      let labels : Array[Label] = Array::makei(high - low + 1, _ => {
        let label = self.assign_new_label()
        let offset = read_offset_32()
        self.jump_table[offset] = (insn, label)
        label
      })
      return SwitchInsn(
        Table(TableSwitch::{
          default_label: defaultLabel,
          low,
          high,
          labels: FixedArray::from_array(labels),
        }),
      )
    }
    LOOKUPSWITCH => {
      guard self.code.read_bytes(3) is Some([0, 0, 0])  // JVMS requirement
      let default = read_offset_32()
      let defaultLabel = self.assign_new_label()
      self.jump_table[default] = (insn, defaultLabel)
      let npairs = self.code.read_int().unwrap()
      let labels = Array::makei(npairs, _ => {
        guard self.code.read_int() is Some(_)  // match value
        let offset = read_offset_32()
        let label = self.assign_new_label()
        self.jump_table[offset] = (insn, label)
        label
      })
      return SwitchInsn(
        Lookup(LookupSwitch::{
          default_label: defaultLabel,
          match_offset_pairs: FixedArray::from_array(labels.map(it => (0, it))),
        }),
      )
    }
    _ => panic()
  }
}

///|
fn parse_wide(code : &@bytebuf.ByteBuf) -> Instruction raise {
  let insn = code.read_byte().unwrap().to_int()
  return match insn {
    ILOAD | FLOAD | ALOAD | LLOAD | DLOAD =>
      VarInsn(insn, code.read_uint16().map(it => it.to_uint()))
    ISTORE | FSTORE | ASTORE | LSTORE | DSTORE =>
      VarInsn(insn, code.read_uint16().map(it => it.to_uint()))
    RET => ControlFlowInsn(RET, None)
    IINC =>
      IincInsn(
        code.read_byte().map(it => it.to_uint()).unwrap(),
        code.read_byte().unwrap().to_int(),
      )
    _ => raise fail("invalid wide instruction")
  }
}

///|
fn[T, N] fmap(self : T?, mapper : (T) -> N?) -> N? {
  self.map(mapper).flatten()
}

///|
fn to_array_type(b : Byte) -> ArrayType? {
  return Some(
    match b {
      4 => ArrayType::T_BOOLEAN
      5 => ArrayType::T_CHAR
      6 => ArrayType::T_FLOAT
      7 => ArrayType::T_DOUBLE
      8 => ArrayType::T_BYTE
      9 => ArrayType::T_SHORT
      10 => ArrayType::T_INT
      11 => ArrayType::T_LONG
      _ => return None
    },
  )
}
