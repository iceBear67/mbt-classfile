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
  guard _thisClass is @classfile.Class(thisClassC) &&
    constant_pool.at(thisClassC.name_index.reinterpret_as_int())
    is Utf8(thisClass) else {
    raise fail("Unexpected thisClass type: \{_thisClass}")
  }
  let mut superClass : String? = None
  if superClassIdx != 0 {
    guard constant_pool.at(superClassIdx.reinterpret_as_int())
      is @classfile.Class(scc) &&
      constant_pool.at(scc.name_index.reinterpret_as_int()) is Utf8(sc)
    superClass = Some(sc)
  }
  let interfaces = view
    .parse_interfaces()
    .map(u => {
      guard constant_pool.at(u.reinterpret_as_int()) is Class(classInfo) &&
        constant_pool.at(classInfo.name_index.reinterpret_as_int())
        is Utf8(name)
      name
    })
  let fields = view.parse_fields(constant_pool)
  let methods = view.parse_methods(constant_pool)
  let attributes = view.parse_attributes(constant_pool)
  @classfile.ClassFile::{
    minor_version: minor.reinterpret_as_int().to_uint16(),
    major_version: major.reinterpret_as_int().to_uint16(),
    constant_pool,
    access_flags: @classfile.to_class_modifiers(accessFlags),
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
  let parent : Ref[@classfile.ConstantPool] = Ref::new(@classfile.ConstantPool::{
    internal_arr: FixedArray::makei(0, _ => panic()),
  }) // dummp ref
  @classfile.ConstantPool::{
    internal_arr: FixedArray::makei(count.to_int() - 1, _ => self.parse_constant_entry(
      parent,
    )),
  }
}

///|
fn parse_constant_entry(
  self : &@bytebuf.ByteBuf,
  par : Ref[@classfile.ConstantPool],
) -> @classfile.ConstantType raise {
  guard self.read_byte() is Some(tag) else {
    raise fail("Expect constant pool entry but EOF.")
  }
  match tag {
    7 => @classfile.ConstantType::Class(self.parse_const_class_info(par))
    9 => @classfile.ConstantType::FieldRef(self.parse_const_fieldref_info(par))
    10 =>
      @classfile.ConstantType::MethodRef(self.parse_const_methodref_info(par))
    11 =>
      @classfile.ConstantType::InterfaceMethodRef(
        self.parse_const_interfacemethodref_info(par),
      )
    8 => @classfile.ConstantType::String(self.parse_const_string_info(par))
    3 => @classfile.ConstantType::Integer(self.parse_const_integer_info(par))
    4 => @classfile.ConstantType::Float(self.parse_const_float_info(par))
    5 => @classfile.ConstantType::Long(self.parse_const_long_info(par))
    6 => @classfile.ConstantType::Double(self.parse_const_double_info(par))
    12 =>
      @classfile.ConstantType::NameAndType(
        self.parse_const_name_and_type_info(par),
      )
    1 => @classfile.ConstantType::Utf8(self.parse_const_utf8_info())
    15 =>
      @classfile.ConstantType::MethodHandle(
        self.parse_const_method_handle_info(par),
      )
    16 =>
      @classfile.ConstantType::MethodType(
        self.parse_const_method_type_info(par),
      )
    17 => @classfile.ConstantType::Dynamic(self.parse_const_dynamic_info(par))
    18 =>
      @classfile.ConstantType::InvokeDynamic(
        self.parse_const_invoke_dynamic_info(par),
      )
    19 => @classfile.ConstantType::Module(self.parse_const_module_info(par))
    20 => @classfile.ConstantType::Package(self.parse_const_package_info(par))
    _ => raise fail("Unknown constant pool tag: " + tag.to_string())
  }
}
