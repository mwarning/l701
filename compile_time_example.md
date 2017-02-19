
```
struct Number {
	u64 n;
	compile_time {
		u64 min;
		u64 max;

		fn opSmaller(Self &self, astc &node) ast {
			if (node != Number) {
				error(...)
			}

			if node.min > self.max {
				return ast false
			}

			if (node.max < self.min) {
				return ast true
			}

			return ast internal.lower(self, node)
		}
	}
}

fn if(astc &exp, astc &scope) {
	if exp != Bool {
		error(...)
	}

	if (exp == true) {
		return scope
	}

	if (exp == false) {
		return empty_scope
	}

	return ast internal.if(exp, scope)
}

fn foo() {
	let n = rand();
	if (n < 3) {
		
	}
}

struct Ptr {
	usize ptr;
	//How to know where to free?
}

struct Leg {
	Body *body;
}

struct Body {
	Leg *right;
	Leg *left;
}

fn bar() {
	let body = new Body();
	body.left = new Leg(&body);
	body.right = new Leg(&body);

	//make sure body is freed along with legs
}
```