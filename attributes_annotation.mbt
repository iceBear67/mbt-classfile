///|
pub(all) struct Annotation {
  type_descriptor : String
  element_value_pairs : FixedArray[ElementValuePair]
}derive (Show, Eq)

///|
pub(all) struct ElementValuePair {
  element_name : String
  value : ElementValue // todo the fucking union
}derive (Show, Eq)

///|
pub(all) struct ElementEnumConstant {
  type_name : String
  const_name : String
}derive (Show, Eq)

// https://docs.oracle.com/javase/specs/jvms/se11/html/jvms-4.html#jvms-4.7.16.1-130

///|
pub(all) enum ElementValue {
  ConstantEntry(ConstantType)
  EnumConst(ElementEnumConstant)
  /// The constant_pool entry at that index must be a CONSTANT_Utf8_info structure (§4.4.7) representing a return descriptor (§4.3.3).
  ///  The return descriptor gives the type corresponding to the class literal represented by this element_value structure.
  ClassInfo(String)
  AnnotationValue(Annotation)
  Array(FixedArray[ElementValue])
}derive (Show, Eq)

///|
pub(all) struct ParameterAnnotation {
  annotations : FixedArray[Annotation]
}derive (Show, Eq)
///|
pub(all) struct TypeAnnotation {
  target_type : Byte
  target_info : TypeAnnotationTargetInfo
  type_path : TypePath
  type_descriptor : String
  element_value_pairs : FixedArray[ElementValuePair]
}derive (Show, Eq)

///|
pub typealias FixedArray[TypePathPart] as TypePath

///|
pub(all) enum TypePathPart {
  ArrayType(Byte)
  NestedType(Byte)
  WildcardType(Byte)
  TypeArgument(Byte)
}derive (Show, Eq)

///|
pub(all) enum TypeAnnotationTargetInfo {
  // type_parameter_index
  TypeParameterTarget(Byte)
  SuperTypeTarget(UInt16)
  BoundTarget(Byte, Byte)
  EmptyTarget
  FormalParameterTarget(Byte)
  ThrowsTarget(Byte)
  LocalVarTarget(FixedArray[LocalVarTargetEntry]) //todo looks like exception table entry
  CatchTarget(Byte)
  OffsetTarget(UInt16)
  TypeArgumentTarget(UInt16, Byte)
}derive (Show, Eq)

///|
pub(all) struct LocalVarTargetEntry {
  start_pc : UInt16
  length : UInt16
  index : UInt16
}derive (Show, Eq)