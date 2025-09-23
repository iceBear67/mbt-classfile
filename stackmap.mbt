///|
pub(all) enum VerificationTypeInfo {
  TopVariable
  Integer
  Float
  Long
  Double
  Null
  UninitializedThis
  Object(ConstantClassInfo)
  Uninitialized(UInt16)
} derive(Show)

///|
/// A stack map frame is represented by a discriminated union, stack_map_frame, 
/// which consists of a one-byte tag, indicating which item of the union is in use,
///  followed by zero or more bytes, giving more information about the tag.
pub(all) enum StackMapFrame {
  SameFrame
  SameLocals1StackItemFrame(VerificationTypeInfo)
  SameLocals1StackItemFrameExtended(SameLocalOneFrameExt)
  ChopFrame(UInt16) // offset delta
  SameFrameExtended(UInt16) //offset delta
  AppendFrame(AppendFrame)
  FullFrame(FullFrame)
} derive(Show)

///|
pub(all) struct SameLocalOneFrameExt {
  offset_delta : UInt16
  stack : VerificationTypeInfo
} derive(Show)

///|
pub(all) struct AppendFrame { // type: 252-254
  offset_delta : UInt16
  locals : FixedArray[VerificationTypeInfo] // len: frame_type - 251
} derive(Show)

///|
pub(all) struct FullFrame {
  offset_delta : UInt16
  locals : FixedArray[VerificationTypeInfo]
  stack : FixedArray[VerificationTypeInfo]
} derive(Show)
