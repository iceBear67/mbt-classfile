///|
test "example" {
  let class = @parser.parse_class(
    @bytebuf.make_unpooled_from_bytes(
      @fs.read_file_to_bytes("test-data/ControlFlow.class"),
    ),
  )
  let blocks_to_method: Map[String, Array[Array[@asm.Instruction]]] = {}
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
        SwitchInsn(Table(_)) | SwitchInsn(Lookup(_)) | ControlFlowInsn(_, _) => { // opcode, label are omitted
          current_block.push(instruction)
          basic_blocks.push(current_block)
          current_block = Array::makei(0, _ => panic())
        }
        _ => current_block.push(instruction)
      }
    }
    if !current_block.is_empty() {
      basic_blocks.push(current_block) 
    }
    blocks_to_method[method.name] = basic_blocks
  }
  let expect =
  #|{"<init>": [[ALOAD index:Some("0"), INVOKESPECIAL target:java/lang/Object ()V, RETURN #None]], "reallyIHaveToControlYou": [[ILOAD index:Some("0"), ISTORE index:Some("1"), ILOAD index:Some("0"), Label Label("L2"):, ILOAD index:Some("0"), IMUL, ISTORE index:Some("2"), ILOAD index:Some("1"), ILOAD index:Some("2"), IF_ICMPLE #Some("L0")], [GOTO #Some("L1")], [ILOAD index:Some("2"), ISTORE index:Some("0"), ILOAD index:Some("0"), Label Label("L0"):, BIPUSH Some("90"), IF_ICMPLT #Some("L2")], [RETURN #None]]}
  inspect(blocks_to_method, content = expect)
}

///|
fn find_constant_println(instructions : Array[@asm.Instruction]) -> Bool {
  return match instructions {
    [
      FieldInsn(@asm.GETSTATIC, fieldInfo),
      LdcInsn(ldc),
      InvocationInsn(@asm.INVOKEVIRTUAL, Normal(method)),
      ..,
    ] => {
      guard fieldInfo.name_and_type().map(it => it.descriptor()).flatten()
        is Some("Ljava/io/PrintStream;") &&
        method.method_name_and_type().map(it => it.descriptor()).flatten()
        is Some("(Ljava/lang/String;)V") else {
        return false
      }
      println("Found constant println at the beginning, content: \{ldc}")
      true
    }
    _ => false
  }
}
