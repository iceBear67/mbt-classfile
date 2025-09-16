pub(all) struct FieldInfo {
  access_flags: Modifiers
  name: String
  descriptor: String
  attributes: FixedArray[AttributeInfo]
} derive (Show, Eq)

pub(all) struct MethodInfo {
  access_flags: Modifiers
  name: String
  descriptor: String
  attributes: FixedArray[AttributeInfo]
} derive (Show, Eq)