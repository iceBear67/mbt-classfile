///|
test "complex signature" {
  let expect =
    #|{type_parameters: [], parameters: [RefType(ClassType({class_internal_name: "java/lang/WithGeneric", type_arguments: [TypeArg({indicator: None, class_bound: TypeVar("SomeArg")})], outer_class: None}))], throws: [], result: None}
  inspect(
    @parser.parse_signature_method("(Ljava/lang/WithGeneric<TSomeArg;>;)V"),
    content=expect,
  )
  let input =
    #|<T::Ljava/lang/CharSequence;V:Lcom/example/Type;:Lcom/example/Type2;X:TOtherParam;>(Ljava/lang/WithGeneric<TSomeArg;*+Ljava/lang/Super;>.GenericChild<Ljava/lang/String;>;TT;I)V^Lcom/example/Exception;^TGenericException;
  let expect =
    #|{type_parameters: [{identifier: "T", class_bound: ClassType({class_internal_name: "java/lang/Object", type_arguments: [], outer_class: None}), interface_bound: [ClassType({class_internal_name: "java/lang/CharSequence", type_arguments: [], outer_class: None})]}, {identifier: "V", class_bound: ClassType({class_internal_name: "com/example/Type", type_arguments: [], outer_class: None}), interface_bound: [ClassType({class_internal_name: "com/example/Type2", type_arguments: [], outer_class: None})]}, {identifier: "X", class_bound: TypeVar("OtherParam"), interface_bound: []}], parameters: [RefType(ClassType({class_internal_name: "GenericChild", type_arguments: [TypeArg({indicator: None, class_bound: ClassType({class_internal_name: "java/lang/String", type_arguments: [], outer_class: None})})], outer_class: Some({class_internal_name: "java/lang/WithGeneric", type_arguments: [TypeArg({indicator: None, class_bound: TypeVar("SomeArg")}), Unknown, Wildcard({bound: ClassType({class_internal_name: "java/lang/Super", type_arguments: [], outer_class: None}), indicator: Extends})], outer_class: None})})), RefType(TypeVar("T")), BaseType('I')], throws: [ClassType({class_internal_name: "com/example/Exception", type_arguments: [], outer_class: None}), TypeVar("GenericException")], result: None}
  inspect(@parser.parse_signature_method(input), content=expect)
}

///|
test "simple method signature" {
  let input = "()V"
  let result = @parser.parse_signature_method(input)
  assert_eq(result.type_parameters.length(), 0)
  assert_eq(result.parameters.length(), 0)
  assert_eq(result.throws.length(), 0)
  assert_eq(result.result, None)
}

///|
test "basic parameter types" {
  let input = "(IJBSFDCZ)I"
  let result = @parser.parse_signature_method(input)
  assert_eq(result.parameters.length(), 8)
  assert_eq(result.result, Some(BaseType('I')))
}

///|
test "reference type parameter" {
  let input = "(Ljava/lang/String;)V"
  let result = @parser.parse_signature_method(input)
  assert_eq(result.parameters.length(), 1)
}

///|
test "array type parameter" {
  let input = "([Ljava/lang/Object;)V"
  let result = @parser.parse_signature_method(input)
  assert_eq(result.parameters.length(), 1)
}

///|
test "type variable" {
  let input = "<T:Ljava/lang/Object;T:TO;>(TT;)V"
  let result = @parser.parse_signature_method(input)
  assert_eq(result.type_parameters.length(), 2)
  assert_eq(result.parameters.length(), 1)
  let expect =
    #|{type_parameters: [{identifier: "T", class_bound: ClassType({class_internal_name: "java/lang/Object", type_arguments: [], outer_class: None}), interface_bound: []}, {identifier: "T", class_bound: TypeVar("O"), interface_bound: []}], parameters: [RefType(TypeVar("T"))], throws: [], result: None}
  inspect(result, content=expect)
}
