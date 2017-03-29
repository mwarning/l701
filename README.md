# l701

l701 is an old project name of mine to create a programming language, hence named l701, that fulfills what I feel is lacking in modern programming languages.
The name is a reference to the paper "The Next 700 Programming Languages" by P. J. Landin. :-)

ln contrast to building a language on top of logic as done in functional programm languages,
l701 is meant to constist of a core language based on processor primitives (if, goto .. mostly portable assembler) that allow to go even more low level than C. E.g. to write calling conventions.
High language contructs are implemented as part of compile time methods and allow to build a strongly typed high level language that enables memory safety with (hopefully) zero overhead abstractions.

High level features with no particular order:

- syntax is lisp in spirit that looks more like C
- stdlib base uses compile time functions and libc with compile time wrappers only (e.g. to check the printf format string or to check memory usage at compile time like in rust)
- immutability by default
- code can be used at compile time and runtime without modifications
- ability to write calling conventions
- unsafe low level primitives to build safe high level language primitives
- small language core, high level concepts implemented via libraries
- no method overloading a it's core language, but it can be implemented in a library with near zero limitations, same for default arguments and named arguments
- unified function call syntax: obj.func() is the same as func(obj)
- algebraic data types - should be implementable in a library
- no garabage collector
- small binary size, mostly due to zero cost abstractions over libc
- optional output into readable C code would be nice
- std library that is a compile time wrapper around stdc, this will keep binaries small
- universal function calls foo.bar(12) == bar(foo, 12)
- move semantics by default (implemented in a compile time library)

A method called `match` can be implemented in a library that takes two arguments and creates low level code:
```
match expr {
1 => print("A"),
2 => print("B"),
3 => print("C"),
}
```
could transform at compile time to this representation
```
let v = expr;
if (v == 1) {
	print("A");
} else if (v == 2) {
	print("B");
} else if (v == 3) {
	print("C");
}
```

`match` would check the exhaustiveness of the matches, types and add apply preliminary optimizations.

```
let v = foo();
if (v == 0) {
	// Save. Type set of v does not include 0. 
	let x = 1 / v;
}

// Error.
let y = 1 / v;
```
Types can be changed to express e.g. that a number is not 0.
A type is compromsed of a set of possible values and properties, expressed by methods that are true (e.g. is_even()).


Proposed Base Types:
* Integer types: i8, u8, u16, i16, u32, u32, u64, i64, ...
* Floating point types: f16, f32, f64, ..
* Static array type: u32[12] (12 consecutive u32 integers)

## Internal Syntax Representation

The Syntax is basicly Lisp, but looks like C with more regularity.
Some examples with possible internal representations:

* `1 + 2 * 3` => `opPlus(1, opStar(1, 2))`
* `def foo() {}`=> `opLine(def, opTouch(foo, opRoundBrackets()), opCurlyBrackets)`
* `[a, b, c]` => `opSquareBrackets(opComma(a, b, c))`
* `[a; b, c]` => `opSquareBrackets(opSemicolon(a, OpComma(b, c)))`

```
def main() {
  let x = 0
  x += 1
}
```
=>
`opLine(def, opTouch(main, opRoundBrackets, opCurlyBrackets(opLines(opLine(opEqual(let(x), 0)), opLine(opPlusAssign(x, 1))))))`

In the internal representation, `opEqual` would actually be `op=`, opComma would be `op,`.
Speaking names are used here in these examples to only make the function names appear less cryptic.

## Operator overloading
Maybe be useful in some cases.
expr = item1 * item2

transforms to item1.op("*", item2) which might transform to item1.opStar(item2)

## Concurrency
Threads are also modelled as types. That might allow to trigger errors in case of resources being accessed without proper fencing or high level constructs e.g. as  go langauge channels.
