///|
fn parse_annotation(
  self : &@bytebuf.ByteBuf,
  constant : @classfile.ConstantPool,
) -> @classfile.Annotation raise {
  guard self.read_uint16() is Some(type_index) else {
    raise fail("Unexpected EOF when reading annotation.")
  }
  let type_entry = constant.at(type_index.to_int())
  guard type_entry is Utf8(type_descriptor) else {
    raise fail("Expect constant entry `utf8` but got \{type_entry.to_string()}")
  }
  guard self.read_uint16() is Some(num_element_value_pairs) else {
    raise fail("Unexpected EOF when reading annotation.")
  }
  let element_value_pairs = FixedArray::makei(
    num_element_value_pairs.to_int(),
    _ => {
      guard self.read_uint16() is Some(element_name_index) else {
        raise fail("Unexpected EOF when reading annotation.")
      }
      let name_entry = constant.at(element_name_index.to_int())
      guard name_entry is Utf8(name) else {
        raise fail("Expect constant entry `utf8` but got \{name_entry.to_string()}")
      }
      @classfile.ElementValuePair::{
        element_name: name,
        value: self.parse_element_value(constant),
      }
    },
  )
  @classfile.Annotation::{ type_descriptor, element_value_pairs }
}

///|
fn parse_element_value(
  self : &@bytebuf.ByteBuf,
  constant : @classfile.ConstantPool,
) -> @classfile.ElementValue raise {
  guard self.read_byte() is Some(tag) else {
    raise fail("Unexpected EOF when reading element value.")
  }
  return match tag {
    b'B' | b'C' | b'D' | b'F' | b'I' | b'J' | b'S' | b'Z' | b's' => {
      guard self.read_uint16() is Some(constantvalue_index) else {
        raise fail("Unexpected EOF when reading element value.")
      }
      let entry = constant.at(constantvalue_index.to_int())
      @classfile.ElementValue::ConstantEntry(entry)
    }
    b'e' => {
      guard self.read_bytes(2 + 2) is Some(data) &&
        data is [u16(type_name_index), u16(const_name_index)] else {
        raise fail("Unexpected EOF when reading element value.")
      }
      let type_name_entry = constant.at(type_name_index.reinterpret_as_int())
      guard type_name_entry is Utf8(type_name) else {
        raise fail("Expect constant entry `utf8` but got \{type_name_entry.to_string()}")
      }
      let const_name_entry = constant.at(const_name_index.reinterpret_as_int())
      guard const_name_entry is Utf8(const_name) else {
        raise fail("Expect constant entry `utf8` but got \{const_name_entry.to_string()}")
      }
      @classfile.ElementValue::EnumConst(@classfile.ElementEnumConstant::{
        type_name,
        const_name,
      })
    }
    b'c' => {
      guard self.read_uint16() is Some(class_info_index) else {
        raise fail("Unexpected EOF when reading element value.")
      }
      let class_info_entry = constant.at(class_info_index.to_int())
      guard class_info_entry is Utf8(class_info) else {
        raise fail("Expect constant entry `utf8` but got \{class_info_entry.to_string()}")
      }
      @classfile.ElementValue::ClassInfo(class_info)
    }
    b'@' => {
      let annotation = self.parse_annotation(constant)
      @classfile.ElementValue::AnnotationValue(annotation)
    }
    b'[' => {
      guard self.read_uint16() is Some(num_values) else {
        raise fail("Unexpected EOF when reading element value.")
      }
      let values = FixedArray::makei(num_values.to_int(), _ => self.parse_element_value(
        constant,
      ))
      Array(values)
    }
    c => raise fail("Unexpected element value tag \{c}")
  }
}

///|
fn parse_type_annotation(
  self : &@bytebuf.ByteBuf,
  constant : @classfile.ConstantPool,
) -> @classfile.TypeAnnotation raise {
  guard self.read_byte() is Some(target_type) else {
    raise fail("EOF when reading type annotation")
  }
  let targetInfo : @classfile.TypeAnnotationTargetInfo = self.parse_type_annotation_target(
    target_type,
  )
  let typePath = self.parse_type_path()
  guard self.read_bytes(4) is Some([u16(typeIndex), u16(numElementValuePairs)]) else {
    raise fail("EOF when reading type annotation")
  }
  let descriptor = constant.at(typeIndex.reinterpret_as_int())
  guard descriptor is Utf8(typeDescriptor) else {
    return fail("Expect utf8 but got \{descriptor.to_string()}")
  }
  let elementPairs = FixedArray::makei(
    numElementValuePairs.reinterpret_as_int(),
    _ => {
      guard self.read_uint16().map(it => constant.at(it.to_int()))
        is Some(Utf8(name)) else {
        raise fail("Invalid type annotation")
      }
      @classfile.ElementValuePair::{
        element_name: name,
        value: self.parse_element_value(constant),
      }
    },
  )
  @classfile.TypeAnnotation::{
    target_type,
    target_info: targetInfo,
    type_path: typePath,
    type_descriptor: typeDescriptor,
    element_value_pairs: elementPairs,
  }
}

///|
fn parse_type_path(self : &@bytebuf.ByteBuf) -> @classfile.TypePath raise {
  let len = self.read_byte().unwrap()
  FixedArray::makei(len.to_int(), _ => {
    guard self.read_bytes(2) is Some([u1(typePathKind), u1(typeArgIndex)]) else {
      raise fail("EOF when reading type path")
    }
    let typeArgIndex = typeArgIndex.to_byte()
    match typePathKind {
      0 => @classfile.ArrayType(typeArgIndex)
      1 => @classfile.NestedType(typeArgIndex)
      2 => @classfile.WildcardType(typeArgIndex)
      3 => @classfile.TypeArgument(typeArgIndex)
      what => raise fail("Unexpected type path part kind: \{what}")
    }
  })
}

///|
fn parse_type_annotation_target(
  self : &@bytebuf.ByteBuf,
  target_type : Byte,
) -> @classfile.TypeAnnotationTargetInfo raise {
  match target_type {
    0x00 | 0x01 => {
      // formal parameter target
      guard self.read_byte() is Some(typeParamTarget) else {
        raise fail("EOF when reading type parameter target")
      }
      TypeParameterTarget(typeParamTarget)
    }
    0x10 => {
      // super
      guard self.read_uint16() is Some(superTypeIndex) else {
        raise fail("EOF when reading super type index")
      }
      SuperTypeTarget(superTypeIndex)
    }
    0x11 | 0x12 => {
      guard self.read_bytes(2) is Some([u1(typeParamIndex), u1(boundIndex)]) else {
        raise fail("EOF when reading typeParamIndex and boundIndex")
      }
      BoundTarget(typeParamIndex.to_byte(), boundIndex.to_byte())
    }
    0x13 | 0x14 | 0x15 => EmptyTarget
    0x16 => {
      // formal parameter target
      guard self.read_byte() is Some(formalParamIndex) else {
        raise fail("EOF when reading formal parameter target")
      }
      FormalParameterTarget(formalParamIndex)
    }
    0x17 => {
      // throws
      guard self.read_uint16() is Some(throwsTypeIndex) else {
        raise fail("EOF when reading throwsTypeIndex")
      }
      ThrowsTarget(throwsTypeIndex.to_byte())
    }
    0x40 | 0x41 => {
      // localvar_target
      guard self.read_uint16() is Some(table_length) else {
        raise fail("EOF when reading table_length")
      }
      LocalVarTarget(
        FixedArray::makei(table_length.to_int(), _ => @classfile.LocalVarTargetEntry::{
          start_pc: self.read_uint16().unwrap(),
          length: self.read_uint16().unwrap(),
          index: self.read_uint16().unwrap(),
        }),
      )
    }
    0x42 => {
      // catch
      guard self.read_uint16() is Some(catchIndex) else {
        raise fail("EOF when reading catchIndex")
      }
      CatchTarget(catchIndex.to_byte())
    }
    0x43 | 0x44 | 0x45 | 0x46 => {
      // offset target
      guard self.read_uint16() is Some(offset) else {
        raise fail("EOF when reading offset target")
      }
      OffsetTarget(offset)
    }
    0x47 | 0x48 | 0x49 | 0x4A | 0x4B => {
      // type argument target
      guard self.read_bytes(3) is Some([u16(offset), u1(typeArgIndex)]) else {
        raise fail("EOF when reading type argument target")
      }
      TypeArgumentTarget(
        offset.reinterpret_as_int().to_uint16(),
        typeArgIndex.to_byte(),
      )
    }
    c => raise fail("invalid target_type: \{c}")
  }
}
