///|
fn parse_stackmap_frame(
  self : &@bytebuf.ByteBuf,
  constant : @classfile.ConstantPool,
) -> @classfile.StackMapFrame raise {
  guard self.read_byte() is Some(frame_type) else {
    raise fail("Unexpected EOF when reading stackmap frame.")
  }
  return match frame_type {
    0..=63 => SameFrame
    64..=127 => {
      let stack = self.parse_verification_type(constant)
      SameLocals1StackItemFrame(stack)
    }
    128..=246 => raise fail("Reserved stackmapframe types were used.")
    247 => {
      guard self.read_uint16() is Some(offset_delta) else {
        raise fail("Unexpected EOF when reading stackmap frame.")
      }
      let stack = self.parse_verification_type(constant)
      SameLocals1StackItemFrameExtended(@classfile.SameLocalOneFrameExt::{
        offset_delta,
        stack,
      })
    }
    248..=250 => {
      guard self.read_uint16() is Some(offset_delta) else {
        raise fail("Unexpected EOF when reading stackmap frame.")
      }
      ChopFrame(offset_delta)
    }
    251 => {
      guard self.read_uint16() is Some(offset_delta) else {
        raise fail("Unexpected EOF when reading stackmap frame.")
      }
      SameFrameExtended(offset_delta)
    }
    252..=254 => {
      guard self.read_uint16() is Some(offset_delta) else {
        raise fail("Unexpected EOF when reading stackmap frame.")
      }
      let locals_count = (frame_type - 251).to_int()
      let locals = FixedArray::makei(locals_count, _ => self.parse_verification_type(
        constant,
      ))
      AppendFrame(@classfile.AppendFrame::{ offset_delta, locals })
    }
    255 => {
      guard self.read_uint16() is Some(offset_delta) else {
        raise fail("Unexpected EOF when reading stackmap frame.")
      }
      guard self.read_uint16() is Some(number_of_locals) else {
        raise fail("Unexpected EOF when reading stackmap frame.")
      }
      let locals = FixedArray::makei(number_of_locals.to_int(), _ => self.parse_verification_type(
        constant,
      ))
      guard self.read_uint16() is Some(number_of_stack_items) else {
        raise fail("Unexpected EOF when reading stackmap frame.")
      }
      let stack = FixedArray::makei(number_of_stack_items.to_int(), _ => self.parse_verification_type(
        constant,
      ))
      FullFrame(@classfile.FullFrame::{ offset_delta, locals, stack })
    }
  }
}

///|
fn parse_verification_type(
  self : &@bytebuf.ByteBuf,
  constant : @classfile.ConstantPool,
) -> @classfile.VerificationTypeInfo raise {
  guard self.read_byte() is Some(_type) else {
    raise fail(
      "Unexpected EOF when reading verification type of stackmaptable.",
    )
  }
  match _type {
    0 => TopVariable // ITEM_top
    1 => Integer // ITEM_integer
    2 => Float // ITEM_float
    5 => Null // ITEM_null
    6 => UninitializedThis // ITEM_uninitializedThis
    7 => { // ITEM_object
      guard self.read_uint16() is Some(cpool_index) else {
        raise fail(
          "Unexpected EOF when reading verification type of stackmaptable.",
        )
      }
      let entry = constant.at(cpool_index.to_int())
      guard entry is Class(classInfo) else {
        raise fail("Expect constant entry `class info` but got \{entry.to_string()}")
      }
      Object(classInfo)
    }
    8 => { // ITEM_uninitialized
      guard self.read_uint16() is Some(offset) else {
        raise fail(
          "Unexpected EOF when reading verification type of stackmaptable.",
        )
      }
      Uninitialized(offset)
    }
    4 => Long // ITEM_long
    3 => Double // ITEM_double
    _ => raise fail("Invalid verification type of stackmaptable.")
  }
}
