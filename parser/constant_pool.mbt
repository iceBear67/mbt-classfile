///|
fn parse_const_class_info(
  self : &@bytebuf.ByteBuf,
  parent : Ref[@classfile.ConstantPool],
) -> @classfile.ConstantClassInfo raise {
  guard self.read_uint16() is Some(name_index) else {
    raise fail("Invalid @classfile.Constant pool entry.")
  }
  @classfile.ConstantClassInfo::{ name_index: name_index.to_uint(), parent }
}

///|
fn parse_const_fieldref_info(
  self : &@bytebuf.ByteBuf,
  parent : Ref[@classfile.ConstantPool],
) -> @classfile.ConstantFieldRefInfo raise {
  guard self.read_bytes(2 + 2) is Some(data) &&
    data is [u16(class_index), u16(name_and_type_index)] else {
    raise fail("Invalid @classfile.Constant pool entry.")
  }
  @classfile.ConstantFieldRefInfo::{ class_index, name_and_type_index, parent }
}

///|
fn parse_const_methodref_info(
  self : &@bytebuf.ByteBuf,
  parent : Ref[@classfile.ConstantPool],
) -> @classfile.ConstantMethodRefInfo raise {
  guard self.read_bytes(2 + 2) is Some(data) &&
    data is [u16(class_index), u16(name_and_type_index)] else {
    raise fail("Invalid @classfile.Constant pool entry.")
  }
  @classfile.ConstantMethodRefInfo::{ class_index, name_and_type_index, parent }
}

///|
fn parse_const_interfacemethodref_info(
  self : &@bytebuf.ByteBuf,
  parent : Ref[@classfile.ConstantPool],
) -> @classfile.ConstantInterfaceMethodRefInfo raise {
  guard self.read_bytes(2 + 2) is Some(data) &&
    data is [u16(class_index), u16(name_and_type_index)] else {
    raise fail("Invalid @classfile.Constant pool entry.")
  }
  @classfile.ConstantInterfaceMethodRefInfo::{
    class_index,
    name_and_type_index,
    parent,
  }
}

///|
fn parse_const_string_info(
  self : &@bytebuf.ByteBuf,
  parent : Ref[@classfile.ConstantPool],
) -> @classfile.ConstantStringInfo raise {
  guard self.read_uint16() is Some(string_index) else {
    raise fail("Invalid @classfile.Constant pool entry.")
  }
  @classfile.ConstantStringInfo::{
    string_index: string_index.to_uint(),
    parent,
  }
}

///|
fn parse_const_integer_info(
  self : &@bytebuf.ByteBuf,
  parent : Ref[@classfile.ConstantPool],
) -> @classfile.ConstantIntegerInfo raise {
  guard self.read_uint() is Some(int) else {
    raise fail("Invalid @classfile.Constant pool entry.")
  }
  @classfile.ConstantIntegerInfo::{ bytes: int.reinterpret_as_int(), parent }
}

///|
fn parse_const_float_info(
  self : &@bytebuf.ByteBuf,
  parent : Ref[@classfile.ConstantPool],
) -> @classfile.ConstantFloatInfo raise {
  guard self.read_uint() is Some(int) else {
    raise fail("Invalid @classfile.Constant pool entry.")
  }
  @classfile.ConstantFloatInfo::{ bytes: int.reinterpret_as_float(), parent }
}

///|
fn parse_const_long_info(
  self : &@bytebuf.ByteBuf,
  parent : Ref[@classfile.ConstantPool],
) -> @classfile.ConstantLongInfo raise {
  guard self.read_bytes(8) is Some(data) && data is [u32(high), u32(low)] else {
    raise fail("Invalid @classfile.Constant pool entry.")
  }
  let value = ((high.to_uint64() << 32) | low.to_uint64()).reinterpret_as_int64()
  @classfile.ConstantLongInfo::{ value, parent }
}

///|
fn parse_const_double_info(
  self : &@bytebuf.ByteBuf,
  parent : Ref[@classfile.ConstantPool],
) -> @classfile.ConstantDoubleInfo raise {
  let value = parse_const_long_info(self, parent).value.to_double()
  @classfile.ConstantDoubleInfo::{ value, parent }
}

///|
fn parse_const_name_and_type_info(
  self : &@bytebuf.ByteBuf,
  parent : Ref[@classfile.ConstantPool],
) -> @classfile.ConstantNameAndTypeInfo raise {
  guard self.read_bytes(2 + 2) is Some(data) &&
    data is [u16(name_index), u16(descriptor_index)] else {
    raise fail("Invalid @classfile.Constant pool entry.")
  }
  @classfile.ConstantNameAndTypeInfo::{ name_index, descriptor_index, parent }
}

///|
fn parse_const_method_handle_info(
  self : &@bytebuf.ByteBuf,
  parent : Ref[@classfile.ConstantPool],
) -> @classfile.ConstantMethodHandleInfo raise {
  guard self.read_bytes(1 + 2) is Some(data) &&
    data is [u1(reference_kind), u16(reference_index)] else {
    raise fail("Invalid @classfile.Constant pool entry.")
  }
  @classfile.ConstantMethodHandleInfo::{
    reference_kind: reference_kind.to_byte(),
    reference_index,
    parent,
  }
}

///|
fn parse_const_method_type_info(
  self : &@bytebuf.ByteBuf,
  parent : Ref[@classfile.ConstantPool],
) -> @classfile.ConstantMethodTypeInfo raise {
  guard self.read_uint16() is Some(descriptor_index) else {
    raise fail("Invalid @classfile.Constant pool entry.")
  }
  @classfile.ConstantMethodTypeInfo::{
    descriptor_index: descriptor_index.to_uint(),
    parent,
  }
}

///|
fn parse_const_dynamic_info(
  self : &@bytebuf.ByteBuf,
  parent : Ref[@classfile.ConstantPool],
) -> @classfile.ConstantDynamicInfo raise {
  guard self.read_bytes(2 + 2) is Some(data) &&
    data is [u16(bootstrap_method_attr_index), u16(name_and_type_index)] else {
    raise fail("Invalid @classfile.Constant pool entry.")
  }
  @classfile.ConstantDynamicInfo::{
    bootstrap_method_attr_index,
    name_and_type_index,
    parent,
  }
}

///|
fn parse_const_invoke_dynamic_info(
  self : &@bytebuf.ByteBuf,
  parent : Ref[@classfile.ConstantPool],
) -> @classfile.ConstantInvokeDynamicInfo raise {
  guard self.read_bytes(2 + 2) is Some(data) &&
    data is [u16(bootstrap_method_attr_index), u16(name_and_type_index)] else {
    raise fail("Invalid @classfile.Constant pool entry.")
  }
  @classfile.ConstantInvokeDynamicInfo::{
    bootstrap_method_attr_index,
    name_and_type_index,
    parent,
  }
}

///|
fn parse_const_module_info(
  self : &@bytebuf.ByteBuf,
  parent : Ref[@classfile.ConstantPool],
) -> @classfile.ConstantModuleInfo raise {
  guard self.read_uint16() is Some(name_index) else {
    raise fail("Invalid @classfile.Constant pool entry.")
  }
  @classfile.ConstantModuleInfo::{ name_index: name_index.to_uint(), parent }
}

///|
fn parse_const_package_info(
  self : &@bytebuf.ByteBuf,
  parent : Ref[@classfile.ConstantPool],
) -> @classfile.ConstantPackageInfo raise {
  guard self.read_uint16() is Some(name_index) else {
    raise fail("Invalid @classfile.Constant pool entry.")
  }
  @classfile.ConstantPackageInfo::{ name_index: name_index.to_uint(), parent }
}

///|
/// JVMS specifies modified UTF-8, which encodes \u0000 to 2-byte representation, and it's still compatible with standard UTF-8 when parsing.
fn parse_const_utf8_info(self : &@bytebuf.ByteBuf) -> String raise {
  guard self.read_uint16() is Some(length) else {
    raise fail("Invalid @classfile.Constant pool entry.")
  }
  guard self.read_bytes(length.to_int()) is Some(data) else {
    raise fail("Invalid @classfile.Constant pool entry.")
  }
  try @encoding.decoder(UTF8).decode(data) catch {
    err => raise fail("Failed to decode string \{data}: \{err}")
  } noraise {
    v => return v
  }
}
