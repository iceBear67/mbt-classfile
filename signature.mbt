///|
pub(all) enum JavaSignature {
  RefType(RefTypeSig)
  BaseType(Char)
} derive (Show,Eq)

///|
pub(all) enum RefTypeSig {
  ClassType(ClassTypeSig)
  TypeVar(String)
  ArrayType(JavaSignature)
} derive (Show,Eq)

///|
pub let reftype_Object : RefTypeSig = ClassType(ClassTypeSig::{
  class_internal_name: "java/lang/Object",
  type_arguments: [],
  outer_class: None,
}) 

///|
pub(all) struct ClassTypeSig {
  class_internal_name : String
  type_arguments : FixedArray[TypeArguments]
  outer_class : ClassTypeSig?
} derive (Show,Eq)

///|
pub(all) enum TypeArguments {
  TypeArg(TypeArgumentSig)
  Wildcard(WildcardTypeSig)
  Unknown //*
} derive (Show,Eq)

///|
pub(all) struct TypeArgumentSig {
  indicator : WildcardIndicator?
  class_bound : RefTypeSig

} derive (Show,Eq)

pub(all) struct TypeParameter {
  identifier : String
  class_bound : RefTypeSig
  interface_bound : FixedArray[RefTypeSig]
} derive (Show,Eq)

///|
pub(all) struct WildcardTypeSig {
  bound : RefTypeSig
  indicator : WildcardIndicator
} derive (Show,Eq)

///|
pub(all) enum WildcardIndicator {
  Extends // +
  Super // -
  Unbound // *
} derive (Show,Eq)

///|
pub(all) struct ClassSignature {
  type_parameters : FixedArray[TypeParameter]
  super_class : ClassTypeSig
  super_interfaces : FixedArray[ClassTypeSig]
} derive (Show,Eq)

///|
pub(all) struct MethodSignature {
  type_parameters : FixedArray[TypeParameter]
  parameters : FixedArray[JavaSignature]
  // throws does not have ArrayType inside.
  throws : FixedArray[RefTypeSig]
  // void or java sig
  result : JavaSignature?
} derive (Show,Eq)

///|
pub(all) struct FieldSignature(RefTypeSig) derive (Show,Eq)