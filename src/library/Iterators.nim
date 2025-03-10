######################################################
# Arturo
# Programming Language + Bytecode VM compiler
# (c) 2019-2021 Yanis Zafirópulos
#
# @file: library/Iterators.nim
######################################################

#=======================================
# Pragmas
#=======================================

{.used.}

#=======================================
# Libraries
#=======================================

import algorithm, sequtils, sugar, unicode

import vm/lib
import vm/[errors, eval, exec]

#=======================================
# Methods
#=======================================


proc defineSymbols*() =

    when defined(VERBOSE):
        echo "- Importing: Iterators"

    builtin "every?",
        alias       = unaliased, 
        rule        = PrefixPrecedence,
        description = "check if every single item in collection satisfy given condition",
        args        = {
            "collection"    : {Block},
            "params"        : {Literal,Block},
            "condition"     : {Block}
        },
        attrs       = NoAttrs,
        returns     = {Boolean},
        example     = """
            if every? [2 4 6 8] 'x [even? x] 
                -> print "every number is an even integer"
            ; every number is an even integer
            ;;;;
            print every? 1..10 'x -> x < 11
            ; true
            ;;;;
            print every? [2 3 5 7 11 14] 'x [prime? x]
            ; false
        """:
            ##########################################################
            var args: ValueArray

            if y.kind==Literal: args = @[y]
            else: args = cleanBlock(y.a)

            let blk = cleanBlock(x.a)

            # check if empty
            if blk.len==0: 
                push(newBoolean(false))
                return

            let preevaled = doEval(z)
            var all = true

            for item in blk:
                handleBranching:
                    push(item)
                    discard execBlock(VNULL, evaluated=preevaled, args=args)
                    let popped = pop()
                    if popped.kind==Boolean and not popped.b:
                        push(newBoolean(false))
                        all = false
                        break
                do:
                    discard

            if all:
                push(newBoolean(true))

    builtin "filter",
        alias       = unaliased, 
        rule        = PrefixPrecedence,
        description = "get collection's items by filtering those that do not fulfil given condition",
        args        = {
            "collection"    : {Block,Literal},
            "params"        : {Literal,Block},
            "condition"     : {Block}
        },
        attrs       = NoAttrs,
        returns     = {Block,Nothing},
        example     = """
            print filter 1..10 [x][
                even? x
            ]
            ; 1 3 5 7 9
            ;;;;
            arr: 1..10
            filter 'arr 'x -> even? x
            print arr
            ; 1 3 5 7 9
        """:
            ##########################################################
            var args: ValueArray

            if y.kind==Literal: args = @[y]
            else: args = cleanBlock(y.a)

            let preevaled = doEval(z)

            var res: ValueArray = @[]

            if x.kind==Literal:
                discard InPlace
                for i,item in cleanBlock(InPlaced.a):
                    handleBranching:
                        push(item)
                        discard execBlock(VNULL, evaluated=preevaled, args=args)
                        if not pop().b:
                            res.add(item)
                    do:
                        discard

                InPlaced.a = res
            else:
                for item in cleanBlock(x.a):
                    handleBranching:
                        push(item)
                        discard execBlock(VNULL, evaluated=preevaled, args=args)
                        if not pop().b:
                            res.add(item)
                    do:
                        discard

                push(newBlock(res))

    builtin "fold",
        alias       = unaliased, 
        rule        = PrefixPrecedence,
        description = "flatten given collection by eliminating nested blocks",
        args        = {
            "collection"    : {Block,Literal},
            "params"        : {Literal,Block},
            "action"        : {Block}
        },
        attrs       = {
            "seed"  : ({Any},"use specific seed value"),
            "right" : ({Boolean},"perform right folding")
        },
        returns     = {Block,Null,Nothing},
        example     = """
            fold 1..10 [x,y]-> x + y
            ; => 55 (1+2+3+4..) 
            ;;;;
            fold 1..10 .seed:1 [x,y][ x * y ]
            ; => 3628800 (10!) 
            ;;;;
            fold 1..3 [x y]-> x - y
            ; => -6
            ;;;;
            fold.right 1..3 [x y]-> x - y
            ; => 2
        """:
            ##########################################################
            var args = cleanBlock(y.a)
            let preevaled = doEval(z)

            var seed = I0
            var blk: ValueArray
            if x.kind==Literal:
                blk = cleanBlock(InPlaced.a)
                # check if empty
                if blk.len==0: 
                    push(VNULL)
                    return

                if blk[0].kind == String:
                    seed = newString("")
            else:
                blk = cleanBlock(x.a)
                # check if empty
                if blk.len==0: 
                    push(VNULL)
                    return

                if blk[0].kind == String:
                    seed = newString("")

            if (let aSeed = popAttr("seed"); aSeed != VNULL):
                seed = aSeed

            let doRightFold = (popAttr("right")!=VNULL)

            if (x.kind==Literal and blk.len==0):
                discard
            elif (x.kind!=Literal and blk.len==0):
                push(x)
            else:
                if (doRightFold):
                    # right fold

                    if x.kind == Literal:
                        var res: Value = seed
                        for i in countdown(blk.len-1,0):
                            handleBranching:
                                let a = blk[i]
                                let b = res

                                push(b)
                                push(a)

                                discard execBlock(VNULL, evaluated=preevaled, args=args)
                                res = pop()
                            do:
                                discard

                        SetInPlace(res)

                    else:
                        var res: Value = seed
                        for i in countdown(blk.len-1,0):
                            handleBranching:
                                let a = blk[i]
                                let b = res

                                push(b)
                                push(a)

                                discard execBlock(VNULL, evaluated=preevaled, args=args)
                                res = pop()
                            do:
                                discard

                        push(res)
                else:
                    # left fold

                    if x.kind == Literal:
                        var res: Value = seed
                        for i in blk:
                            handleBranching:
                                let a = res
                                let b = i

                                push(b)
                                push(a)

                                discard execBlock(VNULL, evaluated=preevaled, args=args)
                                res = pop()
                            do:
                                discard

                        SetInPlace(res)

                    else:
                        var res: Value = seed
                        for i in blk:
                            handleBranching:
                                let a = res
                                let b = i

                                push(b)
                                push(a)

                                discard execBlock(VNULL, evaluated=preevaled, args=args)
                                res = pop()
                            do:
                                discard

                        push(res)

    builtin "loop",
        alias       = unaliased, 
        rule        = PrefixPrecedence,
        description = "loop through collection, using given iterator and block",
        args        = {
            "collection"    : {Integer,String,Block,Inline,Dictionary},
            "params"        : {Literal,Block},
            "action"        : {Block}
        },
        attrs       = {
            "with"      : ({Literal},"use given index"),
            "forever"   : ({Boolean},"cycle through collection infinitely")
        },
        returns     = {Nothing},
        example     = """
            loop [1 2 3] 'x [
                print x
            ]
            ; 1
            ; 2
            ; 3
            ;;;;
            loop 1..3 [x][
                print ["x =>" x]
            ]
            ; x => 1
            ; x => 2
            ; x => 3
            ;;;;
            loop [A a B b C c] [x y][
                print [x "=>" y]
            ]
            ; A => a
            ; B => b
            ; C => c
            ;;;;
            user: #[
                name: "John"
                surname: "Doe"
            ]
            
            loop user [k v][
                print [k "=>" v]
            ]
            ; name => John
            ; surname => Doe
            ;;;;
            loop.with:'i ["zero" "one" "two"] 'x [
                print ["item at:" i "=>" x]
            ]
            ; 0 => zero
            ; 1 => one
            ; 2 => two
            ;;;;
            loop.forever [1 2 3] => print 
            ; 1 2 3 1 2 3 1 2 3 ...
        """:
            ##########################################################
            var args: ValueArray

            let forever = popAttr("forever")!=VNULL

            var withIndex = false
            let aWith = popAttr("with")
            if aWith != VNULL:
                withIndex = true

            if y.kind==Literal: args = @[y]
            else: args = cleanBlock(y.a)

            var allArgs = args

            if withIndex:
                allArgs = concat(@[aWith], args)

            let preevaled = doEval(z)

            if x.kind==Dictionary:
                # check if empty
                if x.d.len==0: return

                var keepGoing = true
                while keepGoing:
                    for k,v in pairs(x.d):
                        handleBranching:
                            push(v)
                            push(newString(k))
                            discard execBlock(VNULL, evaluated=preevaled, args=args)
                        do:
                            discard
                    if not forever:
                        keepGoing = false
            elif x.kind==String:
                var arr: seq[Value] = toSeq(runes(x.s)).map((x) => newChar(x))

                # check if empty
                if arr.len==0: return

                var keepGoing = true
                while keepGoing:
                    var indx = 0
                    var run = 0
                    while indx+args.len<=arr.len:
                        handleBranching:
                            for item in arr[indx..indx+args.len-1].reversed:
                                push(item)

                            if withIndex:
                                push(newInteger(run))

                            discard execBlock(VNULL, evaluated=preevaled, args=allArgs)
                        do:
                            run += 1
                            indx += args.len

                            if not forever:
                                keepGoing = false
            else:
                var arr: seq[Value]
                if x.kind==Integer:
                    arr = (toSeq(1..x.i)).map((x) => newInteger(x))
                else:
                    arr = cleanBlock(x.a)

                # check if empty
                if arr.len==0: return

                var keepGoing = true
                while keepGoing:
                    var indx = 0
                    var run = 0
                    while indx+args.len<=arr.len:
                        handleBranching:
                            for item in arr[indx..indx+args.len-1].reversed:
                                push(item)

                            if withIndex:
                                push(newInteger(run))

                            discard execBlock(VNULL, evaluated=preevaled, args=allArgs)#, isBreakable=true)
                        do:
                            run += 1
                            indx += args.len

                            if not forever:
                                keepGoing = false

    # TODO(Iterators\map): Make map work even without arguments
    #  labels: bug, library
    builtin "map",
        alias       = unaliased, 
        rule        = PrefixPrecedence,
        description = "map collection's items by applying given action",
        args        = {
            "collection"    : {Block,Literal},
            "params"        : {Literal,Block},
            "action"        : {Block}
        },
        attrs       = NoAttrs,
        returns     = {Block,Nothing},
        example     = """
            print map 1..5 [x][
                2*x
            ]
            ; 2 4 6 8 10
            ;;;;
            arr: 1..5
            map 'arr 'x -> 2*x
            print arr
            ; 2 4 6 8 10
        """:
            ##########################################################
            var args: ValueArray

            if y.kind==Literal: args = @[y]
            else: args = cleanBlock(y.a)

            let preevaled = doEval(z)

            var res: ValueArray = @[]

            if x.kind==Literal:
                discard InPlace
                for i,item in cleanBlock(InPlaced.a):
                    handleBranching:
                        push(item)
                        discard execBlock(VNULL, evaluated=preevaled, args=args)
                        InPlaced.a[i] = pop()
                    do:
                        discard
            else:
                for item in cleanBlock(x.a):
                    handleBranching:
                        push(item)
                        discard execBlock(VNULL, evaluated=preevaled, args=args)
                        res.add(pop())
                    do:
                        discard
                
                push(newBlock(res))

    builtin "select",
        alias       = unaliased, 
        rule        = PrefixPrecedence,
        description = "get collection's items that fulfil given condition",
        args        = {
            "collection"    : {Block,Literal},
            "params"        : {Literal,Block},
            "action"        : {Block}
        },
        attrs       = NoAttrs,
        returns     = {Block,Nothing},
        example     = """
            print select 1..10 [x][
                even? x
            ]
            ; 2 4 6 8 10
            ;;;;
            arr: 1..10
            select 'arr 'x -> even? x
            print arr
            ; 2 4 6 8 10
        """:
            ##########################################################
            var args: ValueArray

            if y.kind==Literal: args = @[y]
            else: args = cleanBlock(y.a)

            let preevaled = doEval(z)

            var res: ValueArray = @[]

            if x.kind==Literal:
                discard InPlace
                for i,item in cleanBlock(InPlaced.a):
                    handleBranching:
                        push(item)
                        discard execBlock(VNULL, evaluated=preevaled, args=args)
                        if pop().b:
                            res.add(item)
                    do:
                        discard

                InPlaced.a = res
            else:
                for item in cleanBlock(x.a):
                    handleBranching:
                        push(item)
                        discard execBlock(VNULL, evaluated=preevaled, args=args)
                        if pop().b:
                            res.add(item)
                    do:
                        discard

                push(newBlock(res))

    builtin "some?",
        alias       = unaliased, 
        rule        = PrefixPrecedence,
        description = "check if any of collection's items satisfy given condition",
        args        = {
            "collection"    : {Block},
            "params"        : {Literal,Block},
            "condition"     : {Block}
        },
        attrs       = NoAttrs,
        returns     = {Boolean},
        example     = """
            if some? [1 3 5 6 7] 'x [even? x] 
                -> print "at least one number is an even integer"
            ; at least one number is an even integer
            ;;;;
            print some? 1..10 'x -> x > 9
            ; true
            ;;;;
            print some? [4 6 8 10] 'x [prime? x]
            ; false
        """:
            ##########################################################
            var args: ValueArray

            if y.kind==Literal: args = @[y]
            else: args = cleanBlock(y.a)

            let blk = cleanBlock(x.a)

            # check if empty
            if blk.len==0: 
                push(newBoolean(false))
                return

            let preevaled = doEval(z)
            var one = false

            for item in blk:
                handleBranching:
                    push(item)
                    discard execBlock(VNULL, evaluated=preevaled, args=args)
                    let popped = pop()
                    if popped.kind==Boolean and popped.b:
                        push(newBoolean(true))
                        one = true
                        break
                do:
                    discard

            if not one:
                push(newBoolean(false))

#=======================================
# Add Library
#=======================================

Libraries.add(defineSymbols)