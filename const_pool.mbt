// https://docs.oracle.com/javase/specs/jvms/se11/html/jvms-4.html#jvms-4.4

///|
pub(all) struct ConstantPool {
  internal_arr : FixedArray[ConstantType]
} derive(Show)

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
}

// There's a back reference to the table so using derive Show will just blow up the stack..
pub impl Show for ConstantType with output(self, logger) {
  let r = match self {
    ConstantType::Class(info) => "Class \{info.name()}"
    ConstantType::FieldRef(info) => {
      let class = info.field_class_info().unwrap()
      let nat = info.name_and_type().unwrap()
      "FieldRef(class=\{class.name()}, name=\{nat.get_name().unwrap()}, type=\{nat.descriptor().unwrap()})"
    }
    ConstantType::MethodRef(info) => {
      let class = info.method_class_info().unwrap()
      let nat = info.method_name_and_type().unwrap()
      "MethodRef(class=\{class.name()}, name=\{nat.get_name().unwrap()}, type=\{nat.descriptor().unwrap()})"
    }
    ConstantType::InterfaceMethodRef(info) => {
      let class = info.interface_class_info().unwrap()
      let nat = info.interface_name_and_type().unwrap()
      "InterfaceMethodRef(class=\{class.name()}, name=\{nat.get_name().unwrap()}, type=\{nat.descriptor().unwrap()})"
    }
    ConstantType::String(info) => "String(\{info.string().unwrap()})"
    ConstantType::Integer(info) => "Integer(\{info.bytes})"
    ConstantType::Float(info) => "Float(\{info.bytes})"
    ConstantType::Long(info) => "Long(\{info.value})"
    ConstantType::Double(info) => "Double(\{info.value})"
    ConstantType::NameAndType(info) => 
      "NameAndType(name=\{info.get_name().unwrap()}, type=\{info.descriptor().unwrap()})"
    ConstantType::Utf8(s) => "Utf8(\{s})"
    ConstantType::MethodHandle(info) =>
      "MethodHandle(reference_kind=\{info.reference_kind}, reference_index=\{info.reference_index})"
    ConstantType::MethodType(info) => 
      "MethodType(descriptor=\{info.get_descriptor().unwrap()})"
    ConstantType::Dynamic(info) =>
      "Dynamic(bootstrap_method_attr_index=\{info.bootstrap_method_attr_index}, name_and_type_index=\{info.name_and_type_index})"
    ConstantType::InvokeDynamic(info) =>
      "InvokeDynamic(bootstrap_method_attr_index=\{info.bootstrap_method_attr_index}, name_and_type_index=\{info.name_and_type_index})"
    ConstantType::Module(info) => "Module(\{info.module_name().unwrap()})"
    ConstantType::Package(info) => "Package(\{info.package_name().unwrap()})"
  }
  logger.write_string(r)
}

///|
pub fn class_info(self : ConstantType) -> ConstantClassInfo? {
  if self is Class(clasInfo) {
    return Some(clasInfo)
  }
  None
}

///|
pub fn field_ref_info(self : ConstantType) -> ConstantFieldRefInfo? {
  if self is FieldRef(info) {
    return Some(info)
  }
  None
}

///|
pub fn method_ref_info(self : ConstantType) -> ConstantMethodRefInfo? {
  if self is MethodRef(info) {
    return Some(info)
  }
  None
}

///|
pub fn interface_method_ref_info(
  self : ConstantType,
) -> ConstantInterfaceMethodRefInfo? {
  if self is InterfaceMethodRef(info) {
    return Some(info)
  }
  None
}

///|
pub fn string_info(self : ConstantType) -> ConstantStringInfo? {
  if self is String(info) {
    return Some(info)
  }
  None
}

///|
pub fn integer_info(self : ConstantType) -> ConstantIntegerInfo? {
  if self is Integer(info) {
    return Some(info)
  }
  None
}

///|
pub fn float_info(self : ConstantType) -> ConstantFloatInfo? {
  if self is Float(info) {
    return Some(info)
  }
  None
}

///|
pub fn long_info(self : ConstantType) -> ConstantLongInfo? {
  if self is Long(info) {
    return Some(info)
  }
  None
}

///|
pub fn double_info(self : ConstantType) -> ConstantDoubleInfo? {
  if self is Double(info) {
    return Some(info)
  }
  None
}

///|
pub fn name_and_type_info(self : ConstantType) -> ConstantNameAndTypeInfo? {
  if self is NameAndType(info) {
    return Some(info)
  }
  None
}

///|
pub fn utf8_info(self : ConstantType) -> String? {
  if self is Utf8(info) {
    return Some(info)
  }
  None
}

///|
pub fn method_handle_info(self : ConstantType) -> ConstantMethodHandleInfo? {
  if self is MethodHandle(info) {
    return Some(info)
  }
  None
}

///|
pub fn method_type_info(self : ConstantType) -> ConstantMethodTypeInfo? {
  if self is MethodType(info) {
    return Some(info)
  }
  None
}

///|
pub fn dynamic_info(self : ConstantType) -> ConstantDynamicInfo? {
  if self is Dynamic(info) {
    return Some(info)
  }
  None
}

///|
pub fn invoke_dynamic_info(self : ConstantType) -> ConstantInvokeDynamicInfo? {
  if self is InvokeDynamic(info) {
    return Some(info)
  }
  None
}

///|
pub fn module_info(self : ConstantType) -> ConstantModuleInfo? {
  if self is Module(info) {
    return Some(info)
  }
  None
}

///|
pub fn package_info(self : ConstantType) -> ConstantPackageInfo? {
  if self is Package(info) {
    return Some(info)
  }
  None
}

///|
pub(all) struct ConstantClassInfo {
  parent : Ref[ConstantPool]
  name_index : UInt
} derive(Show)

///|
pub fn name(self : ConstantClassInfo) -> String {
  self.parent.val.at(self.name_index.reinterpret_as_int()).utf8_info().unwrap()
}

///|
pub fn field_class_info(self : ConstantFieldRefInfo) -> ConstantClassInfo? {
  self.parent.val.at(self.class_index.reinterpret_as_int()).class_info()
}

///|
pub fn name_and_type(self : ConstantFieldRefInfo) -> ConstantNameAndTypeInfo? {
  self.parent.val
  .at(self.name_and_type_index.reinterpret_as_int())
  .name_and_type_info()
}

///|
pub fn method_class_info(self : ConstantMethodRefInfo) -> ConstantClassInfo? {
  self.parent.val.at(self.class_index.reinterpret_as_int()).class_info()
}

///|
pub fn method_name_and_type(
  self : ConstantMethodRefInfo,
) -> ConstantNameAndTypeInfo? {
  self.parent.val
  .at(self.name_and_type_index.reinterpret_as_int())
  .name_and_type_info()
}

///|
pub fn interface_class_info(
  self : ConstantInterfaceMethodRefInfo,
) -> ConstantClassInfo? {
  self.parent.val.at(self.class_index.reinterpret_as_int()).class_info()
}

///|
pub fn interface_name_and_type(
  self : ConstantInterfaceMethodRefInfo,
) -> ConstantNameAndTypeInfo? {
  self.parent.val
  .at(self.name_and_type_index.reinterpret_as_int())
  .name_and_type_info()
}

///|
pub fn string(self : ConstantStringInfo) -> String? {
  self.parent.val.at(self.string_index.reinterpret_as_int()).utf8_info()
}

///|
pub fn get_name(self : ConstantNameAndTypeInfo) -> String? {
  self.parent.val.at(self.name_index.reinterpret_as_int()).utf8_info()
}

///|
pub fn descriptor(self : ConstantNameAndTypeInfo) -> String? {
  self.parent.val.at(self.descriptor_index.reinterpret_as_int()).utf8_info()
}

///|
pub fn get_descriptor(self : ConstantMethodTypeInfo) -> String? {
  self.parent.val.at(self.descriptor_index.reinterpret_as_int()).utf8_info()
}

///|
pub fn module_name(self : ConstantModuleInfo) -> String? {
  self.parent.val.at(self.name_index.reinterpret_as_int()).utf8_info()
}

///|
pub fn package_name(self : ConstantPackageInfo) -> String? {
  self.parent.val.at(self.name_index.reinterpret_as_int()).utf8_info()
}

///|
pub(all) struct ConstantFieldRefInfo {
  parent : Ref[ConstantPool]
  class_index : UInt
  name_and_type_index : UInt
} derive(Show)

///|
pub(all) struct ConstantMethodRefInfo {
  parent : Ref[ConstantPool]
  class_index : UInt
  name_and_type_index : UInt
} derive(Show)

///|
pub(all) struct ConstantInterfaceMethodRefInfo {
  parent : Ref[ConstantPool]
  class_index : UInt
  name_and_type_index : UInt
} derive(Show)

///|
pub(all) struct ConstantStringInfo {
  parent : Ref[ConstantPool]
  string_index : UInt
} derive(Show)

///|
pub(all) struct ConstantIntegerInfo {
  parent : Ref[ConstantPool]
  bytes : Int
} derive(Show)

///|
pub(all) struct ConstantFloatInfo {
  parent : Ref[ConstantPool]
  bytes : Float
} derive(Show)

///|
pub(all) struct ConstantLongInfo {
  parent : Ref[ConstantPool]
  value : Int64
} derive(Show)

///|
pub(all) struct ConstantDoubleInfo {
  parent : Ref[ConstantPool]
  value : Double
} derive(Show)

///|
pub(all) struct ConstantNameAndTypeInfo {
  parent : Ref[ConstantPool]
  name_index : UInt
  descriptor_index : UInt
} derive(Show)

///|
pub(all) struct ConstantMethodHandleInfo {
  parent : Ref[ConstantPool]
  reference_kind : Byte
  reference_index : UInt
} derive(Show)

///|
pub(all) struct ConstantMethodTypeInfo {
  parent : Ref[ConstantPool]
  descriptor_index : UInt
} derive(Show)

///|
pub(all) struct ConstantDynamicInfo {
  parent : Ref[ConstantPool]
  bootstrap_method_attr_index : UInt
  name_and_type_index : UInt
} derive(Show)

///|
pub(all) struct ConstantInvokeDynamicInfo {
  parent : Ref[ConstantPool]
  bootstrap_method_attr_index : UInt
  name_and_type_index : UInt
} derive(Show)

///|
pub(all) struct ConstantModuleInfo {
  parent : Ref[ConstantPool]
  name_index : UInt
} derive(Show)

///|
pub(all) struct ConstantPackageInfo {
  parent : Ref[ConstantPool]
  name_index : UInt
} derive(Show)

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
