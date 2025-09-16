///|
pub fn parse_class(view : &@bytebuf.ByteBuf) -> @classfile.ClassFile raise {
  // A class file consists of a stream of 8-bit bytes. 16-bit and 32-bit quantities are constructed by reading in two 
  // and four consecutive 8-bit bytes, respectively. Multibyte data items are always stored in big-endian order
  // where the high bytes come first. This chapter defines the data types u1, u16, and u32 to represent an unsigned one-, two-
  // or four-byte quantity, respectively.

  // u32             magic;
  // u16             minor_version;
  // u16             major_version;
  guard view.read_bytes(4 + 2 + 2)
    is Some([u32(magic), u16(minor), u16(major), ..]) else {
    raise fail("Expect class header but EOF.")
  }
  guard magic == @classfile.JavaClassFile else {
    raise fail("Invalid class file magic number.")
  }
  // u16             constant_pool_count;
  let constant_pool = view.parse_constant_pool()
  // u16             access_flags;
  // u16             this_class;
  // u16             super_class;
  guard view.read_uint16() is Some(accessFlags)
  guard view.read_bytes(2 + 2) is Some([u16(thisClassIdx), u16(superClassIdx)]) else {
    raise fail("Expect class header but EOF.")
  }
  let _thisClass = constant_pool.at(thisClassIdx.reinterpret_as_int())
  guard _thisClass is @classfile.Class(thisClass) else {
    raise fail("Unexpected thisClass type: \{_thisClass}")
  }
  let mut superClass : @classfile.ConstantClassInfo? = None
  if superClassIdx != 0 {
    guard constant_pool.at(superClassIdx.reinterpret_as_int())
      is @classfile.Class(sc)
    superClass = Some(sc)
  }
  let interfaces = view
    .parse_interfaces()
    .map(u => {
      guard constant_pool.at(u.reinterpret_as_int()) is Class(classInfo)
      classInfo
    })
  let fields = view.parse_fields(constant_pool)
  let methods = view.parse_methods(constant_pool)
  let attributes = view.parse_attributes(constant_pool)
  @classfile.ClassFile::{
    minor_version: minor.reinterpret_as_int().to_uint16(),
    major_version: major.reinterpret_as_int().to_uint16(),
    constant_pool: constant_pool,
    access_flags: accessFlags,
    this_class: thisClass,
    super_class: superClass,
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
  @classfile.ConstantPool::{
    internal_arr: FixedArray::makei(count.to_int() - 1, _ => self.parse_constant_entry()),
  }
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
