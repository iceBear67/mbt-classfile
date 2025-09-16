///|
pub(all) struct ClassFile {
  minor_version: UInt16
  major_version: UInt16
  constant_pool: ConstantPool
  access_flags: UInt16
  this_class: ConstantClassInfo
  super_class: ConstantClassInfo?
  interfaces: FixedArray[ConstantClassInfo]
  fields: FixedArray[FieldInfo]
  methods: FixedArray[MethodInfo]
  attributes: FixedArray[AttributeInfo]
} derive(Show)

///|
pub const JavaClassFile : UInt = 0xCAFEBABE