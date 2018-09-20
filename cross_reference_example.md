
struct A {
	b : *B
}

struct B {
	a : *A
}

fn foo(a : *A, b : *B) {
	a.b = b;
	b.a = a;
}

fn main() {
	let a = A::new();
	let b = B::new();

	foo(a, b);

	/*
	How to prove that each others reference is valid and both have the same lifetime?
	*/
}