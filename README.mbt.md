# mbt-classfile

ClassFile parsing/writing support in Moonbit.   
_This library is not stable yet **and subject to refactor**. APIs may change frequently and bugs are likely to appear._

Based on [JVMS Ch.4](https://docs.oracle.com/javase/specs/jvms/se24/html/jvms-4.html#jvms-4.5), version Java SE 24.


## Goals
 - [x] Parse ClassFile
 - [x] Descriptor parser
 - [x] Signature parser
 - [ ] Write ClassFile
 - [x] Bytecode \[Dis\]Assembler
    - Assembler not done yet!

## Example

```Moonbit
///|
test "example" {
  let class = @parser.parse_class(
    @bytebuf.make_unpooled_from_bytes(
      @fs.read_file_to_bytes("test-data/ControlFlow.class"),
    ),
  )
  let blocks_to_method: Map[String, Array[Array[@asm.Instruction]]] = {}
  for method in class.methods.iter() {
    guard method.attributes.iter().find_first(it => it is Code(_))
      is Some(Code(code_attr)) else {
      continue
    }
    let insns = @asm.disassemble(
      @bytebuf.make_unpooled_from_bytes(code_attr.code),
      class,
    )
    let basic_blocks : Array[Array[@asm.Instruction]] = Array::makei(0, _ => panic())
    // we don't draw edges here for simplicity
    let mut current_block : Array[@asm.Instruction] = Array::makei(0, _ => panic())
    for instruction in insns {
      match instruction {
        SwitchInsn(Table(_)) | SwitchInsn(Lookup(_)) | ControlFlowInsn(_, _) => { // opcode, label are omitted
          current_block.push(instruction)
          basic_blocks.push(current_block)
          current_block = Array::makei(0, _ => panic())
        }
        _ => current_block.push(instruction)
      }
    }
    if !current_block.is_empty() {
      basic_blocks.push(current_block) 
    }
    blocks_to_method[method.name] = basic_blocks
  }
  let expect =
  #|{"<init>": [[ALOAD index:Some("0"), INVOKESPECIAL target:java/lang/Object ()V, RETURN #None]], "reallyIHaveToControlYou": [[ILOAD index:Some("0"), ISTORE index:Some("1"), ILOAD index:Some("0"), Label Label("L2"):, ILOAD index:Some("0"), IMUL, ISTORE index:Some("2"), ILOAD index:Some("1"), ILOAD index:Some("2"), IF_ICMPLE #Some("L0")], [GOTO #Some("L1")], [ILOAD index:Some("2"), ISTORE index:Some("0"), ILOAD index:Some("0"), Label Label("L0"):, BIPUSH Some("90"), IF_ICMPLT #Some("L2")], [RETURN #None]]}
  inspect(blocks_to_method, content = expect)
}

///|
fn find_constant_println(instructions : Array[@asm.Instruction]) -> Bool {
  return match instructions {
    [
      FieldInsn(@asm.GETSTATIC, fieldInfo),
      LdcInsn(ldc),
      InvocationInsn(@asm.INVOKEVIRTUAL, Normal(method)),
      ..,
    ] => {
      guard fieldInfo.name_and_type().map(it => it.descriptor()).flatten()
        is Some("Ljava/io/PrintStream;") &&
        method.method_name_and_type().map(it => it.descriptor()).flatten()
        is Some("(Ljava/lang/String;)V") else {
        return false
      }
      println("Found constant println at the beginning, content: \{ldc}")
      true
    }
    _ => false
  }
}
```


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
  interfaces: 0, fields: 14, methods: 5, attributes: 2

Constant pool:
  #0 = MethodRef(class=java/lang/Object, name=<init>, type=()V)
  #1 = Class java/lang/Object
  #2 = NameAndType(name=<init>, type=()V)
  #3 = Utf8(java/lang/Object)
  #4 = Utf8(<init>)
  #5 = Utf8(()V)
  #6 = String()
  #7 = Utf8()
  #8 = FieldRef(class=Simple, name=finalStr, type=Ljava/lang/String;)
  #9 = Class Simple
  #10 = NameAndType(name=finalStr, type=Ljava/lang/String;)
  #11 = Utf8(Simple)
  #12 = Utf8(finalStr)
  #13 = Utf8(Ljava/lang/String;)
  #14 = Utf8(_pri)
  #15 = Utf8(_pub)
  #16 = Utf8(_prot)
  #17 = Utf8(_def)
  #18 = Utf8(i)
  #19 = Utf8(I)
  #20 = Utf8(d)
  #21 = Utf8(D)
  #22 = Utf8(f)
  #23 = Utf8(F)
  #24 = Utf8(l)
  #25 = Utf8(J)
  #26 = Utf8(ch)
  #27 = Utf8(C)
  #28 = Utf8(bl)
  #29 = Utf8(Z)
  #30 = Utf8(s)
  #31 = Utf8(S)
  #32 = Utf8(b)
  #33 = Utf8(B)
  #34 = Utf8(g)
  #35 = Utf8(Ljava/lang/Object;)
  #36 = Utf8(Signature)
  #37 = Utf8(TG;)
  #38 = Utf8(ConstantValue)
  #39 = Utf8(methodPublicVoid)
  #40 = Utf8((Ljava/lang/CharSequence;)V)
  #41 = Utf8(Code)
  #42 = Utf8(LineNumberTable)
  #43 = Utf8(<T::Ljava/lang/CharSequence;>(TT;)V)
  #44 = Utf8(methodPrivateString)
  #45 = Utf8(()Ljava/lang/Object;)
  #46 = Utf8(()TG;)
  #47 = Utf8(justGeneric)
  #48 = Utf8((Ljava/lang/Object;)V)
  #49 = Utf8(<T:Ljava/lang/Object;OtherParam:Ljava/lang/Object;>(TT;)V)
  #50 = Utf8(wildcard)
  #51 = Utf8((Ljava/lang/Class;)V)
  #52 = Utf8((Ljava/lang/Class<+Ljava/lang/CharSequence;>;)V)
  #53 = Utf8(<G:Ljava/lang/Object;>Ljava/lang/Object;)
  #54 = Utf8(SourceFile)
  #55 = Utf8(Simple.java)
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
  public void methodPublicVoid(CharSequence)
    descriptor: (Ljava/lang/CharSequence;)V

    attributes:
      Code: max_stack=0, max_locals=2, code_length=1
        RETURN #None
      Signature({signature: "<T::Ljava/lang/CharSequence;>(TT;)V"})
  private Object methodPrivateString()
    descriptor: ()Ljava/lang/Object;

    attributes:
      Code: max_stack=1, max_locals=1, code_length=2
        ACONST_NULL None
        ARETURN #None
      Signature({signature: "()TG;"})
  public void justGeneric(Object)
    descriptor: (Ljava/lang/Object;)V

    attributes:
      Code: max_stack=0, max_locals=2, code_length=1
        RETURN #None
      Signature({signature: "<T:Ljava/lang/Object;OtherParam:Ljava/lang/Object;>(TT;)V"})
  public void wildcard(Class)
    descriptor: (Ljava/lang/Class;)V

    attributes:
      Code: max_stack=0, max_locals=2, code_length=1
        RETURN #None
      Signature({signature: "(Ljava/lang/Class<+Ljava/lang/CharSequence;>;)V"})
  public void <init>()
    descriptor: ()V

    attributes:
      Code: max_stack=2, max_locals=1, code_length=11
        ALOAD index:Some("0")
        INVOKESPECIAL target:java/lang/Object ()V
        ALOAD index:Some("0")
        LDC String()
        PUTFIELD Some("finalStr") type: Some("Ljava/lang/String;")
        RETURN #None
Total tests: 8, passed: 8, failed: 0.
```
