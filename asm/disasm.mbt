// When the code array is read into memory on a byte-addressable machine, 
// if the first byte of the array is aligned on a 4-byte boundary, the tableswitch and lookupswitch 32-bit offsets will be 4-byte aligned. 
// (Refer to the descriptions of those instructions for more information on the consequences of code array alignment.)

///|
pub fn parse_code(
  code : &@bytebuf.ByteBuf,
  class : @classfile.ClassFile,
) -> Iter[Instruction] {
  let constant = class.constant_pool
  return Iter::new(_yield => {
    guard code.read_byte() is Some(opcode) else { IterEnd }
    let insn = opcode.to_int()
    return _yield(
      match insn {
        ACONST_NULL => Instruction::ConstInsn(ACONST_NULL, None)
        42..=43 as index =>
          Instruction::VarInsn(ALOAD, Some(index.reinterpret_as_uint() - 42)) // aload_0
        ANEWARRAY => {
          let name = code
            .read_uint()
            .fmap(c => constant.at(c.reinterpret_as_int()).class_info())
            .fmap(c => constant
              .at(c.name_index.reinterpret_as_int())
              .utf8_info())
            .unwrap()
          Instruction::TypeInsn(ANEWARRAY, name)
        }
        LRETURN| IRETURN | DRETURN | ARETURN | FRETURN => Instruction::ControlFlowInsn(insn, None)
        75..=78 as index =>
          Instruction::VarInsn(
            ASTORE,
            (index.reinterpret_as_uint() - 75) |> Some,
          )
        BIPUSH =>
          Instruction::ConstInsn(
            BIPUSH,
            code.read_byte().unwrap().to_uint() |> Some,
          )
        SIPUSH => ConstInsn(SIPUSH, code.read_uint16().map(it=>it.to_uint()))
        NEW | INSTANCEOF | CHECKCAST =>
          Instruction::TypeInsn(
            insn,
            code
            .read_uint16()
            .fmap(c => constant.at(c.to_int()).class_info())
            .fmap(c => constant
              .at(c.name_index.reinterpret_as_int())
              .utf8_info())
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
        |LSHR
        | IAND
        | IADD
        | IDIV
        | FADD
        | IOR
        | IREM
        | IMUL
        |INEG
        | ISUB
        | IUSHR
        |IXOR
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
        |MONITOREXIT
        | LOR
        | IREM
        | D2L
        | FSUB
        | DADD => Instruction::Insn(insn)
        DASTORE
        | DALOAD
        | LALOAD
        | CALOAD
        | CASTORE
        | SALOAD
        | SASTORE
        |LASTORE
        | IASTORE
        | BALOAD
        | FALOAD
        | IALOAD
        | FASTORE
        | BASTORE
        | ARRAYLENGTH
        | AALOAD
        | AASTORE => Instruction::ArrayInsn(insn, None)
        NEWARRAY => Instruction::ArrayInsn(insn, ) //todo rdesign array isn
        DCONST_0 => Instruction::ConstInsn(DCONST_0, Some(0))
        DCONST_1 => Instruction::ConstInsn(DCONST_1, Some(1))
        LLOAD | ILOAD | DLOAD | FLOAD | ALOAD =>
          Instruction::VarInsn(
            insn,
            code.read_byte().unwrap().to_uint() |> Some,
          )
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
        GOTO => ControlFlowInsn(GOTO) //todo label
        GOTO_W => ControlFlowInsn(GOTO_W)
        ICONST_M1..=ICONST_5 as index =>
          VarInsn(index, Some(index.reinterpret_as_uint() - 3))
        LCONST_0 | LCONST_1 => ConstInsn(insn, Some(insn.reinterpret_as_uint() -9))
        LDC => LdcInsn(code.read_byte().map(c => constant.at(c.to_int())).unwrap())
        LDC2_W | LDC_W => LdcInsn(code.read_uint16().map(c => constant.at(c.to_int())).unwrap())
        IF_ACMPEQ | IF_ACMPNE => ControlFlowInsn(insn)
        IF_ICMPEQ
        | IF_ICMPGE
        | IF_ICMPGT
        | IF_ICMPLE
        | IF_ICMPLT
        | IF_ICMPLT
        | IF_ICMPNE
        | IFNE
        | IFEQ
        | IFGE
        | IFGT
        | IFLT
        | IFLE
        | IFNONNULL
        | IFNULL => ControlFlowInsn(insn)
        IINC => ... // todo
        // bootstrap method
        INVOKEDYNAMIC => InvocationInsn(INVOKEDYNAMIC, code.read_uint16().fmap(c=>constant.at(c.to_int()).invoke_dynamic_info()).unwrap())
        INVOKEINTERFACE | INVOKESPECIAL | INVOKESTATIC | INVOKEVIRTUAL |  => InvocationInsn(INVOKEINTERFACE,)
        JSR => ControlFlowInsn(insn)
        JSR_W => ControlFlowInsn(insn)
        TABLESWITCH => ...
        LOOKUPSWITCH => ...
        MULTIANEWARRAY => ...
        RET => ControlFlowInsn(insn)
        RETURN => ControlFlowInsn(insn, None)
        WIDE => parse_wide(code)
      },
    )
  })
}

fn parse_wide(code: &@bytebuf.ByteBuf) -> Instruction {
  ...
}

///|
fn[T, N] fmap(self : T?, mapper : (T) -> N?) -> N? {
  self.map(mapper).flatten()
}
