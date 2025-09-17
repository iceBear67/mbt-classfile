///|
pub(all) enum JavaTypes {
  Object(String)
  Int
  Long
  Double
  Float
  Byte
  Short
  Boolean
  Char
  Void
  Array(JavaTypes)
} derive(Eq, Show)

///|
pub fn to_simple_name(self : JavaTypes) -> String {
  match self {
    Void => "void"
    Char => "char"
    Boolean => "boolean"
    Short => "short"
    Byte => "byte"
    Float => "float"
    Double => "double"
    Long => "long"
    Int => "int"
    Object(o) => {
      let index = o.rev_find("/").unwrap_or(0)
      let result = (try? o[index+1:]).unwrap()
      result.to_string()
    }
    Array(arr) => arr.to_simple_name() + "[]"
  }
}

///|
pub(all) struct MethodType {
  parameters : FixedArray[JavaTypes]
  return_type : JavaTypes
} derive(Eq, Show)