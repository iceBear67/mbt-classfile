# mbt-classfile

ClassFile parsing/writing support in Moonbit.   
_This library is not stable yet. APIs may change frequently and bugs are likely to appear._

Based on [JVMS Ch.4](https://docs.oracle.com/javase/specs/jvms/se24/html/jvms-4.html#jvms-4.5), version Java SE 24.


# Goals
 - [x] Parse ClassFile
 - [x] Descriptor parser
 - [x] Signature parser
 - [ ] Write ClassFile
 - [ ] Bytecode \[Dis\]Assembler

 ## javap

 A simple tool that utilizes this library as its class file parser.

Sample output:
```
Compiled from Some(SourceFile({sourceFile: "Simple.java"}))
public super Simple
  minor version: 0
  major version: 65
  flags: [Public, Super]
  this_class: Simple
  super_class: Some(java/lang/Object)
  interfaces: 0, fields: 14, methods: 3, attributes: 2
Constant pool:
  #0 = MethodRef({class_index: 2, name_and_type_index: 3})
  #1 = Class({name_index: 4})
  #2 = NameAndType({name_index: 5, descriptor_index: 6})
  #3 = Utf8("java/lang/Object")
  #4 = Utf8("<init>")
  #5 = Utf8("()V")
  #6 = String({string_index: 8})
  #7 = Utf8("")
  #8 = FieldRef({class_index: 10, name_and_type_index: 11})
  #9 = Class({name_index: 12})
  #10 = NameAndType({name_index: 13, descriptor_index: 14})
  #11 = Utf8("Simple")
  #12 = Utf8("finalStr")
  #13 = Utf8("Ljava/lang/String;")
  #14 = Utf8("_pri")
  #15 = Utf8("_pub")
  #16 = Utf8("_prot")
  #17 = Utf8("_def")
  #18 = Utf8("i")
  #19 = Utf8("I")
  #20 = Utf8("d")
  #21 = Utf8("D")
  #22 = Utf8("f")
  #23 = Utf8("F")
  #24 = Utf8("l")
  #25 = Utf8("J")
  #26 = Utf8("ch")
  #27 = Utf8("C")
  #28 = Utf8("bl")
  #29 = Utf8("Z")
  #30 = Utf8("s")
  #31 = Utf8("S")
  #32 = Utf8("b")
  #33 = Utf8("B")
  #34 = Utf8("g")
  #35 = Utf8("Ljava/lang/Object;")
  #36 = Utf8("Signature")
  #37 = Utf8("TG;")
  #38 = Utf8("ConstantValue")
  #39 = Utf8("methodPublicVoid")
  #40 = Utf8("Code")
  #41 = Utf8("LineNumberTable")
  #42 = Utf8("methodPrivateString")
  #43 = Utf8("()Ljava/lang/String;")
  #44 = Utf8("<G:Ljava/lang/Object;>Ljava/lang/Object;")
  #45 = Utf8("SourceFile")
  #46 = Utf8("Simple.java")
Fields:
  private Ljava/lang/String; _pri;

  public Ljava/lang/String; _pub;

  protected Ljava/lang/String; _prot;

   Ljava/lang/String; _def;

   I i;

   D d;

   F f;

   J l;

   C ch;

   Z bl;

   S s;

   B b;

   Ljava/lang/Object; g;

  final Ljava/lang/String; finalStr;

Methods:
  public void methodPublicVoid()
    descriptor: ()V
    attributes:
      Code({max_stack: 0, max_locals: 1, code: b"\xb1", exception_table: [], attributes: [LineNumberTable({line_number_table: [{start_pc: 0, line_number: 19}]})]})
  private String methodPrivateString()
    descriptor: ()Ljava/lang/String;
    attributes:
      Code({max_stack: 1, max_locals: 1, code: b"\x01\xb0", exception_table: [], attributes: [LineNumberTable({line_number_table: [{start_pc: 0, line_number: 21}]})]})
  public void <init>()
    descriptor: ()V
    attributes:
      Code({max_stack: 2, max_locals: 1, code: b"\x2a\xb7\x00\x01\x2a\x12\x07\xb5\x00\x09\xb1", exception_table: [], attributes: [LineNumberTable({line_number_table: [{start_pc: 0, line_number: 23}, {start_pc: 4, line_number: 17}, {start_pc: 10, line_number: 24}]})]})
```
