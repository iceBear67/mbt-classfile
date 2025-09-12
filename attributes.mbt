///|
pub(all) enum AttributeInfo {
  ConstantValue(ConstantValueAttribute)
  Code(CodeAttribute)
  StackMapTable(StackMapTableAttribute)
  Exceptions(ExceptionsAttribute)
  InnerClasses(InnerClassAttribute)
  EnclosingMethod(EnclosingMethodAttribute)
  Synthetic
  Signature(SignatureAttribute)
  SourceFile(SourceFileAttribute)
  SourceDebugExtension(SourceDebugExtensionAttribute)
  LineNumberTable(LineNumberTableAttribute)
  LocalVariableTable(FixedArray[LocalVariableTableEntry])
  LocalVariableTypeTable(LocalVariableTypeTableAttribute)
  Deprecated
  RuntimeVisibleAnnotations(FixedArray[Annotation])
  RuntimeInvisibleAnnotations(FixedArray[Annotation])
  RuntimeVisibleParameterAnnotations(FixedArray[ParameterAnnotation])
  RuntimeInvisibleParameterAnnotations(FixedArray[ParameterAnnotation])
  RuntimeVisibleTypeAnnotations(FixedArray[TypeAnnotation])
  RuntimeInvisibleTypeAnnotations(FixedArray[TypeAnnotation])
  AnnotationDefault(ElementValue)
  BootstrapMethods(FixedArray[BootstrapMethod])
  MethodParameters(FixedArray[MethodParameter])
  Module(ModuleAttribute)
  ModulePackages(ModulePackagesAttribute)
  ModuleMainClass(ConstantClassInfo)
  NestHost(ConstantClassInfo)
  NestMembers(FixedArray[ConstantClassInfo])
  Record(FixedArray[RecordComponent])
  PermittedSubclasses(FixedArray[ConstantClassInfo])
}

pub(all) struct RecordComponent {
  name: String
  descriptor: String
  attributes: FixedArray[AttributeInfo]
}

///|
pub(all) struct ConstantValueAttribute {
  constant_value : ConstantType
}

///|
pub(all) struct CodeAttribute {
  max_stack : UInt16
  max_locals : UInt16
  code : Bytes
  exception_table : FixedArray[ExceptionTableEntry]
  attributes : FixedArray[AttributeInfo]
}

///|
pub(all) struct ExceptionTableEntry {
  start_pc : UInt16
  end_pc : UInt16
  handler_pc : UInt16
  catch_type : ConstantClassInfo?
}

///|
pub(all) struct StackMapTableAttribute {
  entries : FixedArray[StackMapFrame]
}

///|
pub(all) struct ExceptionsAttribute {
  exception_index_table : FixedArray[ConstantClassInfo]
}

///|
pub(all) struct InnerClassAttribute {
  classes : FixedArray[InnerClassInfo]
}

///|
pub(all) struct InnerClassInfo {
  inner_class : ConstantClassInfo
  /// If C is not a member of a class or an interface - that is, 
  /// if C is a top-level class or interface (JLS §7.6) or a local class (JLS §14.3) or an anonymous class (JLS §15.9.5) -
  ///  then the value of the outer_class_info_index item must be zero, indicating a None.
  outer_class : ConstantClassInfo?
  inner_name : String
  inner_class_access_flags : UInt16
}

///|
pub(all) struct EnclosingMethodAttribute {
  class : ConstantClassInfo
  methodInfo : ConstantNameAndTypeInfo?
}

///|
pub(all) struct SignatureAttribute {
  signature : String // todo parser
}

///|
pub(all) struct SourceFileAttribute {
  sourceFile : String
}

///|
pub(all) struct SourceDebugExtensionAttribute {
  debug_extension : Bytes
}

///|
pub(all) struct LineNumberTableAttribute {
  line_number_table : FixedArray[LineNumberTableEntry]
}

///|
pub(all) struct LineNumberTableEntry {
  start_pc : UInt16
  line_number : UInt16
}

///|
pub(all) struct LocalVariableTableEntry {
  start_pc : UInt16
  length : UInt16
  name : String
  descriptor : String
  index : UInt16
}

///|
pub(all) struct LocalVariableTypeTableAttribute {
  local_variable_type_table : FixedArray[LocalVariableTypeTableEntry]
}

///|
pub(all) struct LocalVariableTypeTableEntry {
  start_pc : UInt16
  length : UInt16
  name : String
  signature : String
  index : UInt16
}

///|
pub(all) struct BootstrapMethod {
  bootstrap_method_ref : ConstantMethodHandleInfo
  bootstrap_arguments : FixedArray[ConstantType]
}

///|
pub(all) struct MethodParameter {
  name : String
  access_flags : UInt16
}

///|
pub(all) struct ModuleAttribute {
  module_name : String
  module_flags : UInt16
  module_version : String?
  requires : FixedArray[ModuleRequire]
  exports : FixedArray[ModuleExport]
  opens : FixedArray[ModuleOpen]
  uses_index : FixedArray[ConstantClassInfo]
  provides : FixedArray[ModuleProvide]
}

///|
pub(all) struct ModuleRequire {
  requires : ConstantModuleInfo
  requires_flags : UInt16
  requires_version : String?
}

///|
pub(all) struct ModuleExport {
  exports : ConstantPackageInfo
  exports_flags : UInt16
  exports_to : FixedArray[ConstantModuleInfo]
}

///|
pub(all) struct ModuleOpen {
  opens : ConstantPackageInfo
  opens_flags : UInt16
  opens_to : FixedArray[ConstantModuleInfo]
}

///|
pub(all) struct ModuleProvide {
  provides : ConstantClassInfo
  provides_with : FixedArray[ConstantClassInfo]
}

///|
pub(all) struct ModulePackagesAttribute {
  package_index : FixedArray[ConstantPackageInfo]
}
