///|
pub fn parse_descriptor_method(input : String) -> @classfile.MethodType raise {
  guard input.length() >= 3 else { // the shortest possible input is ()V
    raise fail("Invalid method descriptor \{input}")
  }
  let leftQuote = input.find("(").unwrap()
  let rightQuote = input.find(")").unwrap()
  guard leftQuote == 0 && rightQuote > leftQuote else {
    raise fail("Invalid method descriptor \{input}")
  }
  let arguments = Array::make(0, @classfile.Int)
  let mut searchIndex = 1
  while searchIndex + leftQuote < rightQuote {
    let now = searchIndex + leftQuote
    let b = input.get_char(now).unwrap()
    match b {
      'L' => {
        let end = input[now:rightQuote].find(";").unwrap()
        arguments.push(
          parse_descriptor_type(input[now:now + end + 1].to_string()),
        )
        searchIndex = now + end
      }
      '[' => {
        let next = input.get_char(now + 1).unwrap()
        if next != 'L' {
          arguments.push(Array(parse_descriptor_type("\{next}")))
          searchIndex += 1
        } else {
          let end = input[now:rightQuote].find(";").unwrap()
          arguments.push(
            parse_descriptor_type(input[now:now + end + 1].to_string()),
          )
          searchIndex = now + end
        }
      }
      c => arguments.push(parse_descriptor_type("\{c}"))
    }
    searchIndex += 1
  }
  let returnType = parse_descriptor_type(input[rightQuote + 1:].to_string())
  @classfile.MethodType::{
    parameters: FixedArray::from_array(arguments),
    return_type: returnType,
  }
}

///|
pub fn parse_descriptor_type(input : String) -> @classfile.JavaTypes raise {
  match input {
    "I" => Int
    "J" => Long
    "Z" => Boolean
    "D" => Double
    "C" => Char
    "F" => Float
    "V" => Void
    "S" => Short
    ['[', .. remaining] => Array(parse_descriptor_type(remaining.to_string()))
    ['L', .. remaining, ';'] => Object(remaining.to_string())
    c => raise fail("Unknown descriptor type: \{c}")
  }
}
