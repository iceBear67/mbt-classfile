///|
fn main {
  let args = @sys.get_cli_args()
  guard args is [file] else {
    println("No more than and at least a file should be provided.")
    return
  }
  let bytes = try? @fs.read_file_to_bytes(file)
  guard bytes is Ok(bytes) else {
    println("Cannot read file \{file}")
    return
  }
  let bytes = @bytebuf.make_unpooled_from_bytes(bytes)
  let parsed_class = @parser.parse_class(bytes) catch {
    err => {
      println("Cannot parse class: \{err}")
      return
    }
  }
  print(parsed_class)
}

///|
pub fn print(_self : @classfile.ClassFile) -> Unit {
  let srf = _self.attributes.iter().find_first(it => it is SourceFile(_))
  let header =
    #|Compiled from %compiled_from
    #|%modifiers %class_name
    #|  minor version: %minor
    #|  major version: %major
    #|  flags: %flags_str
    #|  this_class: %this_class
    #|  super_class: %super_class
    #|  interfaces: %interfaces_number, fields: %fields_number, methods: %methods_number, attributes: %attributes_number
  let header = header
    .replace_all(old="%compiled_from", new=srf.to_string())
    .replace_all(
      old="%modifiers",
      new=@classfile.to_modifier_string(_self.access_flags),
    )
    .replace_all(old="%minor", new=_self.minor_version.to_string())
    .replace_all(old="%major", new=_self.major_version.to_string())
    .replace_all(old="%flags_str", new=_self.access_flags.to_string())
    .replace_all(old="%this_class", new=_self.this_class)
    .replace_all(old="%class_name", new=_self.this_class)
    .replace_all(old="%super_class", new=_self.super_class.to_string())
    .replace_all(
      old="%interfaces_number",
      new=_self.interfaces.length().to_string(),
    )
    .replace_all(old="%fields_number", new=_self.fields.length().to_string())
    .replace_all(old="%methods_number", new=_self.methods.length().to_string())
    .replace_all(
      old="%attributes_number",
      new=_self.attributes.length().to_string(),
    )
  println(header)
  println("\nConstant pool:")
  for i, entry in _self.constant_pool.internal_arr {
    println("  #\{i} = \{entry.to_string()}")
  }
  println("Fields:")
  for field in _self.fields {
    println(
      "  \{@classfile.to_modifier_string(field.access_flags)} \{field.descriptor} \{field.name};",
    )
  }
  println("Methods:")
  for method in _self.methods {
    let methodType = (try? @parser.parse_descriptor_method(method.descriptor)).to_option()
    let returnName = methodType
      .map(it => it.return_type.to_simple_name())
      .unwrap_or("??")
    let parameters = methodType
      .map(it => it.parameters)
      .unwrap_or([])
      .map(it => it.to_simple_name())
      .join(", ")
    println(
      "  \{@classfile.to_modifier_string(method.access_flags)} \{returnName} \{method.name}(\{parameters})",
    )
    println("    descriptor: \{method.descriptor}\n")
    println("    attributes:")
    for attr in method.attributes {
      if attr is Code(code_attr) {
        println("      Code: max_stack=\{code_attr.max_stack}, max_locals=\{code_attr.max_locals}, code_length=\{code_attr.code.length()}",)
        let code = code_attr.code
        let insns = @asm.disassemble(
          @bytebuf.make_unpooled_from_bytes(code),
          _self,
        ) catch {
          err => {
            println("        Cannot disassemble code: \{err}")
            continue
          }
        }
        for insn in insns {
          println("        \{insn.to_string()}")
        }
      } else {
        println("      \{attr}")
      }
    }
  }
}
