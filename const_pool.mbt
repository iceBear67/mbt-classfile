// https://docs.oracle.com/javase/specs/jvms/se11/html/jvms-4.html#jvms-4.4

///|
pub(all) struct ConstantPool {
  internal_arr : FixedArray[ConstantType]
} derive(Eq, Show)

///|
pub fn at(self : ConstantPool, idx : Int) -> ConstantType {
  self.internal_arr[idx - 1]
}

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

pub fn class_info(self: ConstantType) -> ConstantClassInfo? {
  if self is Class(clasInfo) {
    return Some(clasInfo)
  }
  None
}

pub fn field_ref_info(self: ConstantType) -> ConstantFieldRefInfo? {
  if self is FieldRef(info) {
    return Some(info)
  }
  None
}

pub fn method_ref_info(self: ConstantType) -> ConstantMethodRefInfo? {
  if self is MethodRef(info) {
    return Some(info)
  }
  None
}

pub fn interface_method_ref_info(self: ConstantType) -> ConstantInterfaceMethodRefInfo? {
  if self is InterfaceMethodRef(info) {
    return Some(info)
  }
  None
}

pub fn string_info(self: ConstantType) -> ConstantStringInfo? {
  if self is String(info) {
    return Some(info)
  }
  None
}

pub fn integer_info(self: ConstantType) -> ConstantIntegerInfo? {
  if self is Integer(info) {
    return Some(info)
  }
  None
}

pub fn float_info(self: ConstantType) -> ConstantFloatInfo? {
  if self is Float(info) {
    return Some(info)
  }
  None
}

pub fn long_info(self: ConstantType) -> ConstantLongInfo? {
  if self is Long(info) {
    return Some(info)
  }
  None
}

pub fn double_info(self: ConstantType) -> ConstantDoubleInfo? {
  if self is Double(info) {
    return Some(info)
  }
  None
}

pub fn name_and_type_info(self: ConstantType) -> ConstantNameAndTypeInfo? {
  if self is NameAndType(info) {
    return Some(info)
  }
  None
}

pub fn utf8_info(self: ConstantType) -> String? {
  if self is Utf8(info) {
    return Some(info)
  }
  None
}

pub fn method_handle_info(self: ConstantType) -> ConstantMethodHandleInfo? {
  if self is MethodHandle(info) {
    return Some(info)
  }
  None
}

pub fn method_type_info(self: ConstantType) -> ConstantMethodTypeInfo? {
  if self is MethodType(info) {
    return Some(info)
  }
  None
}

pub fn dynamic_info(self: ConstantType) -> ConstantDynamicInfo? {
  if self is Dynamic(info) {
    return Some(info)
  }
  None
}

pub fn invoke_dynamic_info(self: ConstantType) -> ConstantInvokeDynamicInfo? {
  if self is InvokeDynamic(info) {
    return Some(info)
  }
  None
}

pub fn module_info(self: ConstantType) -> ConstantModuleInfo? {
  if self is Module(info) {
    return Some(info)
  }
  None
}

pub fn package_info(self: ConstantType) -> ConstantPackageInfo? {
  if self is Package(info) {
    return Some(info)
  }
  None
}

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
