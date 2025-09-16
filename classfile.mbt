///|
pub(all) struct ClassFile {
  minor_version: UInt16
  major_version: UInt16
  constant_pool: ConstantPool
  access_flags: Modifiers
  this_class: String
  super_class: String?
  interfaces: FixedArray[String]
  fields: FixedArray[FieldInfo]
  methods: FixedArray[MethodInfo]
  attributes: FixedArray[AttributeInfo]
} derive(Show)

///|
pub const JavaClassFile : UInt = 0xCAFEBABE