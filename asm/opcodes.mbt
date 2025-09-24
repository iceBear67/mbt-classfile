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
pub const WIDE = 196

///|
pub const NOP = 0 // visitInsn

///|
pub const ACONST_NULL = 1 // -

///|
pub const ICONST_M1 = 2 // -

///|
pub const ICONST_0 = 3 // -

///|
pub const ICONST_1 = 4 // -

///|
pub const ICONST_2 = 5 // -

///|
pub const ICONST_3 = 6 // -

///|
pub const ICONST_4 = 7 // -

///|
pub const ICONST_5 = 8 // -

///|
pub const LCONST_0 = 9 // -

///|
pub const LCONST_1 = 10 // -

///|
pub const FCONST_0 = 11 // -

///|
pub const FCONST_1 = 12 // -

///|
pub const FCONST_2 = 13 // -

///|
pub const DCONST_0 = 14 // -

///|
pub const DCONST_1 = 15 // -

///|
pub const BIPUSH = 16 // visitIntInsn

///|
pub const SIPUSH = 17 // -

///|
pub const LDC = 18 // visitLdcInsn

///|
pub const LDC_W = 19

///|
pub const LDC2_W = 20

///|
pub const ILOAD = 21 // visitVarInsn

///|
pub const LLOAD = 22 // -

///|
pub const FLOAD = 23 // -

///|
pub const DLOAD = 24 // -

///|
pub const ALOAD = 25 // -

///|
pub const IALOAD = 46 // visitInsn

///|
pub const LALOAD = 47 // -

///|
pub const FALOAD = 48 // -

///|
pub const DALOAD = 49 // -

///|
pub const AALOAD = 50 // -

///|
pub const BALOAD = 51 // -

///|
pub const CALOAD = 52 // -

///|
pub const SALOAD = 53 // -

///|
pub const ISTORE = 54 // visitVarInsn

///|
pub const LSTORE = 55 // -

///|
pub const FSTORE = 56 // -

///|
pub const DSTORE = 57 // -

///|
pub const ASTORE = 58 // -

///|
pub const IASTORE = 79 // visitInsn

///|
pub const LASTORE = 80 // -

///|
pub const FASTORE = 81 // -

///|
pub const DASTORE = 82 // -

///|
pub const AASTORE = 83 // -

///|
pub const BASTORE = 84 // -

///|
pub const CASTORE = 85 // -

///|
pub const SASTORE = 86 // -

///|
pub const POP = 87 // -

///|
pub const POP2 = 88 // -

///|
pub const DUP = 89 // -

///|
pub const DUP_X1 = 90 // -

///|
pub const DUP_X2 = 91 // -

///|
pub const DUP2 = 92 // -

///|
pub const DUP2_X1 = 93 // -

///|
pub const DUP2_X2 = 94 // -

///|
pub const SWAP = 95 // -

///|
pub const IADD = 96 // -

///|
pub const LADD = 97 // -

///|
pub const FADD = 98 // -

///|
pub const DADD = 99 // -

///|
pub const ISUB = 100 // -

///|
pub const LSUB = 101 // -

///|
pub const FSUB = 102 // -

///|
pub const DSUB = 103 // -

///|
pub const IMUL = 104 // -

///|
pub const LMUL = 105 // -

///|
pub const FMUL = 106 // -

///|
pub const DMUL = 107 // -

///|
pub const IDIV = 108 // -

///|
pub const LDIV = 109 // -

///|
pub const FDIV = 110 // -

///|
pub const DDIV = 111 // -

///|
pub const IREM = 112 // -

///|
pub const LREM = 113 // -

///|
pub const FREM = 114 // -

///|
pub const DREM = 115 // -

///|
pub const INEG = 116 // -

///|
pub const LNEG = 117 // -

///|
pub const FNEG = 118 // -

///|
pub const DNEG = 119 // -

///|
pub const ISHL = 120 // -

///|
pub const LSHL = 121 // -

///|
pub const ISHR = 122 // -

///|
pub const LSHR = 123 // -

///|
pub const IUSHR = 124 // -

///|
pub const LUSHR = 125 // -

///|
pub const IAND = 126 // -

///|
pub const LAND = 127 // -

///|
pub const IOR = 128 // -

///|
pub const LOR = 129 // -

///|
pub const IXOR = 130 // -

///|
pub const LXOR = 131 // -

///|
pub const IINC = 132 // visitIincInsn

///|
pub const I2L = 133 // visitInsn

///|
pub const I2F = 134 // -

///|
pub const I2D = 135 // -

///|
pub const L2I = 136 // -

///|
pub const L2F = 137 // -

///|
pub const L2D = 138 // -

///|
pub const F2I = 139 // -

///|
pub const F2L = 140 // -

///|
pub const F2D = 141 // -

///|
pub const D2I = 142 // -

///|
pub const D2L = 143 // -

///|
pub const D2F = 144 // -

///|
pub const I2B = 145 // -

///|
pub const I2C = 146 // -

///|
pub const I2S = 147 // -

///|
pub const LCMP = 148 // -

///|
pub const FCMPL = 149 // -

///|
pub const FCMPG = 150 // -

///|
pub const DCMPL = 151 // -

///|
pub const DCMPG = 152 // -

///|
pub const IFEQ = 153 // visitJumpInsn

///|
pub const IFNE = 154 // -

///|
pub const IFLT = 155 // -

///|
pub const IFGE = 156 // -

///|
pub const IFGT = 157 // -

///|
pub const IFLE = 158 // -

///|
pub const IF_ICMPEQ = 159 // -

///|
pub const IF_ICMPNE = 160 // -

///|
pub const IF_ICMPLT = 161 // -

///|
pub const IF_ICMPGE = 162 // -

///|
pub const IF_ICMPGT = 163 // -

///|
pub const IF_ICMPLE = 164 // -

///|
pub const IF_ACMPEQ = 165 // -

///|
pub const IF_ACMPNE = 166 // -

///|
pub const GOTO = 167 // -

///|
pub const GOTO_W = 200

///|
pub const JSR = 168 // -

///|
pub const JSR_W = 201

///|
pub const RET = 169 // visitVarInsn

///|
pub const TABLESWITCH = 170 // visiTableSwitchInsn

///|
pub const LOOKUPSWITCH = 171 // visitLookupSwitch

///|
pub const IRETURN = 172 // visitInsn

///|
pub const LRETURN = 173 // -

///|
pub const FRETURN = 174 // -

///|
pub const DRETURN = 175 // -

///|
pub const ARETURN = 176 // -

///|
pub const RETURN = 177 // -

///|
pub const GETSTATIC = 178 // visitFieldInsn

///|
pub const PUTSTATIC = 179 // -

///|
pub const GETFIELD = 180 // -

///|
pub const PUTFIELD = 181 // -

///|
pub const INVOKEVIRTUAL = 182 // visitMethodInsn

///|
pub const INVOKESPECIAL = 183 // -

///|
pub const INVOKESTATIC = 184 // -

///|
pub const INVOKEINTERFACE = 185 // -

///|
pub const INVOKEDYNAMIC = 186 // visitInvokeDynamicInsn

///|
pub const NEW = 187 // visitTypeInsn

///|
pub const NEWARRAY = 188 // visitIntInsn

///|
pub const ANEWARRAY = 189 // visitTypeInsn

///|
pub const ARRAYLENGTH = 190 // visitInsn

///|
pub const ATHROW = 191 // -

///|
pub const CHECKCAST = 192 // visitTypeInsn

///|
pub const INSTANCEOF = 193 // -

///|
pub const MONITORENTER = 194 // visitInsn

///|
pub const MONITOREXIT = 195 // -

///|
pub const MULTIANEWARRAY = 197 // visitMultiANewArrayInsn

///|
pub const IFNULL = 198 // visitJumpInsn

///|
pub const IFNONNULL = 199 // -

pub fn int_to_opcode_name(opcode: Int) -> String {
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
