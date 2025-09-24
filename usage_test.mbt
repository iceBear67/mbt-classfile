///|
test "example" {
  let class = @parser.parse_class(
    @bytebuf.make_unpooled_from_bytes(
      @fs.read_file_to_bytes("test-data/Simple.class"),
    ),
  )
  for method in class.methods.iter() {
    guard method.attributes.iter().find_first(it => it is Code(_))
      is Some(Code(code_attr)) else {
      continue
    }
    let insns = @asm.disassemble(
      @bytebuf.make_unpooled_from_bytes(code_attr.code),
      class,
    )
    let basic_blocks : Array[Array[@asm.Instruction]] = Array::makei(0, _ => panic())
    // we don't draw edges here for simplicity
    let mut current_block : Array[@asm.Instruction] = Array::makei(0, _ => panic())
    for instruction in insns {
      match instruction {
        SwitchInsn(Table(_)) | SwitchInsn(Lookup(_)) |
        ControlFlowInsn(_, _) => { // opcode, label are omitted
          basic_blocks.push(current_block)
          current_block = Array::makei(0, _ => panic())
        }
        _ => current_block.push(instruction)
      }
    }
  }
}

fn find_constant_println(instructions: Array[@asm.Instruction]) -> Bool {
  return match instructions {
    [FieldInsn(@asm.GETSTATIC, fieldInfo), LdcInsn(ldc), InvocationInsn(@asm.INVOKEVIRTUAL, Normal(method)), ..] => {
      guard fieldInfo.name_and_type().map(it => it.descriptor()).flatten() is Some ("Ljava/io/PrintStream;") &&
      method.method_name_and_type().map(it=>it.descriptor()).flatten() is Some("(Ljava/lang/String;)V") else {
        return false
      }
      println("Found constant println at the beginning, content: \{ldc}")
      true
    }
    _ => false
  }
}
