///|
pub(all) struct ClassFile {
  minorVersion: UInt16
  majorVersion: UInt16
  constantPool: ConstantPool
  accessFlags: UInt16
  thisClass: String
  superClass: String?
  interfaces: FixedArray[ConstantClassInfo]
  fields: FixedArray[FieldInfo]
  methods: FixedArray[MethodInfo]
  attributes: FixedArray[AttributeInfo]
}

///|
pub const JavaClassFile : UInt = 0xCAFEBABE