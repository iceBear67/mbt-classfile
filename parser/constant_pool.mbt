///|
fn parse_const_class_info(buf : &@bytebuf.ByteBuf) -> @classfile.ConstantClassInfo raise {
  guard buf.read_uint16() is Some(name_index) else {
    raise fail("Invalid @classfile.Constant pool entry.")
  }
  @classfile.ConstantClassInfo::{ name_index: name_index.to_uint() }
}

///|
fn parse_const_fieldref_info(
  buf : &@bytebuf.ByteBuf,
) -> @classfile.ConstantFieldRefInfo raise {
  guard buf.read_bytes(2 + 2) is Some(data) &&
    data is [u2(class_index), u2(name_and_type_index)] else {
    raise fail("Invalid @classfile.Constant pool entry.")
  }
  @classfile.ConstantFieldRefInfo::{ class_index, name_and_type_index }
}

///|
fn parse_const_methodref_info(
  buf : &@bytebuf.ByteBuf,
) -> @classfile.ConstantMethodRefInfo raise {
  guard buf.read_bytes(2 + 2) is Some(data) &&
    data is [u2(class_index), u2(name_and_type_index)] else {
    raise fail("Invalid @classfile.Constant pool entry.")
  }
  @classfile.ConstantMethodRefInfo::{ class_index, name_and_type_index }
}

///|
fn parse_const_interfacemethodref_info(
  buf : &@bytebuf.ByteBuf,
) -> @classfile.ConstantInterfaceMethodRefInfo raise {
  guard buf.read_bytes(2 + 2) is Some(data) &&
    data is [u2(class_index), u2(name_and_type_index)] else {
    raise fail("Invalid @classfile.Constant pool entry.")
  }
  @classfile.ConstantInterfaceMethodRefInfo::{ class_index, name_and_type_index }
}

///|
fn parse_const_string_info(buf : &@bytebuf.ByteBuf) -> @classfile.ConstantStringInfo raise {
  guard buf.read_uint16() is Some(string_index) else {
    raise fail("Invalid @classfile.Constant pool entry.")
  }
  @classfile.ConstantStringInfo::{ string_index: string_index.to_uint() }
}

///|
fn parse_const_integer_info(
  buf : &@bytebuf.ByteBuf,
) -> @classfile.ConstantIntegerInfo raise {
  guard buf.read_uint() is Some(int) else {
    raise fail("Invalid @classfile.Constant pool entry.")
  }
  @classfile.ConstantIntegerInfo::{ bytes: int.reinterpret_as_int() }
}

///|
fn parse_const_float_info(buf : &@bytebuf.ByteBuf) -> @classfile.ConstantFloatInfo raise {
  guard buf.read_uint() is Some(int) else {
    raise fail("Invalid @classfile.Constant pool entry.")
  }
  @classfile.ConstantFloatInfo::{ bytes: int.reinterpret_as_float() }
}

///|
fn parse_const_long_info(buf : &@bytebuf.ByteBuf) -> @classfile.ConstantLongInfo raise {
  guard buf.read_bytes(8) is Some(data) && data is [u4(high), u4(low)] else {
    raise fail("Invalid @classfile.Constant pool entry.")
  }
  let value = ((high.to_uint64() << 32) | low.to_uint64()).reinterpret_as_int64()
  @classfile.ConstantLongInfo::{ value }
}

///|
fn parse_const_double_info(buf : &@bytebuf.ByteBuf) -> @classfile.ConstantDoubleInfo raise {
  let value = parse_const_long_info(buf).value.to_double()
  @classfile.ConstantDoubleInfo::{ value }
}

///|
fn parse_const_name_and_type_info(
  buf : &@bytebuf.ByteBuf,
) -> @classfile.ConstantNameAndTypeInfo raise {
  guard buf.read_bytes(2 + 2) is Some(data) &&
    data is [u2(name_index), u2(descriptor_index)] else {
    raise fail("Invalid @classfile.Constant pool entry.")
  }
  @classfile.ConstantNameAndTypeInfo::{ name_index, descriptor_index }
}

///|
/// JVMS specifies modified UTF-8, which encodes \u0000 to 2-byte representation, and it's still compatible with standard UTF-8 when parsing.
fn parse_const_utf8_info(buf : &@bytebuf.ByteBuf) -> String raise {
  guard buf.read_uint16() is Some(length) else {
    raise fail("Invalid @classfile.Constant pool entry.")
  }
  guard buf.read_bytes(length.to_int()) is Some(data) else {
    raise fail("Invalid @classfile.Constant pool entry.")
  }
  @encoding.decoder(UTF8).decode(data)
}

///|
fn parse_const_method_handle_info(
  buf : &@bytebuf.ByteBuf,
) -> @classfile.ConstantMethodHandleInfo raise {
  guard buf.read_bytes(1 + 2) is Some(data) &&
    data is [u1(reference_kind), u2(reference_index)] else {
    raise fail("Invalid @classfile.Constant pool entry.")
  }
  @classfile.ConstantMethodHandleInfo::{ reference_kind: reference_kind.to_byte(), reference_index }
}

///|
fn parse_const_method_type_info(buf : &@bytebuf.ByteBuf) -> @classfile.ConstantMethodTypeInfo raise {
  guard buf.read_uint16() is Some(descriptor_index) else {
    raise fail("Invalid @classfile.Constant pool entry.")
  }
  @classfile.ConstantMethodTypeInfo::{ descriptor_index: descriptor_index.to_uint() }
}

///|
fn parse_const_dynamic_info(buf : &@bytebuf.ByteBuf) -> @classfile.ConstantDynamicInfo raise {
  guard buf.read_bytes(2 + 2) is Some(data) &&
    data is [u2(bootstrap_method_attr_index), u2(name_and_type_index)] else {
    raise fail("Invalid @classfile.Constant pool entry.")
  }
  @classfile.ConstantDynamicInfo::{ bootstrap_method_attr_index, name_and_type_index }
}

///|
fn parse_const_invoke_dynamic_info(
  buf : &@bytebuf.ByteBuf,
) -> @classfile.ConstantInvokeDynamicInfo raise {
  guard buf.read_bytes(2 + 2) is Some(data) &&
    data is [u2(bootstrap_method_attr_index), u2(name_and_type_index)] else {
    raise fail("Invalid @classfile.Constant pool entry.")
  }
  @classfile.ConstantInvokeDynamicInfo::{ bootstrap_method_attr_index, name_and_type_index }
}

///|
fn parse_const_module_info(buf : &@bytebuf.ByteBuf) -> @classfile.ConstantModuleInfo raise {
  guard buf.read_uint16() is Some(name_index) else {
    raise fail("Invalid @classfile.Constant pool entry.")
  }
  @classfile.ConstantModuleInfo::{ name_index: name_index.to_uint() }
}

///|
fn parse_const_package_info(buf : &@bytebuf.ByteBuf) -> @classfile.ConstantPackageInfo raise {
  guard buf.read_uint16() is Some(name_index) else {
    raise fail("Invalid @classfile.Constant pool entry.")
  }
  @classfile.ConstantPackageInfo::{ name_index: name_index.to_uint() }
}
