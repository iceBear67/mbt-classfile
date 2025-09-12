pub(all) struct FieldInfo {
  access_flags: UInt16
  name: String
  descriptor: String
  attributes: FixedArray[AttributeInfo]
}

pub(all) struct MethodInfo {
  access_flags: UInt16
  name: String
  descriptor: String
  attributes: FixedArray[AttributeInfo]
}