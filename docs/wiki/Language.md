---

- [Introduction](#introduction)
- [The main components](#the-main-components)
   * [Words](#words)
   * [Labels](#labels)
   * [Symbols](#symbols)
   * [Values](#values)
       - [:null](#null)
       - [:boolean](#boolean)
       - [:integer](#integer)
       - [:floating](#floating)
       - [:type](#type)
       - [:char](#char)
       - [:string](#string)
       - [:literal](#literal)
       - [:path](#path)
       - [:inline](#inline)
       - [:block](#block)
       - [:dictionary](#dictionary)
       - [:function](#function)
       - [:date](#date)
       - [:binary](#binary)
   * [Attributes](#attributes)
       - [:attr](#attr)
       - [:attrLabel](#attrLabel)
- [Precedence and evaluation](#precedence-and-evaluation)
   * [The right-to-left rule](#the-right-to-left-rule)
- [Syntactic sugar](#syntactic-sugar)
   * [Right-arrow operator: `->`](#right-arrow-operator--)
   * [Fat right-arrow operator: `=>`](#fat-right-arrow-operator-)
   * [Pipe operator: `|`](#pipe-operator-)
- [Conclusion](#conclusion)

---

Introduction
---

Arturo's syntax is probably as easy as it could get. Basically, you could say: *there is no syntax*.

Let's try to resume some key points of Arturo's no-syntax:

- Code is just a list of **words**, **labels**, **symbols**, **values** and **attributes** (you'll learn what all this is about very soon!)
- Code can be grouped into **blocks** (that is: a *list* of words, labels, symbols, and values within square brackets: `[ ... ]`
- A block has no meaning until it is given one, or interpreted within some specific context, that is: `[ lorem ipsum ]` is perfectly valid Arturo code, until you try to "run" it - where the interpreter will complain that it has no idea what `lorem` and `ipsum` is. Pretty much like if I tell you a word in Swahili - you'll most likely need a dictionary to figure out what it might mean.
- There are <u>no reserved "keywords"</u>. Every word can be re-defined.
- You can format your code any way you want: no semicolons to add, no obligatory newlines, no commas, no parentheses, no Python-style indentation rules
- Every **function** expects a pre-determined number of arguments. Initially, we check during evaluation, and during runtime we "consume" values until we reach the number of arguments required.

As you can see, there is not much to learn from scratch here:

Once you learn what the language [**main components**](#the-main-components) are & a few details about **[precedence and evaluation](#precedence-and-evaluation)**, then only with the [**Library Reference**](https://github.com/arturo-lang/arturo/wiki/Library) at hand (the built-in functions that are already there for you, available to use), you're pretty much ready to write *any* program. ;-)

So, let's get to the gist of the matter!

The main components
---

### Words

*Words* in Arturo are pretty much like words in English: a series of characters separated by *spaces* or some [*symbol*](#symbols). E.g.: `this is a series of words` (in this case, `this`, `is`, `a`, `series`, `of`, `words` are all - well... - *words*.

> 💡 In Arturo, a word can be formed by any letter + the character `?`

As with a real (spoken) language, every word has a specific meaning. And if you don't know the meaning of a word, you'll have to look it up in the dictionary. That's pretty much the way things work in Arturo as well.

In Arturo, a *word* may have 3 main different uses:

- refer to a value (that is: a variable, e.g. `x + 2`)
- refer to an action, which does something (that is: a function, e.g. `doSomething`) - Arturo comes with close to 150 already defined such words/functions
- refer to nothing (that is: a word without meaning, as in the `[lorem ipsum`] example above)

### Labels

A label is nothing but Arturo's way of assigning meaning (to be read as: a value) to a word - what you would normally call *variable assignment* or *variable initialization*. (In Arturo, these two terms can be used invariably, since there is practically no difference: you can set and re-define a word/variable as many times as you wish).

So, let's say you want to give a new meaning to the word `x`:

```red
x: 2
```
Basically, that was it: from now on, `x` will mean `2` (until and if it's changed). So if you follow the above statement with:
```red
print x
```
...Arturo will print `2` for you.

### Symbols

As the mere word says, *symbols* are used to symbolize something, mainly as an alias to an existing *word* - although, by convention, as *infix* operators.

Hence, let's take the function `add`. This takes two parameters, adds them up, and returns the result.

So, you may write:

```red
print add 2 3
```
and Arturo will print out `5` for you.

Now, if you don't want to use the `add` function (and *prefix notation*, which is the standard for *all* function calls), there is a *symbol-alias* for that: `+`

So, you could just as well write:

```red
print 2 + 3
```
Only, this time you're expressing it more like you would in a normal math expression: with *infix notation*.

Some of the existing *aliases* in the built-in dictionary:

<table>
<tr><th>Symbol</th><th>Aliased word</th></tr>
<tr><td><code>+</code></td><td>add</td></tr>
<tr><td><code>++</code></td><td>append</td></tr>
<tr><td><code>@</code></td><td>array</td></tr>
<tr><td><code>#</code></td><td>dictionary</td></tr>
<tr><td><code>/</code></td><td>div</td></tr>
<tr><td><code>&lt;=</code></td><td>dup</td></tr>
<tr><td><code>=</code></td><td>equal?</td></tr>
<tr><td><code>//</code></td><td>fdiv</td></tr>
<tr><td><code>$</code></td><td>function</td></tr>
<tr><td><code>\</code></td><td>get</td></tr>
<tr><td><code>&gt;</code></td><td>greater?</td></tr>
<tr><td><code>&gt;=</code></td><td>greaterOrEqual?</td></tr>
<tr><td><code>&lt;</code></td><td>less?</td></tr>
<tr><td><code>=&lt;</code></td><td>lessOrEqual?</td></tr>
<tr><td><code>:</code></td><td>let</td></tr>
<tr><td><code>%</code></td><td>mod</td></tr>
<tr><td><code>*</code></td><td>mul</td></tr>
<tr><td><code>&lt;&gt;</code></td><td>notEqual?</td></tr>
<tr><td><code>^</code></td><td>pow</td></tr>
<tr><td><code>..</code></td><td>range</td></tr>
<tr><td><code>&lt;&lt;</code></td><td>read</td></tr>
<tr><td><code>./</code></td><td>relative</td></tr>
<tr><td><code>--</code></td><td>remove</td></tr>
<tr><td><code>~</code></td><td>render</td></tr>
<tr><td><code>-</code></td><td>sub</td></tr>
<tr><td><code>?</code></td><td>switch</td></tr>
<tr><td><code>&gt;&gt;</code></td><td>write</td></tr>
</table>

### Values

Values are the very core of Arturo and are used to refer to pretty much all the different kinds of data you can have.

We could split them into 2 categories: a) literal values - that is values you can directly define in your code and b) constructible - values that are created using some function.

The complete list follows:

#### :null

Null values generally denote *nothing* and it's mostly used as a return value by functions to inform us that something went wrong. If you want to set it as a  value, you may just use the *word* `null`, like:

```red
x: null
```

#### :boolean

Booleans are Arturo's logical values. And they can have a value of either `true` or `false`

```red
x: true
y: false
```

#### :integer

Integers represent positive or negative integers. When they are declared they are comprised only by digits (`[0-9]+`) and they can be as long as you want - Arturo does support big numbers.

```red
x: 2
y: 876528347613438247982374913423423947329
```

#### :floating

Floating values are basically floating-point numbers, that is: decimals. They begin with an initial all-digit part, followed by a `.` (dot) and another all-digit part: `[0-9]+\.[0-9]+`

```red
pi: 3.14159
```

#### :type

Type is a value representing another... type. To specify a type value, the format is a `:` (colon) followed by a word - the type's name: `:\w+`

```red
myType: :integer
```
or
```red
if (type x) = :integer [ print "it's an integer!" ]
```

#### :char

Characters in Arturo can be declared using backticks:  `` `\w` ``

```red
ch: `a`
```

#### :string

A string is nothing but a series of characters, seen as one unit. In Arturo, in order to define a string, there are various ways:

**Single-line strings**

- using double quotes: ```x: "this is a string"``` (with escaped characters)
- using right *smart-quote* notation ```x: » This is a string``` (in this case, everything following `»` till the end of the line, will be stripped and considered one string)

**Multi-line strings**

- using curly-brace blocks (the result will be stripped and un-indented):
  ```red
  x: {
      this is yet
      another
      very
      long string
      that spans more
      than
      one
      line
  }
  ```

- using verbatim curly-brace blocks (the result will remain exactly as-is):
  ```red
  x: {:
    this is yet
      another
      very
    long string
    that spans more
        than
            one
            line
  :}
  ```
- using dash notation (where everything after the line, until the end of the file, is a string - stripped and un-indented):
  ```red
  x: 
  ------
  this is the last very
  long string
  that spans more
  than
  one
  line
  ```

> 💡 If you want your string to contain sub-expressions that will be evaluated on-the-fly - that is *string interpolation* - all you have to do is include your code inside the string within pipe-bars and then call the function `render` (or `~`) to process it accordingly: e.g. 
> ```red
> x: 2
> print ~"my variable is: |x|"
> 
> ; prints: 
> ; my variable is: 2
> ```

#### :literal

Literals in Arturo are just a way of referring to the *name* of a word or symbol. Think of it as the *string* version of a word, or like Ruby's *symbols*. 

For example, the function `info` takes as an argument the name of the function for which you want some information. If you wrote like `info print`, the interpreter would execute the function `print` and try to... print something (which would not be there). If you wanted to refer to the *name* of the function -- that is: without actually calling it -- you would precede it with a `'` (single-quote): `'[\w+]`

```red
func: 'print
info func
```

#### :path

Paths in Arturo are a way of defining some hierarchy between values, something along the lines of: *parent* -> *child* -> *grandchild*. For this, in Arturo, we'd use a series of *values* or *words* delimited with a `\` (backslash). You can think of them as *indexes* in other programming languages.

```red
print user\name
```

or

```red
x: "name"
print user\(x)
```

or

```red
myArray: ["zero" "one" "two" "three"]
print myArray\1

; prints "one"
```

#### :inline

*Inline*s in Arturo generally denote a list of words/symbols/values that are grouped and given some type of priority in evaluation. An *inline* block is denoted by `(...)` (parentheses).

```red
print (2+3)*4
```

Please note though that, apart from precedence, `:inline` is a value type on its own:

```red
a: [(one) two three]
print type a\0 			; that is: (one)

; prints :inline
```

#### :block

Blocks are a fundamental part of Arturo.

As we've already said, it's just a `[...]` (square-bracket enclosed) block of words/symbols/values that - in contrast with *inline* blocks above which are evaluated in-place - are <u>not evaluated</u> until it's necessary.

```red
myBlock: [one two three]
anArray: [1 2 3 4 5]
anotherArray: ["zero" 1 "two" 3 "cuatro"]
```

As you can see, blocks can contain practically anything: any word, any symbol, and any value. Of course, they can contain other blocks too:

```red
x: [
   1 2 [
       3 4 [
           5 "six" 7
       ] 
       8 
   ] 
   9
]
```

#### :dictionary

Dictionaries in Arturo as what in other languages you'd call an *associative array* or *hash table*. If you want to create one, just give the `dictionary` function (or use the `#` alias) a block, with different labels, and it'll automatically convert it to a dictionary.

```red
user: #[
     name: "John"
     surname: "Doe"
     age: 34
]
```

What the `#` function here does is:
- execute the block
- retrieve only the words/variables defined in there
- return a dictionary with the aforementioned words

> 💡 As you can probably assume from the above definition, a dictionary block doesn't necessarily have to contain just labels and word definitions - it may contain whatever you want, even function calls; only it will return you back just a table with the defined words in there

#### :function

Functions are another important value type in Arturo - and yes, you heard right: *functions* a *value* too. You can assign them to a word/variable, pass them around, re-define them and whatever you want with them, pretty much as you would do with another value, let's say a number.

To define a function, all you have to do is call the `function`... function (or use the `$` alias) followed by two parameters:
- the parameters' names (this can be either a literal, e.g. `'x` - if it's just one argument - or a block, e.g. `[x y]`. If you want to use commas, for readability, like `[x,y]` you are free to do so: Arturo will simply ignore them.

```red
multiply: function [x y][
     x * y
]

print multiply 2 3

; would print 6
```

or

```red
addThemUp: $[x,y][x+y]

print addThemUp 2 3

; would print 5
```

#### :date

Dates in Arturo are a distinct type of value. If you want to create one, you'll have to use one of the corresponding functions. For example, the function `now` returns a `:date` object, representing the current point in time. And it can be handled pretty much like you would handle a `:dictionary`.

```red
print now

; would print 2020-10-26T10:27:14+01:00

print now\year

; would print 2020
```

#### :binary

Binary values are used to represent *binary* data, that is: an array of bytes. You cannot define them directly, however, you can sure convert other data to binary.

```red
print to :binary "Hello world!"

; would print 4865 6C6C 6F20 776F 726C 6421
```

### Attributes

Another interesting feature of Arturo is what we'll analyze here: attributes.

Basically, *attributes* are nothing but an easy way of defining optional named parameters for functions - but which can however transcend between different function calls.

There are two types: 

 a. attributes   
 b. attribute labels

#### :attr

Attributes are basically optional on/off-type of values, set during a function call, that is there to denote some variation of the initial meaning of the function. To define an attribute, we'll be using a `.`(dot) followed by a normal word: `\.\w+`

Let's say we used the function `split`, to split a string into parts:
```red
split "hello world"

; => [`h` `e` `l` `l` `o` ` ` `w` `o` `r` `l` `d` ]
```
That does what it says: splits the string into an array of `:char`s.

What if we want for example to split the string into words? For that, there is the `.words` attribute for the function `split`. So:

```red
split.words "hello world"

; = ["hello" "world"]
```
> 💡 The order in which you pass the different attributes does <u>not</u> matter. Also, there is no issue at all whether you want to use spaces between them and the surrounding function call; Arturo will still be able to parse them and recognize them fine

#### :attrLabel

Attribute labels are pretty much like simple *attributes*, only they can also take a value. As it worked with *attributes*, we'll be using a `.`(dot) followed by a normal word, but now also followed by a `:`(colon) -- exactly like with normal *labels*, as we've seen above.

Here's an example:

```red
split .every: 2 "hello world"

; => ["he" "ll" "ow" "or" "ld"]
```

Precedence and Evaluation
---

The easiest way to explain precedence rules in Arturo is pretty much like it happened with our introduction: there are <u>no precedence rules</u> whatsoever.

So, in an expression like `2 * 3 + 4`, if you'd normally expect to get a result of `10`, you would be wrong: the result is `14`.

But in order to understand why, you'd have to understand how evaluation in Arturo works.

### The right-to-left rule

The main expression evaluation order of Arturo is *right-to-left*. But with a tiny asterisk: Your code *will* be evaluated from left-to-right, it is the expressions passed to your function calls that will be evaluated from right-to-left.

Let's take a very simple example:

```red
print add 1 2 
print "Done"
```

As you would expect, the first function to be executed is the first `print` function and then the second one. Nothing new here.

Now let's take the first `print`. How is it working?

Let's see:

- First, the value `2 ` is pushed onto the stack
- Then, we push the value `1	`
- Then, we execute the function `add`: it pops two values from the stack, adds them up, and pushes the result (`3`) back onto the stack
- Finally, we execute the function `print`: it pops the top value from the stack (`3`) and prints it.

Then, execution would move on and... `print "Done."`

What you have to understand here is that evaluation within an expression will *always* be done from right to left, irrespective of what you might know from other languages or math operator precedence. In Arturo, you have to learn <u>no precedence rules</u> at all. You'll just have to remember to always calculate from right to left.

Re-visiting our previous, seemingly paradoxical, example:

```red
2 * 3 + 4
```
> 💡 Remember: our `+` and `*` operators are nothing but simple *infix* aliases to the functions `add` and `mul` respectively -- nothing more!

This is as if we had written (moving the operators in front):

```red
* 2 + 3 4
```

which practically means: FIRST add 3 and 4 and THEN take the result and multiply it with 2.

If this is not what intended, then the right way in Arturo would be, either:

```red
4 + 2 * 3
```

or (giving precedence to the multiplication, artificially, using parentheses): 

```red
(2 * 3) + 4
``` 

Syntactic sugar
---

As you have hopefully seen so far, Arturo is rather simple, with fairly simple rules and that's pretty much it.

However, we also have some "syntactic sugar": a fancy way of referring to syntactic constructs, so that something more complicated will look better, or easier-to-write, or more readable.

Here you'll learn about some useful examples of *syntactic sugar* supported in Arturo.

### Right-arrow operator: `->`

The function of the right operator is rather straightforward: basically, it wraps the following *terminal* value inside a block.

Let's take a simple example.

```red
x: -> 2
```
This is 100% equivalent to:

```red
x: [2]
```

You can also use the right-arrow operator to make many common constructs far more readable.

For example:

```red
if x=2 -> print "x was 2!"
```
is the same as writing:

```red
if x=2 [ print "x was 2!" ]
```

As you can see, it can be pretty handy. Just remember that `->` can wrap only <u>one</u> *terminal* value.

For example:

```red
x: -> 2 3
```

This doesn't result in `x: [2 3]` but in `x: [2] 3`

Another interesting way of making use of the power of the *right-arrow operator*:

```red
loop 1..10 'x -> print x
```

which is the same as writing (only much more elegant):

```red
loop 1..10 'x [ print x ]
```

### Fat right-arrow operator: `=>`

The fat right-arrow operator is like a super-charged *simple* right arrow operator (`->`) as described above.

If `->` was used to wrap the following terminal into a block, the `=>` operator does even more.

Let's take this simple example:

```red
x: $ => add
```

This is equivalent to writing:

```red
x: $[x,y][add x y]
```

Basically, it reads the following word, and if it's a function, pushes all it's needed arguments as anonymous variables.

The same could work with a block argument, where `&` can be used as a placeholder for the needed anonymous variables:

```red
x: $ => [add & &]
```

(The first `&` will pop the first argument, and the second the next one - and so on...)

---

As you can already imagine, this is perfect for easily defining functions or action blocks that take exactly one parameter.

For example, to print an array of the even numbers between 1 and 10:

```red
print select 1..10 'x [even? x]
```

This could be easily written as (using the `->` operator):

```red
print select 1..10 'x -> even? x
```

But pushing the limits more, we can also use the `=>` operator:

```red
print select 1..10 => even?
```

That's surely much more readable, isn't it?


### Pipe operator: `|`

> ⚠️ This is experimental and may still not be stable enough for use in production scripts

The *pipe* operator is an easy way of reversing the default *prefix* notation of function calls and simulating what in OOP languages is called *function chain*.

Let's take this simple example:

```red
1..10 | print
```

This equivalent to:

```red
print 1..10
```
Or a bit more elaborate example (using *pipes* and the `=>` operator):

```red
1..10 | map => 2*
      | select => even?
      | print
```

which would be like writing:

```red
print select map 1..10 'x [2*x] 'x [even? x] 
```

----

Conclusion
---

If you made it till here, then I can assure you: you've already learned more than you need in order to be fully proficient in Arturo.

Just head to the [Library Reference](https://github.com/arturo-lang/arturo/wiki/Library) and have a look at the built-in functions (with explanations and example code) and see what's already available for you or - if you want to see the language in action - just browse through the [examples/](https://github.com/arturo-lang/arturo/tree/master/examples) folder in the main source repo: there are many many *working* examples, to get more than just an idea.

**Welcome on board! :)**
