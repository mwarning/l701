# l701

l701 is an old project name of mine to create a programming language, hence named l701, that fulfills what I feel is lacking in modern programming languages.
The name is a reference to the paper "The Next 700 Programming Languages" by P. J. Landin. :-)

ln contrast to building a language on top of logic as done in functional programm languages,
l701 is meant to constist of a core language based on processor primitives (if, goto .. mostly portable assembler) that allow to go even more low level than C. E.g. to write calling conventions.
High language contructs are implemented as part of compile time methods and allow to build a strongly typed high level language that enables memory safety with (hopefully) zero overhead abstractions.

High level features with no particular order:

- immutability by default
- code can be used at compile time and runtime without modifications
- ability to write calling conventions
- unsafe low level primitives to build safe high level language primitives
- small language core, high level concepts implemented via libraries
- no method overloading a it's core language, but it can be implemented in a library with near zero limitations, same for default arguments and named arguments
- unified function call syntax: obj.func() is the same as func(obj)
- algebraic data types
- no garabage collector

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
