
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "build_tree.h"

/*
foo { foo sd sd sd; }
[1, 2, 3; 4, 5, 6]
a.b.c()[12]
var x = { a: 12, c: 34}
struct foo {
}
*/

void ast_print(const struct ast *ast, int indent) {
	struct ast **child;
	int i;

	if (ast == NULL) {
		return;
	}

	for (i = 0; i < indent; i += 1) {
		printf(" ");
	}

	printf("'%s'\n", ast->name);

	child = ast->args;
	if (child) {
		while (*child != NULL) {
			ast_print(*child, indent + 1);
			child += 1;
		}
	}
}

struct ast *ast_new(const char* name, int len) {
	struct ast *item;

	if (len <= 0) {
		len = strlen(name);
	}

	item = (struct ast*) malloc(sizeof(struct ast));
	item->name = strndup(name, len);
	item->args = NULL;

	return item;
}

static int ast_args_len(const struct ast *root) {
	struct ast **item;
	int i;

	i = 0;
	item = root->args;
	if (item) {
		while (*item) {
			item += 1;
		}
	}

	return i;
}

void ast_free(struct ast *root) {
	free(root->args);
	free(root);
}

void ast_add(struct ast *root, struct ast *item) {
	int len = ast_args_len(root);

	if (len) {
		root->args = (struct ast**) realloc(root->args, (len + 1) * sizeof(struct ast*));
	} else {
		root->args = malloc(2 * sizeof(struct ast*));
	}

	root->args[len+0] = item;
	root->args[len+1] = NULL;
}

/*
int consume_string(struct string_t *string)
{
	printf("string: '%.*s'\n", string->len, string->str);
	return 0;
}

int consume_number(struct number_t *number)
{
	printf("number: '%.*s'\n", number->len, number->str);
	return 0;
}
*/