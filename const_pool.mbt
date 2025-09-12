// https://docs.oracle.com/javase/specs/jvms/se11/html/jvms-4.html#jvms-4.4


pub typealias FixedArray[ConstantType] as ConstantPool
///|
pub(all) enum ConstantType {
  Class(ConstantClassInfo)
  FieldRef(ConstantFieldRefInfo)
  MethodRef(ConstantMethodRefInfo)
  InterfaceMethodRef(ConstantInterfaceMethodRefInfo)
  String(ConstantStringInfo)
  Integer(ConstantIntegerInfo)
  Float(ConstantFloatInfo)
  Long(ConstantLongInfo)
  Double(ConstantDoubleInfo)
  NameAndType(ConstantNameAndTypeInfo)
  Utf8(String)
  MethodHandle(ConstantMethodHandleInfo)
  MethodType(ConstantMethodTypeInfo)
  Dynamic(ConstantDynamicInfo)
  InvokeDynamic(ConstantInvokeDynamicInfo)
  Module(ConstantModuleInfo)
  Package(ConstantPackageInfo)
} derive(Show, Eq)

///|
pub(all) struct ConstantClassInfo {
  name_index : UInt
} derive(Show, Eq)

///|
pub(all) struct ConstantFieldRefInfo {
  class_index : UInt
  name_and_type_index : UInt
} derive(Show, Eq)

///|
pub(all) struct ConstantMethodRefInfo {
  class_index : UInt
  name_and_type_index : UInt
} derive(Show, Eq)

///|
pub(all) struct ConstantInterfaceMethodRefInfo {
  class_index : UInt
  name_and_type_index : UInt
} derive(Show, Eq)

///|
pub(all) struct ConstantStringInfo {
  string_index : UInt
} derive(Show, Eq)

///|
pub(all) struct ConstantIntegerInfo {
  bytes : Int
} derive(Show, Eq)

///|
pub(all) struct ConstantFloatInfo {
  bytes : Float
} derive(Show, Eq)

///|
pub(all) struct ConstantLongInfo {
  value : Int64
} derive(Show, Eq)

///|
pub(all) struct ConstantDoubleInfo {
  value : Double
} derive(Show, Eq)

///|
pub(all) struct ConstantNameAndTypeInfo {
  name_index : UInt
  descriptor_index : UInt
} derive(Show, Eq)

///|
pub(all) struct ConstantMethodHandleInfo {
  reference_kind : Byte
  reference_index : UInt
} derive(Show, Eq)

///|
pub(all) struct ConstantMethodTypeInfo {
  descriptor_index : UInt
} derive(Show, Eq)

///|
pub(all) struct ConstantDynamicInfo {
  bootstrap_method_attr_index : UInt
  name_and_type_index : UInt
} derive(Show, Eq)

///|
pub(all) struct ConstantInvokeDynamicInfo {
  bootstrap_method_attr_index : UInt
  name_and_type_index : UInt
} derive(Show, Eq)

///|
pub(all) struct ConstantModuleInfo {
  name_index : UInt
} derive(Show, Eq)

///|
pub(all) struct ConstantPackageInfo {
  name_index : UInt
} derive(Show, Eq)

///|
pub fn to_byte(t : ConstantType) -> Byte {
  match t {
    ConstantType::Class(_) => 7
    ConstantType::FieldRef(_) => 9
    ConstantType::MethodRef(_) => 10
    ConstantType::InterfaceMethodRef(_) => 11
    ConstantType::String(_) => 8
    ConstantType::Integer(_) => 3
    ConstantType::Float(_) => 4
    ConstantType::Long(_) => 5
    ConstantType::Double(_) => 6
    ConstantType::NameAndType(_) => 12
    ConstantType::Utf8(_) => 1
    ConstantType::MethodHandle(_) => 15
    ConstantType::MethodType(_) => 16
    ConstantType::Dynamic(_) => 17
    ConstantType::InvokeDynamic(_) => 18
    ConstantType::Module(_) => 19
    ConstantType::Package(_) => 20
  }
}