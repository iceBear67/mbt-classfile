///|
pub fn parse_class(view : &@bytebuf.ByteBuf) -> @classfile.ClassFile raise {
  // A class file consists of a stream of 8-bit bytes. 16-bit and 32-bit quantities are constructed by reading in two 
  // and four consecutive 8-bit bytes, respectively. Multibyte data items are always stored in big-endian order
  // where the high bytes come first. This chapter defines the data types u1, u2, and u4 to represent an unsigned one-, two-
  // or four-byte quantity, respectively.

  // u4             magic;
  // u2             minor_version;
  // u2             major_version;
  // u2             constant_pool_count;
  guard view.read_bytes(4 + 2 + 2 + 2) is Some(data) else {
    raise fail("Expect class header but EOF.")
  }
  guard data[:] is [u4(magic), u2(minor), u2(major)] &&
    magic == @classfile.JavaClassFile else {
    raise fail("Invalid class file magic number.")
  }
  let constant_pool = view.parse_constant_pool()
  // u2             access_flags;
  // u2             this_class;
  // u2             super_class;
  guard view.read_uint16() is Some(accessFlags)
  guard view.read_bytes(2 + 2) is Some([u2(thisClassIdx), u2(superClassIdx)]) else {
    raise fail("Expect class header but EOF.")
  }
  guard constant_pool[thisClassIdx.reinterpret_as_int()]
    is @classfile.Utf8(thisClass)
  let mut superClass : String? = None
  if superClassIdx != 0 {
    guard constant_pool[superClassIdx.reinterpret_as_int()]
      is @classfile.Utf8(sc)
    superClass = Some(sc)
  }
  let interfaces = view
    .parse_interfaces()
    .map(u => {
      guard constant_pool[u.reinterpret_as_int()] is Class(classInfo)
      classInfo
    })
  let fields = view.parse_fields(constant_pool)
  let methods = view.parse_methods(constant_pool)
  let attributes = view.parse_attributes(constant_pool)
  @classfile.ClassFile::{
    minorVersion: minor.reinterpret_as_int().to_uint16(),
    majorVersion: major.reinterpret_as_int().to_uint16(),
    constantPool: constant_pool,
    accessFlags,
    thisClass: thisClass,
    superClass,
    interfaces,
    fields,
    methods,
    attributes,
  }
}

///|
fn parse_attributes(
  self : &@bytebuf.ByteBuf,
  constant : @classfile.ConstantPool,
) -> FixedArray[@classfile.AttributeInfo] raise {
  guard self.read_uint16() is Some(count)
  FixedArray::makei(count.to_int(), _ => self.parse_attribute_info(constant))
}

///|
fn parse_methods(
  self : &@bytebuf.ByteBuf,
  constant : @classfile.ConstantPool,
) -> FixedArray[@classfile.MethodInfo] raise {
  guard self.read_uint16() is Some(count) else {
    raise fail("Invalid methods count.")
  }
  FixedArray::makei(count.to_int(), _ => self.parse_method_info(constant))
}

///|
fn parse_fields(
  self : &@bytebuf.ByteBuf,
  constant : @classfile.ConstantPool,
) -> FixedArray[@classfile.FieldInfo] raise {
  guard self.read_uint16() is Some(count) else {
    raise fail("Invalid fields count.")
  }
  FixedArray::makei(count.to_int(), _ => self.parse_field_info(constant))
}

///|
fn parse_interfaces(self : &@bytebuf.ByteBuf) -> FixedArray[UInt] raise {
  guard self.read_uint16() is Some(count) else {
    raise fail("Invalid interfaces count.")
  }
  FixedArray::makei(count.to_int(), _ => {
    guard self.read_uint16() is Some(index) else {
      raise fail("Invalid interface index.")
    }
    index.to_uint()
  })
}

///|
fn parse_constant_pool(
  self : &@bytebuf.ByteBuf,
) -> @classfile.ConstantPool raise {
  guard self.read_uint16() is Some(count) else {
    raise fail("Invalid constant pool count.")
  }
  FixedArray::makei(count.to_int(), _ => self.parse_constant_entry())
}

///|
fn parse_constant_entry(
  self : &@bytebuf.ByteBuf,
) -> @classfile.ConstantType raise {
  guard self.read_byte() is Some(tag) else {
    raise fail("Expect constant pool entry but EOF.")
  }
  match tag {
    7 => @classfile.ConstantType::Class(parse_const_class_info(self))
    9 => @classfile.ConstantType::FieldRef(parse_const_fieldref_info(self))
    10 => @classfile.ConstantType::MethodRef(parse_const_methodref_info(self))
    11 =>
      @classfile.ConstantType::InterfaceMethodRef(
        parse_const_interfacemethodref_info(self),
      )
    8 => @classfile.ConstantType::String(parse_const_string_info(self))
    3 => @classfile.ConstantType::Integer(parse_const_integer_info(self))
    4 => @classfile.ConstantType::Float(parse_const_float_info(self))
    5 => @classfile.ConstantType::Long(parse_const_long_info(self))
    6 => @classfile.ConstantType::Double(parse_const_double_info(self))
    12 =>
      @classfile.ConstantType::NameAndType(parse_const_name_and_type_info(self))
    1 => @classfile.ConstantType::Utf8(parse_const_utf8_info(self))
    15 =>
      @classfile.ConstantType::MethodHandle(
        parse_const_method_handle_info(self),
      )
    16 =>
      @classfile.ConstantType::MethodType(parse_const_method_type_info(self))
    17 => @classfile.ConstantType::Dynamic(parse_const_dynamic_info(self))
    18 =>
      @classfile.ConstantType::InvokeDynamic(
        parse_const_invoke_dynamic_info(self),
      )
    19 => @classfile.ConstantType::Module(parse_const_module_info(self))
    20 => @classfile.ConstantType::Package(parse_const_package_info(self))
    _ => raise fail("Unknown constant pool tag: " + tag.to_string())
  }
}
