///|
test "test descriptor parser" {
  assert_eq(@parser.parse_descriptor_type("I"), @classfile.JavaTypes::Int)
  assert_eq(@parser.parse_descriptor_type("J"), @classfile.JavaTypes::Long)
  assert_eq(@parser.parse_descriptor_type("Z"), @classfile.JavaTypes::Boolean)
  assert_eq(@parser.parse_descriptor_type("D"), @classfile.JavaTypes::Double)
  assert_eq(@parser.parse_descriptor_type("C"), @classfile.JavaTypes::Char)
  assert_eq(@parser.parse_descriptor_type("F"), @classfile.JavaTypes::Float)
  assert_eq(@parser.parse_descriptor_type("V"), @classfile.JavaTypes::Void)
  assert_eq(@parser.parse_descriptor_type("S"), @classfile.JavaTypes::Short)
  assert_eq(
    @parser.parse_descriptor_type("Ljava/lang/String;"),
    @classfile.JavaTypes::Object("java/lang/String"),
  )
  inspect(
    @parser.parse_descriptor_method("()V"),
    content="{parameters: [], return_type: Void}"
  )
  let expect =
    #|{parameters: [Int, Long, Boolean, Double, Char, Float, Void, Short, Array(Object("java/lang/Object"))], return_type: Void}
  inspect(
    @parser.parse_descriptor_method("(IJZDCFVS[Ljava/lang/Object;)V"),
    content=expect,
  )
}
