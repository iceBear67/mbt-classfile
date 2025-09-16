fn parse_method_info(self: &@bytebuf.ByteBuf, constant_pool: @classfile.ConstantPool) -> @classfile.MethodInfo raise {
  guard self.read_bytes(2 * 4) is Some([u16(access_flags), u16(name_index), u16(descriptor_index), u16(attributes_count)]) else {
    raise fail("Invalid method info.")
  }
  guard constant_pool.at(name_index.reinterpret_as_int()) is Utf8(name) else {
    raise fail("Invalid method name index.")
  }
  guard constant_pool.at(descriptor_index.reinterpret_as_int()) is Utf8(descriptor) else {
    raise fail("Invalid method descriptor index.")
  }
  @classfile.MethodInfo::{
    access_flags: access_flags.reinterpret_as_int().to_uint16(),
    name: name,
    descriptor: descriptor,
    attributes: FixedArray::makei(attributes_count.reinterpret_as_int(), _ => self.parse_attribute_info(constant_pool))
  }
}

fn parse_field_info(self: &@bytebuf.ByteBuf, constant_pool: @classfile.ConstantPool) -> @classfile.FieldInfo raise {
  guard self.read_bytes(2*4) is Some([u16(access_flags), u16(name_index), u16(descriptor_index), u16(attributes_count)]) && 
  constant_pool.at(name_index.reinterpret_as_int()) is @classfile.Utf8(fieldName) && constant_pool.at(descriptor_index.reinterpret_as_int()) is @classfile.Utf8(descriptor)

  let attributes = FixedArray::makei(attributes_count.reinterpret_as_int(), _ => {
    self.parse_attribute_info(constant_pool)
  })

  @classfile.FieldInfo::{
    access_flags: access_flags.reinterpret_as_int().to_uint16(),
    name: fieldName,
    descriptor: descriptor,
    attributes: attributes
  }
}