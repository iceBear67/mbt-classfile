///|
/// class, field, method
const ACC_PUBLIC : UInt16 = 0x0001

///|
/// class, field, method
const ACC_PRIVATE : UInt16 = 0x0002

///|
/// class, field, method
const ACC_PROTECTED : UInt16 = 0x0004

///|
/// field, method
const ACC_STATIC : UInt16 = 0x0008

///|
/// class, field, method, parameter
const ACC_FINAL : UInt16 = 0x0010

///|
/// field
const ACC_VOLATILE : UInt16 = 0x0040

///|
/// field
const ACC_TRANSIENT : UInt16 = 0x0080

///|
///  class
const ACC_SUPER : UInt16 = 0x0020

///|
/// class
const ACC_INTERFACE : UInt16 = 0X0200

///|
/// class, method
const ACC_ABSTRACT : UInt16 = 0x0400

///|
/// class, field, method, parameter, module *
const ACC_SYNTHETIC : UInt16 = 0x1000

///|
/// class
const ACC_ANNOTATION : UInt16 = 0x2000

///|
/// class(?) field inner
const ACC_ENUM : UInt16 = 0x4000

///|
/// class
const ACC_MODULE : UInt16 = 0x8000

///|
/// method
const ACC_SYNCHRONIZED : UInt16 = 0x0020

///|
/// method
const ACC_BRIDGE : UInt16 = 0x0040

///|
/// method
const ACC_VARARGS : UInt16 = 0x0080

///|
/// method
const ACC_NATIVE : UInt16 = 0x0100

///|
/// module
const ACC_OPEN : UInt16 = 0x0020

///|
/// module requires
const ACC_TRANSITIVE : UInt16 = 0x0020

///|
/// module requires
const ACC_STATIC_PHASE : UInt16 = 0x0040

///|
///  field, method, parameter, module, module *
const ACC_MANDATED : UInt16 = 0x8000

///|
/// method
const ACC_STRICT : UInt16 = 0x8000

///|
pub enum Modifier {
  Public
  Private
  Protected
  Static
  Final
  Volatile
  Transient
  Super
  Interface
  Abstract
  Synthetic
  Annotation
  Enum
  Module
  Synchronized
  Bridge
  Varargs
  Native
  Open
  Transitive
  StaticPhase
  Mandated
  Strict
} derive(Show, Eq)

///|
pub typealias Array[Modifier] as Modifiers

///|
pub fn to_bits(self : Modifier) -> UInt16 {
  match self {
    Varargs => ACC_VARARGS
    Bridge => ACC_BRIDGE
    Synchronized => ACC_SYNCHRONIZED
    Module => ACC_MODULE
    Enum => ACC_ENUM
    Annotation => ACC_ANNOTATION
    Synthetic => ACC_SYNTHETIC
    Abstract => ACC_ABSTRACT
    Interface => ACC_INTERFACE
    Super => ACC_SUPER
    Transient => ACC_TRANSIENT
    Volatile => ACC_VOLATILE
    Final => ACC_FINAL
    Static => ACC_STATIC
    Protected => ACC_PROTECTED
    Private => ACC_PRIVATE
    Public => ACC_PUBLIC
    Native => ACC_NATIVE
    Open => ACC_OPEN
    Transitive => ACC_TRANSITIVE
    StaticPhase => ACC_STATIC_PHASE
    Mandated => ACC_MANDATED
    Strict => ACC_STRICT
  }
}

///|
pub fn to_access_bits(_self : Modifiers) -> UInt16 {
  let mut result : UInt16 = 0
  for m in _self {
    result = result | m.to_bits()
  }
  result
}

///|
pub fn to_string(self : Modifier) -> String {
  match self {
    Public => "public"
    Private => "private"
    Protected => "protected"
    Static => "static"
    Final => "final"
    Volatile => "volatile"
    Transient => "transient"
    Super => "super"
    Interface => "interface"
    Abstract => "abstract"
    Synthetic => "synthetic"
    Annotation => "annotation"
    Enum => "enum"
    Module => "module"
    Synchronized => "synchronized"
    Bridge => "bridge"
    Varargs => "varargs"
    Native => "native"
    _ => panic() //todo support module acc
  }
}

///|
pub fn to_modifier_string(_self : Modifiers) -> String {
  let mut result = ""
  // Define priority order (higher number = higher priority)
  fn get_priority(m : Modifier) -> Int {
    match m {
      Public => 9
      Protected => 8
      Private => 7
      Abstract => 6
      Static => 5
      Final => 4
      Synchronized => 3
      Native => 2
      // Other modifiers with lower priority
      _ => 1
    }
  }

  // Sort modifiers by priority
  _self.sort_by(fn(a, b) { get_priority(b) - get_priority(a) })

  // Build string
  for m in _self {
    if result != "" {
      result = result + " "
    }
    result = result + m.to_string()
  }
  result
}

///|
pub fn to_class_modifiers(permBit : UInt16) -> Modifiers {
  let array : Array[Modifier] = Array::make(0, Modifier::Bridge)
  if (permBit & ACC_PUBLIC) != 0 {
    array.push(Public)
  }
  if (permBit & ACC_FINAL) != 0 {
    array.push(Final)
  }
  if (permBit & ACC_SUPER) != 0 {
    array.push(Super)
  }
  if (permBit & ACC_INTERFACE) != 0 {
    array.push(Interface)
  }
  if (permBit & ACC_ABSTRACT) != 0 {
    array.push(Abstract)
  }
  if (permBit & ACC_SYNTHETIC) != 0 {
    array.push(Synthetic)
  }
  if (permBit & ACC_ANNOTATION) != 0 {
    array.push(Annotation)
  }
  if (permBit & ACC_ENUM) != 0 {
    array.push(Enum)
  }
  if (permBit & ACC_MODULE) != 0 {
    array.push(Module)
  }
  array
}

///|
pub fn to_field_modifiers(permBit : UInt16) -> Modifiers {
  let array : Array[Modifier] = Array::make(0, Modifier::Bridge)
  if (permBit & ACC_PUBLIC) != 0 {
    array.push(Public)
  }
  if (permBit & ACC_PRIVATE) != 0 {
    array.push(Private)
  }
  if (permBit & ACC_PROTECTED) != 0 {
    array.push(Protected)
  }
  if (permBit & ACC_STATIC) != 0 {
    array.push(Static)
  }
  if (permBit & ACC_FINAL) != 0 {
    array.push(Final)
  }
  if (permBit & ACC_VOLATILE) != 0 {
    array.push(Volatile)
  }
  if (permBit & ACC_TRANSIENT) != 0 {
    array.push(Transient)
  }
  if (permBit & ACC_SYNTHETIC) != 0 {
    array.push(Synthetic)
  }
  array
}

///|
pub fn to_method_modifiers(permBit : UInt16) -> Modifiers {
  let array : Array[Modifier] = Array::make(0, Modifier::Bridge)
  if (permBit & ACC_PUBLIC) != 0 {
    array.push(Public)
  }
  if (permBit & ACC_PRIVATE) != 0 {
    array.push(Private)
  }
  if (permBit & ACC_PROTECTED) != 0 {
    array.push(Protected)
  }
  if (permBit & ACC_STATIC) != 0 {
    array.push(Static)
  }
  if (permBit & ACC_FINAL) != 0 {
    array.push(Final)
  }
  if (permBit & ACC_SYNCHRONIZED) != 0 {
    array.push(Synchronized)
  }
  if (permBit & ACC_BRIDGE) != 0 {
    array.push(Bridge)
  }
  if (permBit & ACC_VARARGS) != 0 {
    array.push(Varargs)
  }
  if (permBit & ACC_NATIVE) != 0 {
    array.push(Native)
  }
  if (permBit & ACC_ABSTRACT) != 0 {
    array.push(Abstract)
  }
  if (permBit & ACC_SYNTHETIC) != 0 {
    array.push(Synthetic)
  }
  array
}
