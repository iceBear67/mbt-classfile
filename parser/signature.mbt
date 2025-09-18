///| These codes are subject to refactor.

///|
pub fn parse_signature(input : String) -> @classfile.JavaSignature raise {
  return @bytebuf.make_unpooled_from_bytes(@encoding.encode(UTF8, input))
    |> parse_signature_buf
}

///|
pub fn parse_signature_method(
  input : String,
) -> @classfile.MethodSignature raise {
  return @bytebuf.make_unpooled_from_bytes(@encoding.encode(UTF8, input))
    |> parse_signature_method_buf
}

///|
fn parse_signature_method_buf(
  input : &@bytebuf.ByteBuf,
) -> @classfile.MethodSignature raise {
  let _ = input.mark()
  let mut params : FixedArray[@classfile.TypeParameter] = []
  if input.read_char() is Some('<') {
    params = parse_type_parameters(input)
  } else {
    input.reset()
  }
  guard input.read_char() is Some('(')
  let args : Array[@classfile.JavaSignature] = Array::makei(0, _ => panic())
  while true {
    let _ = input.mark()
    let ch = input.read_char().unwrap()
    if ch == ')' {
      break
    }
    input.reset()
    args.push(parse_signature_buf(input))
  }
  let _ = input.mark()
  let returnType = if input.read_char() is Some('V') {
    None
  } else {
    input.reset()
    Some(parse_signature_buf(input))
  }
  let throws : Array[@classfile.RefTypeSig] = Array::makei(0, _ => panic())
  while input.read_char() is Some('^') {
    guard parse_signature_buf(input) is RefType(r)
    throws.push(r)
  } else {
    input.reset()
  }
  input.reset()
  return @classfile.MethodSignature::{
    type_parameters: params,
    parameters: args |> FixedArray::from_array,
    throws: throws |> FixedArray::from_array,
    result: returnType,
  }
}

///|
fn parse_type_var(input : &@bytebuf.ByteBuf) -> @classfile.RefTypeSig {
  guard input.read_char() is Some('T')
  let r = input.read_until(';') |> @classfile.RefTypeSig::TypeVar
  let _ = input.read_byte()
  r
}

///|
fn parse_signature_buf(
  input : &@bytebuf.ByteBuf,
) -> @classfile.JavaSignature raise {
  let _ = input.mark()
  guard input.read_char() is Some(leading) else {
    raise fail("Unexpected EOF when parsing signature.")
  }
  match leading {
    // base types: 
    // B C D F I J S Z
    'B' | 'C' | 'D' | 'F' | 'I' | 'J' | 'S' | 'Z' => return BaseType(leading)
    'T' => {
      input.reset()
      return parse_type_var(input) |> @classfile.RefType
    }
    '[' =>
      return parse_signature_buf(input) // arr component
        |> @classfile.RefTypeSig::ArrayType
        |> RefType
    'L' => {
      input.reset() // step back
      return parse_class_sig(input) |> RefType
    }
    ch => raise fail("invalid signature. col \{input.position()}, ch: \{ch}")
  }
}

///|
/// Ljava/lang/WithGeneric<TSomeArg;*+Ljava/lang/Super;>.GenericChild<I>;
fn parse_class_sig(
  input : &@bytebuf.ByteBuf,
  child? : Bool = false,
) -> @classfile.RefTypeSig raise {
  if !child {
    let ch = input.read_char()
    guard ch is Some('L') else {
      raise fail(
        "Unexpected class sig provided: \{ch}, pos: \{input.position()}",
      )
    }
  }
  let sb = StringBuilder::new()
  while input.has_remaining() {
    match input.read_char().unwrap() {
      '<' => {
        let name = sb.to_string()
        let typeParam = parse_type_arguments(input)
        let _ = input.mark()
        let this = @classfile.ClassTypeSig::{
          class_internal_name: name,
          type_arguments: typeParam,
          outer_class: None,
        }
        if input.read_char().unwrap() == '.' {
          // inner
          let sub = parse_class_sig(input, child=true)
          guard sub is ClassType(sub)
          return @classfile.ClassTypeSig::{ ..sub, outer_class: Some(this) }
            |> ClassType
        }
        return this |> ClassType
      }
      ';' =>
        return @classfile.ClassTypeSig::{
            class_internal_name: sb.to_string(),
            type_arguments: [],
            outer_class: None,
          }
          |> ClassType
      ch => sb.write_char(ch)
    }
  }
  raise fail("Unclosed class signature")
}

// expect: TSomeArg;*+Ljava/lang/Super;>

///|
fn parse_type_arguments(
  input : &@bytebuf.ByteBuf,
) -> FixedArray[@classfile.TypeArguments] raise {
  let foundArguments : Array[@classfile.TypeArguments] = Array::makei(0, _ => panic())
  while true {
    let _ = input.mark()
    let ch = input.read_char().unwrap()
    if ch == '>' {
      break
    }
    match ch {
      '*' =>
        foundArguments.push(Unknown)
      '+' =>
        foundArguments.push(
          @classfile.WildcardTypeSig::{
            bound: parse_class_sig(input),
            indicator: Extends,
          }
          |> Wildcard,
        )
      '-' =>
        foundArguments.push(
          @classfile.WildcardTypeSig::{
            bound: parse_class_sig(input),
            indicator: @classfile.Super,
          }
          |> Wildcard,
        )
      _ => {
        input.reset()
        guard parse_signature_buf(input) is RefType(s)
        let r = @classfile.TypeArgumentSig::{ indicator: None, class_bound: s }
        foundArguments.push(r |> TypeArg)
      }
    }
  }
  FixedArray::from_array(foundArguments)
}

///|
fn parse_type_parameters(
  input : &@bytebuf.ByteBuf,
) -> FixedArray[@classfile.TypeParameter] raise {
  let result : Array[@classfile.TypeParameter] = []
  while input.peek_char().unwrap() != '>' {
    result.push(parse_type_param(input))
  }
  let _ = input.read_char()
  result |> FixedArray::from_array
}

///|
fn parse_type_param(
  input : &@bytebuf.ByteBuf,
) -> @classfile.TypeParameter raise {
  let identifier = input.read_until(':')
  let _ = input.read_byte() // discard semicolon
  // is superclass empty ?
  let _ = input.mark()
  let mut super = @classfile.reftype_Object
  let superInterface : Array[@classfile.RefTypeSig] = Array::makei(0, _ => panic())
  let l = input.read_char().unwrap()
  input.reset()
  if l != ':' {
    match input.peek_char().unwrap() {
      'L' => super = parse_class_sig(input)
      'T' => super = parse_type_var(input)
      ch => raise fail("Invalid signature at \{input.position()}")
    }
  }
  let _ = input.mark()
  let mut ch = input.read_char().unwrap()
  while ch == ':' {
    // may end or class_ref
    if input.peek_char() is Some('L') {
      superInterface.push(parse_class_sig(input))
      let _ = input.mark()
      ch = input.read_char().unwrap()
    } else {
      break
    }
  } else {
    input.reset()
  }
  @classfile.TypeParameter::{
    identifier,
    class_bound: super,
    interface_bound: superInterface |> FixedArray::from_array,
  }
}

///|
fn read_until(self : &@bytebuf.ByteBuf, ch : Char) -> String {
  let begin = self.mark()
  while self.has_remaining() && self.read_char() is Some(c) && c != ch {

  }
  let len = self.position() - begin - 1
  self.reset()
  let content = self.read_bytes(len).unwrap()
  return content.to_fixedarray().map(it => it.to_char().to_string()).join("")
}

///|
fn read_char(self : &@bytebuf.ByteBuf) -> Char? {
  return self.read_byte().map(it => it.to_char())
}

///|
fn peek_char(self : &@bytebuf.ByteBuf) -> Char? {
  let _ = self.mark()
  let r = self.read_char()
  self.reset()
  return r
}
