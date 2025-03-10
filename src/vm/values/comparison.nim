######################################################
# Arturo
# Programming Language + Bytecode VM compiler
# (c) 2019-2021 Yanis Zafirópulos
#
# @file: vm/values/comparison.nim
######################################################

#=======================================
# Libraries
#=======================================

import lenientops, tables, unicode
when not defined(NOGMP):
    import extras/bignum
 
import vm/exec
import vm/stack
import vm/values/value

#=======================================
# Methods
#=======================================

proc `==`*(x: Value, y: Value): bool {.inline.}=
    if x.kind in [Integer, Floating] and y.kind in [Integer, Floating]:
        if x.kind==Integer:
            if y.kind==Integer: 
                if x.iKind==NormalInteger and y.iKind==NormalInteger:
                    return x.i==y.i
                elif x.iKind==NormalInteger and y.iKind==BigInteger:
                    when not defined(NOGMP):
                        return x.i==y.bi
                elif x.iKind==BigInteger and y.iKind==NormalInteger:
                    when not defined(NOGMP):
                        return x.bi==y.i
                else:
                    when not defined(NOGMP):
                        return x.bi==y.bi
            else: 
                if x.iKind==NormalInteger:
                    return (float)(x.i)==y.f
                else:
                    when not defined(NOGMP):
                        return (x.bi)==(int)(y.f)
        else:
            if y.kind==Integer: 
                if y.iKind==NormalInteger:
                    return x.f==(float)(y.i)
                elif y.iKind==BigInteger:
                    when not defined(NOGMP):
                        return (int)(x.f)==y.bi        
            else: return x.f==y.f
    else:
        if x.kind != y.kind: return false

        case x.kind:
            of Null: return true
            of Boolean: return x.b == y.b
            of Complex: return x.z == y.z
            of Version:
                return x.major == y.major and x.minor == y.minor and x.patch == y.patch
            of Type: return x.t == y.t
            of Char: return x.c == y.c
            of String,
               Word,
               Label,
               Literal: return x.s == y.s
            of Attribute,
               AttributeLabel: return x.r == y.r
            of Symbol: return x.m == y.m
            of Inline,
               Block:
                let cleanX = cleanBlock(x.a)
                let cleanY = cleanBlock(y.a)

                if cleanX.len != cleanY.len: return false

                for i,child in cleanX:
                    if not (child==cleanY[i]): return false

                return true
            of Dictionary:
                if not x.custom.isNil and x.custom.methods.d.hasKey("compare"):
                    push y
                    push x
                    callFunction(x.custom.methods.d["compare"])
                    return (pop().i == 0)
                else:
                    if x.d.len != y.d.len: return false

                    for k,v in pairs(x.d):
                        if not y.d.hasKey(k): return false
                        if not (v==y.d[k]): return false

                    return true
            of Function:
                if x.fnKind==UserFunction:
                    return x.params == y.params and x.main == y.main and x.exports == y.exports
                else:
                    return x.fname == y.fname
            of Database:
                if x.dbKind != y.dbKind: return false
                when not defined(NOSQLITE):
                    if x.dbKind==SqliteDatabase: return cast[ByteAddress](x.sqlitedb) == cast[ByteAddress](y.sqlitedb)
                    #elif x.dbKind==MysqlDatabase: return cast[ByteAddress](x.mysqldb) == cast[ByteAddress](y.mysqldb)
            of Date:
                return x.eobj == y.eobj
            else:
                return false

proc `<`*(x: Value, y: Value): bool {.inline.}=
    if x.kind in [Integer, Floating] and y.kind in [Integer, Floating]:
        if x.kind==Integer:
            if y.kind==Integer: 
                if x.iKind==NormalInteger and y.iKind==NormalInteger:
                    return x.i<y.i
                elif x.iKind==NormalInteger and y.iKind==BigInteger:
                    when not defined(NOGMP):
                        return x.i<y.bi
                elif x.iKind==BigInteger and y.iKind==NormalInteger:
                    when not defined(NOGMP):
                        return x.bi<y.i
                else:
                    when not defined(NOGMP):
                        return x.bi<y.bi
            else: 
                if x.iKind==NormalInteger:
                    return x.i<y.f
                else:
                    when not defined(NOGMP):
                        return (x.bi)<(int)(y.f)
        else:
            if y.kind==Integer: 
                if y.iKind==NormalInteger:
                    return x.f<y.i
                elif y.iKind==BigInteger:
                    when not defined(NOGMP):
                        return (int)(x.f)<y.bi        
            else: return x.f<y.f
    else:
        if x.kind != y.kind: return false
        case x.kind:
            of Null: return false
            of Boolean: return false
            of Version:
                if x.major < y.major: return true
                elif x.major > y.major: return false

                if x.minor < y.minor: return true
                elif x.minor > y.minor: return false

                if x.patch < y.patch: return true
                elif x.patch > y.patch: return false

                return false
            of Type: return false
            of Char: return $(x.c) < $(y.c)
            of String,
               Word,
               Label,
               Literal: return x.s < y.s
            of Symbol: return false
            of Inline,
               Block:
                return cleanBlock(x.a).len < cleanBlock(y.a).len
            of Dictionary:
                if not x.custom.isNil and x.custom.methods.d.hasKey("compare"):
                    push y
                    push x
                    callFunction(x.custom.methods.d["compare"])
                    return (pop().i == -1)
                else:
                    return false
            else:
                return false

proc `>`*(x: Value, y: Value): bool {.inline.}=
    if x.kind in [Integer, Floating] and y.kind in [Integer, Floating]:
        if x.kind==Integer:
            if y.kind==Integer: 
                if x.iKind==NormalInteger and y.iKind==NormalInteger:
                    return x.i>y.i
                elif x.iKind==NormalInteger and y.iKind==BigInteger:
                    when not defined(NOGMP):
                        return x.i>y.bi
                elif x.iKind==BigInteger and y.iKind==NormalInteger:
                    when not defined(NOGMP):
                        return x.bi>y.i
                else:
                    when not defined(NOGMP):
                        return x.bi>y.bi
            else: 
                if x.iKind==NormalInteger:
                    return (float)(x.i)>y.f
                else:
                    when not defined(NOGMP):
                        return (x.bi)>(int)(y.f)
        else:
            if y.kind==Integer: 
                if y.iKind==NormalInteger:
                    return x.f>(float)(y.i)
                elif y.iKind==BigInteger:
                    when not defined(NOGMP):
                        return (int)(x.f)>y.bi        
            else: return x.f>y.f
    else:
        if x.kind != y.kind: return false
        case x.kind:
            of Null: return false
            of Boolean: return false
            of Version:
                if x.major > y.major: return true
                elif x.major < y.major: return false

                if x.minor > y.minor: return true
                elif x.minor < y.minor: return false

                if x.patch > y.patch: return true
                elif x.patch < y.patch: return false

                return false
            of Type: return false
            of Char: return $(x.c) > $(y.c)
            of String,
               Word,
               Label,
               Literal: return x.s > y.s
            of Symbol: return false
            of Inline,
               Block:
                return x.a.len > y.a.len
            of Dictionary:
                if not x.custom.isNil and x.custom.methods.d.hasKey("compare"):
                    push y
                    push x
                    callFunction(x.custom.methods.d["compare"])
                    return (pop().i == 1)
                else:
                    return false
            else:
                return false

proc `<=`*(x: Value, y: Value): bool {.inline.}=
    x < y or x == y

proc `>=`*(x: Value, y: Value): bool {.inline.}=
    x > y or x == y

proc `!=`*(x: Value, y: Value): bool {.inline.}=
    not (x == y)

proc cmp*(x: Value, y: Value): int {.inline.}=
    if x < y:
        return -1
    elif x > y:
        return 1
    else:
        return 0

proc contains*(x: openArray[Value], y: Value): bool {.inline.} =
    for item in items(x):
        if y == item: return true
    return false

proc find*(a: openArray[Value], item: Value): int {.inline.}=
    result = 0
    for i in items(a):
        if i == item: return
        inc(result)
    result = -1
