///|
fn parse_attribute_info(
  self : &@bytebuf.ByteBuf,
  constant : @classfile.ConstantPool,
) -> @classfile.AttributeInfo raise {
  guard self.read_bytes(2 + 4)
    is Some([u16(attribute_name_index), u32(attribute_length)]) else {
    raise fail("Expect attribute info but got EOF.")
  }
  guard constant.at(attribute_name_index.reinterpret_as_int()) is Utf8(name) else {
    raise fail(
      "Expect UTF8 when reading attribute name but got \{constant.at(attribute_name_index.reinterpret_as_int())}",
    )
  }
  match name {
    "ConstantValue" => return self.parse_attribute_constant_value(constant)
    "Code" => return self.parse_attribute_code(constant)
    "StackMapTable" => return self.parse_attribute_stackmap_table(constant)
    "Exceptions" => return self.parse_attribute_exceptions(constant)
    "InnerClasses" => return self.parse_attribute_inner_classes(constant)
    "EnclosingMethod" => return self.parse_attribute_enclosing_method(constant)
    "Synthetic" => return Synthetic
    "Signature" => return self.parse_attribute_signature(constant)
    "SourceFile" => return self.parse_attribute_source_file(constant)
    "SourceDebugExtension" =>
      return self.parse_attribute_debug_ext(
        attribute_length.reinterpret_as_int(),
      )
    "LineNumberTable" => return self.parse_attribute_linenumber_table()
    "LocalVariableTable" => return self.parse_local_variable_table(constant)
    "LocalVariableTypeTable" =>
      return self.parse_local_variable_type_table(constant)
    "Deprecated" => return Deprecated
    "RuntimeVisibleAnnotations" =>
      return RuntimeVisibleAnnotations(
        self.parse_attribute_annotations(constant),
      )
    "RuntimeInvisibleAnnotations" =>
      return RuntimeInvisibleAnnotations(
        self.parse_attribute_annotations(constant),
      )
    "RuntimeInvisibleParameterAnnotations" =>
      return RuntimeInvisibleParameterAnnotations(
        self.parse_attribute_parameter_annotations(constant),
      )
    "RuntimeVisibleTypeAnnotations" =>
      return RuntimeVisibleTypeAnnotations(
        self.parse_attribute_type_annotations(constant),
      )
    "RuntimeInvisibleTypeAnnotations" =>
      return RuntimeInvisibleTypeAnnotations(
        self.parse_attribute_type_annotations(constant),
      )
    "AnnotationDefault" =>
      return AnnotationDefault(self.parse_element_value(constant))
    "BootstrapMethods" => return self.parse_bootstrap_methods(constant)
    "MethodParameters" => return self.parse_attribute_method_params(constant)
    "Module" => return self.parse_module(constant)
    "ModulePackages" => return self.parse_attribute_module_packages(constant)
    "ModuleMainClass" => return self.parse_attribute_module_main(constant)
    "NestHost" => return self.parse_attribute_nest_host(constant)
    "NestMembers" => return self.parse_attribute_nest_members(constant)
    "Record" => return self.parse_attribute_record(constant)
    "PermittedSubclasses" =>
      return self.parse_attribute_sealed_classes(constant)
    unkn => raise fail("Unknown attribute type: \{unkn}")
  }
}

///|
fn parse_attribute_sealed_classes(
  self : &@bytebuf.ByteBuf,
  constant : @classfile.ConstantPool,
) -> @classfile.AttributeInfo {
  guard self.read_uint16() is Some(count)
  @classfile.PermittedSubclasses(FixedArray::makei(count.to_int(), _=>{
    guard self.read_uint16() is Some(idx) && constant.at(idx.to_int()) is Class(classInfo)
    classInfo
  }))
}

///|
fn parse_attribute_record(
  self : &@bytebuf.ByteBuf,
  constant : @classfile.ConstantPool,
) -> @classfile.AttributeInfo raise {
  guard self.read_uint16() is Some(count)
  Record(
    FixedArray::makei(count.to_int(), _ => {
      guard self.read_bytes(4) is Some([u16(name_index), u16(descriptor_index)]) &&
        constant.at(name_index.reinterpret_as_int()) is Utf8(name) &&
        constant.at(descriptor_index.reinterpret_as_int()) is Utf8(descriptor)
      @classfile.RecordComponent::{
        name,
        descriptor,
        attributes: self.parse_attributes(constant),
      }
    }),
  )
}

///|
fn parse_attribute_module_main(
  self : &@bytebuf.ByteBuf,
  constant : @classfile.ConstantPool,
) -> @classfile.AttributeInfo {
  guard self.read_uint16() is Some(index) &&
    constant.at(index.to_int()) is Class(classInfo)
  return ModuleMainClass(classInfo)
}

///|
fn parse_attribute_nest_host(
  self : &@bytebuf.ByteBuf,
  constant : @classfile.ConstantPool,
) -> @classfile.AttributeInfo {
  guard self.read_uint16() is Some(index) &&
    constant.at(index.to_int()) is Class(classInfo)
  return NestHost(classInfo)
}

///|
fn parse_attribute_nest_members(
  self : &@bytebuf.ByteBuf,
  constant : @classfile.ConstantPool,
) -> @classfile.AttributeInfo {
  guard self.read_uint16() is Some(num)
  return NestMembers(
    FixedArray::makei(num.to_int(), _ => {
      guard self.read_uint16() is Some(index) &&
        constant.at(index.to_int()) is Class(classInfo)
      classInfo
    }),
  )
}

///|
fn parse_attribute_module_packages(
  self : &@bytebuf.ByteBuf,
  constant : @classfile.ConstantPool,
) -> @classfile.AttributeInfo {
  guard self.read_uint16() is Some(package_count)
  return ModulePackages(@classfile.ModulePackagesAttribute::{
    package_index: FixedArray::makei(package_count.to_int(), _ => {
      guard self.read_uint16() is Some(index) &&
        constant.at(index.to_int()) is Package(packageInfo)
      packageInfo
    }),
  })
}

///|
fn parse_attribute_method_params(
  self : &@bytebuf.ByteBuf,
  constant : @classfile.ConstantPool,
) -> @classfile.AttributeInfo {
  guard self.read_byte() is Some(paramCount)
  return MethodParameters(
    FixedArray::makei(paramCount.to_int(), _ => {
      guard self.read_bytes(4) is Some([u16(name_index), u16(access_flags)])
      guard constant.at(name_index.reinterpret_as_int()) is Utf8(name)
      @classfile.MethodParameter::{
        name,
        access_flags: access_flags.reinterpret_as_int().to_uint16(),
      }
    }),
  )
}

///|
fn parse_attribute_type_annotations(
  self : &@bytebuf.ByteBuf,
  constant : @classfile.ConstantPool,
) -> FixedArray[@classfile.TypeAnnotation] raise {
  let num_annotations = self.read_uint16().unwrap().to_int()
  FixedArray::makei(num_annotations, _ => self.parse_type_annotation(constant))
}

///|
fn parse_attribute_parameter_annotations(
  self : &@bytebuf.ByteBuf,
  constant : @classfile.ConstantPool,
) -> FixedArray[@classfile.ParameterAnnotation] raise {
  let num_parameters = self.read_byte().unwrap().to_int()
  FixedArray::makei(num_parameters, _ => {
    let num_annotations = self.read_uint16().unwrap().to_int()
    @classfile.ParameterAnnotation::{
      annotations: FixedArray::makei(num_annotations, _ => self.parse_annotation(
        constant,
      )),
    }
  })
}

///|
fn parse_attribute_annotations(
  self : &@bytebuf.ByteBuf,
  constant : @classfile.ConstantPool,
) -> FixedArray[@classfile.Annotation] raise {
  let num_annotations = self.read_uint16().unwrap().to_int()
  FixedArray::makei(num_annotations, _ => self.parse_annotation(constant))
}

///|
fn parse_attribute_linenumber_table(
  self : &@bytebuf.ByteBuf,
) -> @classfile.AttributeInfo raise {
  let line_number_table_length = self.read_uint16().unwrap().to_int()
  let line_number_table = FixedArray::makei(line_number_table_length, _ => {
    guard self.read_bytes(2 + 2) is Some([u16(start_pc), u16(line_number)]) else {
      raise fail("Unexpected EOF when reading LineNumberTable attribute")
    }
    @classfile.LineNumberTableEntry::{
      start_pc: start_pc.reinterpret_as_int().to_uint16(),
      line_number: line_number.reinterpret_as_int().to_uint16(),
    }
  })
  return LineNumberTable(@classfile.LineNumberTableAttribute::{
    line_number_table,
  })
}

///|
fn parse_attribute_debug_ext(
  self : &@bytebuf.ByteBuf,
  attribute_length : Int,
) -> @classfile.AttributeInfo raise {
  guard self.read_bytes(attribute_length) is Some(data) else {
    raise fail("Unexpected EOF when reading SourceDebugExtension attribute")
  }
  return SourceDebugExtension(@classfile.SourceDebugExtensionAttribute::{
    debug_extension: data,
  })
}

///|
fn parse_attribute_source_file(
  self : &@bytebuf.ByteBuf,
  constant : @classfile.ConstantPool,
) -> @classfile.AttributeInfo raise {
  guard self.read_uint16() is Some(index) else {
    raise fail("Unexpected EOF when reading SourceFile attribute")
  }
  let entry = constant.at(index.to_int())
  guard entry is Utf8(sourceFile) else {
    raise fail("Expect constant entry `utf8` but got \{entry}")
  }
  return SourceFile(@classfile.SourceFileAttribute::{ sourceFile, })
}

///|
fn parse_attribute_signature(
  self : &@bytebuf.ByteBuf,
  constant : @classfile.ConstantPool,
) -> @classfile.AttributeInfo raise {
  guard self.read_uint16() is Some(index) else {
    raise fail("Unexpected EOF when reading Signature attribute")
  }
  let entry = constant.at(index.to_int())
  guard entry is Utf8(signature) else {
    raise fail("Expect constant entry `utf8` but got \{entry}")
  }
  return Signature(@classfile.SignatureAttribute::{ signature, })
}

///|
fn parse_attribute_constant_value(
  self : &@bytebuf.ByteBuf,
  constant : @classfile.ConstantPool,
) -> @classfile.AttributeInfo raise {
  guard self.read_uint16() is Some(index) else {
    raise fail("Unexpected EOF when reading @classfile.ConstantValue attribute")
  }
  return @classfile.ConstantValue(@classfile.ConstantValueAttribute::{
    constant_value: constant.at(index.to_int()),
  })
}

///|
fn parse_attribute_stackmap_table(
  self : &@bytebuf.ByteBuf,
  constant : @classfile.ConstantPool,
) -> @classfile.AttributeInfo raise {
  let numEntries = self.read_uint16().unwrap().to_int()
  let entries = FixedArray::makei(numEntries, _ => self.parse_stackmap_frame(
    constant,
  ))
  return StackMapTable(@classfile.StackMapTableAttribute::{ entries, })
}

///|
fn parse_attribute_exceptions(
  self : &@bytebuf.ByteBuf,
  constant : @classfile.ConstantPool,
) -> @classfile.AttributeInfo raise {
  let numExceptions = self.read_uint16().unwrap().to_int()
  let exception_index_table = FixedArray::makei(numExceptions, _ => {
    guard self.read_uint16() is Some(index) else {
      raise fail("Unexpected EOF when reading Exceptions attribute")
    }
    let entry = constant.at(index.to_int())
    guard entry is Class(classInfo) else {
      raise fail("Expect constant entry `class info` but got \{entry}")
    }
    classInfo
  })
  return Exceptions(@classfile.ExceptionsAttribute::{ exception_index_table, })
}

///|
fn parse_attribute_enclosing_method(
  self : &@bytebuf.ByteBuf,
  constant : @classfile.ConstantPool,
) -> @classfile.AttributeInfo raise {
  guard self.read_bytes(2 + 2) is Some([u16(class_index), u16(method_index)]) else {
    raise fail("Unexpected EOF when reading EnclosingMethod attribute")
  }
  let class_entry = constant.at(class_index.reinterpret_as_int())
  guard class_entry is Class(classInfo) else {
    raise fail("Expect constant entry `class info` but got \{class_entry}")
  }
  let mut methodInfo : @classfile.ConstantNameAndTypeInfo? = None
  if method_index != 0 {
    let method_entry = constant.at(method_index.reinterpret_as_int())
    guard method_entry is NameAndType(mnt) else {
      raise fail(
        "Expect constant entry `name and type info` but got \{method_entry}",
      )
    }
    methodInfo = Some(mnt)
  }
  return EnclosingMethod(@classfile.EnclosingMethodAttribute::{
    class: classInfo,
    methodInfo,
  })
}

///|
fn parse_attribute_code(
  self : &@bytebuf.ByteBuf,
  constant : @classfile.ConstantPool,
) -> @classfile.AttributeInfo raise {
  guard self.read_bytes(2 + 2 + 4)
    is Some([u16(max_stack), u16(max_locals), u32(code_length)]) else {
    raise fail("Unexpected EOF when reading Code attribute")
  }
  guard self.read_bytes(code_length.reinterpret_as_int()) is Some(code_data) else {
    raise fail("Unexpected EOF when reading code data")
  }
  let exception_table_len = self.read_uint16().unwrap().to_int()
  let exception_table = FixedArray::makei(exception_table_len, _ => self.parse_exception_table(
    constant,
  ))
  let attributes = self.parse_attributes(constant)
  return Code(@classfile.CodeAttribute::{
    max_stack: max_stack.reinterpret_as_int().to_uint16(),
    max_locals: max_locals.reinterpret_as_int().to_uint16(),
    code: code_data,
    exception_table,
    attributes,
  })
}

///|
fn parse_attribute_inner_classes(
  self : &@bytebuf.ByteBuf,
  constant : @classfile.ConstantPool,
) -> @classfile.AttributeInfo raise {
  let number_of_classes = self.read_uint16().unwrap().to_int()
  let classes = FixedArray::makei(number_of_classes, _ => {
    guard self.read_bytes(2 + 2 + 2 + 2)
      is Some(
        [
          u16(inner_class_info_index),
          u16(outer_class_info_index),
          u16(inner_name_index),
          u16(inner_class_access_flags),
        ]
      ) else {
      raise fail("Unexpected EOF when reading InnerClasses attribute")
    }
    let inner_class_entry = constant.at(inner_class_info_index.reinterpret_as_int())
    guard inner_class_entry is Class(inner_class) else {
      raise fail(
        "Expect constant entry `class info` but got \{inner_class_entry}",
      )
    }
    let mut outer_class : @classfile.ConstantClassInfo? = None
    if outer_class_info_index != 0 {
      let outer_class_entry = constant.at(outer_class_info_index.reinterpret_as_int())
      guard outer_class_entry is Class(oc) else {
        raise fail(
          "Expect constant entry `class info` but got \{outer_class_entry}",
        )
      }
      outer_class = Some(oc)
    }
    guard constant.at(inner_name_index.reinterpret_as_int()) is Utf8(inner_name) else {
      raise fail(
        "Expect constant entry `utf8` but got \{constant.at(inner_name_index.reinterpret_as_int())}",
      )
    }
    @classfile.InnerClassInfo::{
      inner_class,
      outer_class,
      inner_name,
      inner_class_access_flags: inner_class_access_flags
      .reinterpret_as_int()
      .to_uint16(),
    }
  })
  return InnerClasses(@classfile.InnerClassAttribute::{ classes, })
}

///|
fn parse_bootstrap_methods(
  self : &@bytebuf.ByteBuf,
  constant : @classfile.ConstantPool,
) -> @classfile.AttributeInfo raise {
  let num_bootstrap_methods = self.read_uint16().unwrap()
  return BootstrapMethods(
    FixedArray::makei(num_bootstrap_methods.to_int(), _ => {
      guard self.read_bytes(2 + 2)
        is Some([u16(bootstrapMethodRef), u16(numBootstrapArguments)]) else {
        raise fail("EOF at reading Bootstrap Methods")
      }
      let bsMethodRef = constant.at(bootstrapMethodRef.reinterpret_as_int())
      guard bsMethodRef is MethodHandle(refMH) else {
        raise fail("Expect method handle but got \{bsMethodRef}")
      }
      let bootstrap_arguments = FixedArray::makei(
        numBootstrapArguments.reinterpret_as_int(),
        _ => {
          guard self.read_uint16().map(i => constant.at(i.to_int())) is Some(mh)
          mh
        },
      )
      @classfile.BootstrapMethod::{
        bootstrap_method_ref: refMH,
        bootstrap_arguments,
      }
    }),
  )
}

///|
fn parse_exception_table(
  self : &@bytebuf.ByteBuf,
  constant : @classfile.ConstantPool,
) -> @classfile.ExceptionTableEntry raise {
  guard self.read_bytes(2 + 2 + 2 + 2)
    is Some([u16(start_pc), u16(end_pc), u16(handler_pc), u16(catch_type)]) else {
    raise fail("Unexpected EOF when reading exception table")
  }
  let mut classInfo : @classfile.ConstantClassInfo? = None
  if catch_type != 0 {
    let entry = constant.at(catch_type.reinterpret_as_int())
    guard entry is Class(ci) else {
      raise fail("Expect constant entry `class info` but got \{entry}")
    }
    classInfo = Some(ci)
  }
  @classfile.ExceptionTableEntry::{
    start_pc: start_pc.reinterpret_as_int().to_uint16(),
    end_pc: end_pc.reinterpret_as_int().to_uint16(),
    handler_pc: handler_pc.reinterpret_as_int().to_uint16(),
    catch_type: classInfo,
  }
}

///|
fn parse_module(
  self : &@bytebuf.ByteBuf,
  constant : @classfile.ConstantPool,
) -> @classfile.AttributeInfo {
  guard self.read_bytes(3 * 2)
    is Some([u16(mod_name_index), u16(mod_flags), u16(mod_ver_index)]) &&
    constant.at(mod_name_index.reinterpret_as_int()) is Utf8(modName)
  let modName = modName
  let mut modVersion : String? = None
  if mod_ver_index != 0 &&
    constant.at(mod_ver_index.reinterpret_as_int()) is Utf8(modVer) {
    modVersion = Some(modVer)
  }
  guard self.read_uint16() is Some(requiresCount)
  let requires = FixedArray::makei(requiresCount.to_int(), _ => {
    guard self.read_bytes(3 * 2)
      is Some(
        [u16(requires_index), u16(requires_flags), u16(requires_versions_index)]
      ) &&
      constant.at(requires_index.reinterpret_as_int()) is Module(requiresName)
    let version = if requires_versions_index != 0 &&
      constant.at(requires_versions_index.reinterpret_as_int())
      is Utf8(requiresVersions) {
      Some(requiresVersions)
    } else {
      None
    }
    @classfile.ModuleRequire::{
      requires: requiresName,
      requires_flags: requires_flags.reinterpret_as_int().to_uint16(),
      requires_version: version,
    }
  })
  guard self.read_uint16() is Some(exportsCount)
  let exports = FixedArray::makei(exportsCount.to_int(), _ => {
    guard self.read_bytes(2 * 3)
      is Some([u16(exports_index), u16(exports_flags), u16(exports_to_count)]) &&
      constant.at(exports_index.reinterpret_as_int()) is Package(packageInfo)
    @classfile.ModuleExport::{
      exports: packageInfo,
      exports_flags: exports_flags.reinterpret_as_int().to_uint16(),
      exports_to: FixedArray::makei(exports_to_count.reinterpret_as_int(), _ => {
        guard self.read_uint16() is Some(index) &&
          constant.at(index.to_int()) is Module(moduleInfo)
        moduleInfo
      }),
    }
  })
  guard self.read_uint16() is Some(opensCount)
  let opens = FixedArray::makei(opensCount.to_int(), _ => {
    guard self.read_bytes(3 * 2)
      is Some([u16(opens_index), u16(opens_flags), u16(opens_to_count)]) &&
      constant.at(opens_index.reinterpret_as_int()) is Package(packageInfo)
    let opensToIndex = FixedArray::makei(opens_to_count.reinterpret_as_int(), _ => {
      guard self.read_uint16() is Some(index) &&
        constant.at(index.to_int()) is Module(moduleInfo)
      moduleInfo
    })
    @classfile.ModuleOpen::{
      opens: packageInfo,
      opens_flags: opens_flags.reinterpret_as_int().to_uint16(),
      opens_to: opensToIndex,
    }
  })
  guard self.read_uint16() is Some(useCount)
  let usesIndex = FixedArray::makei(useCount.to_int(), _ => {
    guard self.read_uint16() is Some(index) &&
      constant.at(index.to_int()) is Class(classInfo)
    classInfo
  })
  guard self.read_uint16() is Some(providesCount)
  let provides = FixedArray::makei(providesCount.to_int(), _ => {
    guard self.read_bytes(4)
      is Some([u16(provides_index), u16(provides_with_count)]) &&
      constant.at(provides_index.reinterpret_as_int()) is Class(classInfo)
    let providesWithIndex = FixedArray::makei(
      provides_with_count.reinterpret_as_int(),
      _ => {
        guard self.read_uint16() is Some(index) &&
          constant.at(index.to_int()) is Class(classInfo)
        classInfo
      },
    )
    @classfile.ModuleProvide::{
      provides: classInfo,
      provides_with: providesWithIndex,
    }
  })
  return Module(@classfile.ModuleAttribute::{
    module_name: modName,
    module_version: modVersion,
    module_flags: mod_flags.reinterpret_as_int().to_uint16(),
    requires,
    exports,
    opens,
    uses_index: usesIndex,
    provides,
  })
}

///|
fn parse_local_variable_table(
  self : &@bytebuf.ByteBuf,
  constant : @classfile.ConstantPool,
) -> @classfile.AttributeInfo raise {
  let local_variable_table_length = self.read_uint16().unwrap().to_int()
  let local_variable_table = FixedArray::makei(local_variable_table_length, _ => {
    guard self.read_bytes(2 + 2 + 2 + 2 + 2)
      is Some(
        [
          u16(start_pc),
          u16(length),
          u16(name_index),
          u16(descriptor_index),
          u16(index),
        ]
      ) else {
      raise fail("Unexpected EOF when reading LocalVariableTable attribute")
    }
    let name_entry = constant.at(name_index.reinterpret_as_int())
    guard name_entry is Utf8(name) else {
      raise fail("Expect constant entry `utf8` but got \{name_entry}")
    }
    let descriptor_entry = constant.at(descriptor_index.reinterpret_as_int())
    guard descriptor_entry is Utf8(descriptor) else {
      raise fail("Expect constant entry `utf8` but got \{descriptor_entry}")
    }
    @classfile.LocalVariableTableEntry::{
      start_pc: start_pc.reinterpret_as_int().to_uint16(),
      length: length.reinterpret_as_int().to_uint16(),
      name,
      descriptor,
      index: index.reinterpret_as_int().to_uint16(),
    }
  })
  return LocalVariableTable(local_variable_table)
}

///|
fn parse_local_variable_type_table(
  self : &@bytebuf.ByteBuf,
  constant : @classfile.ConstantPool,
) -> @classfile.AttributeInfo raise {
  let table_length = self.read_uint16().unwrap().to_int()
  let local_variable_type_table = FixedArray::makei(table_length, _ => {
    guard self.read_bytes(2 + 2 + 2 + 2 + 2)
      is Some(
        [
          u16(start_pc),
          u16(length),
          u16(name_index),
          u16(signature_index),
          u16(index),
        ]
      ) else {
      raise fail("Unexpected EOF when reading LocalVariableTypeTable attribute")
    }
    let name_entry = constant.at(name_index.reinterpret_as_int())
    guard name_entry is Utf8(name) else {
      raise fail("Expect constant entry `utf8` but got \{name_entry}")
    }
    let signature_entry = constant.at(signature_index.reinterpret_as_int())
    guard signature_entry is Utf8(signature) else {
      raise fail("Expect constant entry `utf8` but got \{signature_entry}")
    }
    @classfile.LocalVariableTypeTableEntry::{
      start_pc: start_pc.reinterpret_as_int().to_uint16(),
      length: length.reinterpret_as_int().to_uint16(),
      name,
      signature,
      index: index.reinterpret_as_int().to_uint16(),
    }
  })
  return LocalVariableTypeTable(@classfile.LocalVariableTypeTableAttribute::{
    local_variable_type_table,
  })
}
