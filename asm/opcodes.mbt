// Opcodes are taken from ow2.asm
// ASM: a very small and fast Java bytecode manipulation framework
// Copyright (c) 2000-2011 INRIA, France Telecom
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions
// are met:
// 1. Redistributions of source code must retain the above copyright
//    notice, this list of conditions and the following disclaimer.
// 2. Redistributions in binary form must reproduce the above copyright
//    notice, this list of conditions and the following disclaimer in the
//    documentation and/or other materials provided with the distribution.
// 3. Neither the name of the copyright holders nor the names of its
//    contributors may be used to endorse or promote products derived from
//    this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
// THE POSSIBILITY OF SUCH DAMAGE.

// See https://docs.oracle.com/javase/specs/jvms/se9/html/jvms-6.html.

///|
const WIDE = 196

///|
const NOP = 0 // visitInsn

///|
const ACONST_NULL = 1 // -

///|
const ICONST_M1 = 2 // -

///|
const ICONST_0 = 3 // -

///|
const ICONST_1 = 4 // -

///|
const ICONST_2 = 5 // -

///|
const ICONST_3 = 6 // -

///|
const ICONST_4 = 7 // -

///|
const ICONST_5 = 8 // -

///|
const LCONST_0 = 9 // -

///|
const LCONST_1 = 10 // -

///|
const FCONST_0 = 11 // -

///|
const FCONST_1 = 12 // -

///|
const FCONST_2 = 13 // -

///|
const DCONST_0 = 14 // -

///|
const DCONST_1 = 15 // -

///|
const BIPUSH = 16 // visitIntInsn

///|
const SIPUSH = 17 // -

///|
const LDC = 18 // visitLdcInsn

///|
const LDC_W = 19

///|
const LDC2_W = 20

///|
const ILOAD = 21 // visitVarInsn

///|
const LLOAD = 22 // -

///|
const FLOAD = 23 // -

///|
const DLOAD = 24 // -

///|
const ALOAD = 25 // -

///|
const IALOAD = 46 // visitInsn

///|
const LALOAD = 47 // -

///|
const FALOAD = 48 // -

///|
const DALOAD = 49 // -

///|
const AALOAD = 50 // -

///|
const BALOAD = 51 // -

///|
const CALOAD = 52 // -

///|
const SALOAD = 53 // -

///|
const ISTORE = 54 // visitVarInsn

///|
const LSTORE = 55 // -

///|
const FSTORE = 56 // -

///|
const DSTORE = 57 // -

///|
const ASTORE = 58 // -

///|
const IASTORE = 79 // visitInsn

///|
const LASTORE = 80 // -

///|
const FASTORE = 81 // -

///|
const DASTORE = 82 // -

///|
const AASTORE = 83 // -

///|
const BASTORE = 84 // -

///|
const CASTORE = 85 // -

///|
const SASTORE = 86 // -

///|
const POP = 87 // -

///|
const POP2 = 88 // -

///|
const DUP = 89 // -

///|
const DUP_X1 = 90 // -

///|
const DUP_X2 = 91 // -

///|
const DUP2 = 92 // -

///|
const DUP2_X1 = 93 // -

///|
const DUP2_X2 = 94 // -

///|
const SWAP = 95 // -

///|
const IADD = 96 // -

///|
const LADD = 97 // -

///|
const FADD = 98 // -

///|
const DADD = 99 // -

///|
const ISUB = 100 // -

///|
const LSUB = 101 // -

///|
const FSUB = 102 // -

///|
const DSUB = 103 // -

///|
const IMUL = 104 // -

///|
const LMUL = 105 // -

///|
const FMUL = 106 // -

///|
const DMUL = 107 // -

///|
const IDIV = 108 // -

///|
const LDIV = 109 // -

///|
const FDIV = 110 // -

///|
const DDIV = 111 // -

///|
const IREM = 112 // -

///|
const LREM = 113 // -

///|
const FREM = 114 // -

///|
const DREM = 115 // -

///|
const INEG = 116 // -

///|
const LNEG = 117 // -

///|
const FNEG = 118 // -

///|
const DNEG = 119 // -

///|
const ISHL = 120 // -

///|
const LSHL = 121 // -

///|
const ISHR = 122 // -

///|
const LSHR = 123 // -

///|
const IUSHR = 124 // -

///|
const LUSHR = 125 // -

///|
const IAND = 126 // -

///|
const LAND = 127 // -

///|
const IOR = 128 // -

///|
const LOR = 129 // -

///|
const IXOR = 130 // -

///|
const LXOR = 131 // -

///|
const IINC = 132 // visitIincInsn

///|
const I2L = 133 // visitInsn

///|
const I2F = 134 // -

///|
const I2D = 135 // -

///|
const L2I = 136 // -

///|
const L2F = 137 // -

///|
const L2D = 138 // -

///|
const F2I = 139 // -

///|
const F2L = 140 // -

///|
const F2D = 141 // -

///|
const D2I = 142 // -

///|
const D2L = 143 // -

///|
const D2F = 144 // -

///|
const I2B = 145 // -

///|
const I2C = 146 // -

///|
const I2S = 147 // -

///|
const LCMP = 148 // -

///|
const FCMPL = 149 // -

///|
const FCMPG = 150 // -

///|
const DCMPL = 151 // -

///|
const DCMPG = 152 // -

///|
const IFEQ = 153 // visitJumpInsn

///|
const IFNE = 154 // -

///|
const IFLT = 155 // -

///|
const IFGE = 156 // -

///|
const IFGT = 157 // -

///|
const IFLE = 158 // -

///|
const IF_ICMPEQ = 159 // -

///|
const IF_ICMPNE = 160 // -

///|
const IF_ICMPLT = 161 // -

///|
const IF_ICMPGE = 162 // -

///|
const IF_ICMPGT = 163 // -

///|
const IF_ICMPLE = 164 // -

///|
const IF_ACMPEQ = 165 // -

///|
const IF_ACMPNE = 166 // -

///|
const GOTO = 167 // -

///|
const GOTO_W = 200

///|
const JSR = 168 // -

///|
const JSR_W = 201

///|
const RET = 169 // visitVarInsn

///|
const TABLESWITCH = 170 // visiTableSwitchInsn

///|
const LOOKUPSWITCH = 171 // visitLookupSwitch

///|
const IRETURN = 172 // visitInsn

///|
const LRETURN = 173 // -

///|
const FRETURN = 174 // -

///|
const DRETURN = 175 // -

///|
const ARETURN = 176 // -

///|
const RETURN = 177 // -

///|
const GETSTATIC = 178 // visitFieldInsn

///|
const PUTSTATIC = 179 // -

///|
const GETFIELD = 180 // -

///|
const PUTFIELD = 181 // -

///|
const INVOKEVIRTUAL = 182 // visitMethodInsn

///|
const INVOKESPECIAL = 183 // -

///|
const INVOKESTATIC = 184 // -

///|
const INVOKEINTERFACE = 185 // -

///|
const INVOKEDYNAMIC = 186 // visitInvokeDynamicInsn

///|
const NEW = 187 // visitTypeInsn

///|
const NEWARRAY = 188 // visitIntInsn

///|
const ANEWARRAY = 189 // visitTypeInsn

///|
const ARRAYLENGTH = 190 // visitInsn

///|
const ATHROW = 191 // -

///|
const CHECKCAST = 192 // visitTypeInsn

///|
const INSTANCEOF = 193 // -

///|
const MONITORENTER = 194 // visitInsn

///|
const MONITOREXIT = 195 // -

///|
const MULTIANEWARRAY = 197 // visitMultiANewArrayInsn

///|
const IFNULL = 198 // visitJumpInsn

///|
const IFNONNULL = 199 // -

fn int_to_opcode_name(opcode: Int) -> String {
  match opcode {
    NOP => "NOP"
    ACONST_NULL => "ACONST_NULL"
    ICONST_M1 => "ICONST_M1"
    ICONST_0 => "ICONST_0"
    ICONST_1 => "ICONST_1"
    ICONST_2 => "ICONST_2"
    ICONST_3 => "ICONST_3"
    ICONST_4 => "ICONST_4"
    ICONST_5 => "ICONST_5"
    LCONST_0 => "LCONST_0"
    LCONST_1 => "LCONST_1"
    FCONST_0 => "FCONST_0"
    FCONST_1 => "FCONST_1"
    FCONST_2 => "FCONST_2"
    DCONST_0 => "DCONST_0"
    DCONST_1 => "DCONST_1"
    BIPUSH => "BIPUSH"
    SIPUSH => "SIPUSH"
    LDC => "LDC"
    LDC_W => "LDC_W"
    LDC2_W => "LDC2_W"
    ILOAD => "ILOAD"
    LLOAD => "LLOAD"
    FLOAD => "FLOAD"
    DLOAD => "DLOAD"
    ALOAD => "ALOAD"
    IALOAD => "IALOAD"
    LALOAD => "LALOAD"
    FALOAD => "FALOAD"
    DALOAD => "DALOAD"
    AALOAD => "AALOAD"
    BALOAD => "BALOAD"
    CALOAD => "CALOAD"
    SALOAD => "SALOAD"
    ISTORE => "ISTORE"
    LSTORE => "LSTORE"
    FSTORE => "FSTORE"
    DSTORE => "DSTORE"
    ASTORE => "ASTORE"
    IASTORE => "IASTORE"
    LASTORE => "LASTORE"
    FASTORE => "FASTORE"
    DASTORE => "DASTORE"
    AASTORE => "AASTORE"
    BASTORE => "BASTORE"
    CASTORE => "CASTORE"
    SASTORE => "SASTORE"
    POP => "POP"
    POP2 => "POP2"
    DUP => "DUP"
    DUP_X1 => "DUP_X1"
    DUP_X2 => "DUP_X2"
    DUP2 => "DUP2"
    DUP2_X1 => "DUP2_X1"
    DUP2_X2 => "DUP2_X2"
    SWAP => "SWAP"
    IADD => "IADD"
    LADD => "LADD"
    FADD => "FADD"
    DADD => "DADD"
    ISUB => "ISUB"
    LSUB => "LSUB"
    FSUB => "FSUB"
    DSUB => "DSUB"
    IMUL => "IMUL"
    LMUL => "LMUL"
    FMUL => "FMUL"
    DMUL => "DMUL"
    IDIV => "IDIV"
    LDIV => "LDIV"
    FDIV => "FDIV"
    DDIV => "DDIV"
    IREM => "IREM"
    LREM => "LREM"
    FREM => "FREM"
    DREM => "DREM"
    INEG => "INEG"
    LNEG => "LNEG"
    FNEG => "FNEG"
    DNEG => "DNEG"
    ISHL => "ISHL"
    LSHL => "LSHL"
    ISHR => "ISHR"
    LSHR => "LSHR"
    IUSHR => "IUSHR"
    LUSHR => "LUSHR"
    IAND => "IAND"
    LAND => "LAND"
    IOR => "IOR"
    LOR => "LOR"
    IXOR => "IXOR"
    LXOR => "LXOR"
    IINC => "IINC"
    I2L => "I2L"
    I2F => "I2F"
    I2D => "I2D"
    L2I => "L2I"
    L2F => "L2F"
    L2D => "L2D"
    F2I => "F2I"
    F2L => "F2L"
    F2D => "F2D"
    D2I => "D2I"
    D2L => "D2L"
    D2F => "D2F"
    I2B => "I2B"
    I2C => "I2C"
    I2S => "I2S"
    LCMP => "LCMP"
    FCMPL => "FCMPL"
    FCMPG => "FCMPG"
    DCMPL => "DCMPL"
    DCMPG => "DCMPG"
    IFEQ => "IFEQ"
    IFNE => "IFNE"
    IFLT => "IFLT"
    IFGE => "IFGE"
    IFGT => "IFGT"
    IFLE => "IFLE"
    IF_ICMPEQ => "IF_ICMPEQ"
    IF_ICMPNE => "IF_ICMPNE"
    IF_ICMPLT => "IF_ICMPLT"
    IF_ICMPGE => "IF_ICMPGE"
    IF_ICMPGT => "IF_ICMPGT"
    IF_ICMPLE => "IF_ICMPLE"
    IF_ACMPEQ => "IF_ACMPEQ"
    IF_ACMPNE => "IF_ACMPNE"
    GOTO => "GOTO"
    JSR => "JSR"
    RET => "RET"
    TABLESWITCH => "TABLESWITCH"
    LOOKUPSWITCH => "LOOKUPSWITCH"
    IRETURN => "IRETURN"
    LRETURN => "LRETURN"
    FRETURN => "FRETURN"
    DRETURN => "DRETURN"
    ARETURN => "ARETURN"
    RETURN => "RETURN"
    GETSTATIC => "GETSTATIC"
    PUTSTATIC => "PUTSTATIC"
    GETFIELD => "GETFIELD"
    PUTFIELD => "PUTFIELD"
    INVOKEVIRTUAL => "INVOKEVIRTUAL"
    INVOKESPECIAL => "INVOKESPECIAL"
    INVOKESTATIC => "INVOKESTATIC"
    INVOKEINTERFACE => "INVOKEINTERFACE"
    INVOKEDYNAMIC => "INVOKEDYNAMIC"
    NEW => "NEW"
    NEWARRAY => "NEWARRAY"
    ANEWARRAY => "ANEWARRAY"
    ARRAYLENGTH => "ARRAYLENGTH"
    ATHROW => "ATHROW"
    CHECKCAST => "CHECKCAST"
    INSTANCEOF => "INSTANCEOF"
    MONITORENTER => "MONITORENTER"
    MONITOREXIT => "MONITOREXIT"
    WIDE => "WIDE"
    MULTIANEWARRAY => "MULTIANEWARRAY"
    IFNULL => "IFNULL"
    IFNONNULL => "IFNONNULL"
    GOTO_W => "GOTO_W"
    JSR_W => "JSR_W"
    _ => "UNKNOWN"
  }
}
