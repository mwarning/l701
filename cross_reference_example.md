
struct A {
	B* b
}

struct B {
	A* a
}

fn main() {
	let a = A::new();
	let b = B::new();
	a.b = b;
	b.a = a;
	/*
	How to prove that each others reference is valid and both have the same lifetime?
	*/
}