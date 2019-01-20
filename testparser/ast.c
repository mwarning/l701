
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "ast.h"


void ast_print(const struct ast *ast, int indent) {
	struct ast **child;
	int i;

	if (ast == NULL) {
		return;
	}

	for (i = 0; i < indent; i += 1) {
		printf(" ");
	}

	printf("'%s' (%d - %d)\n", ast->name, ast->start, ast->end);

	child = ast->args;
	if (child) {
		while (*child) {
			ast_print(*child, indent + 1);
			child += 1;
		}
	}
}

struct ast *ast_new(const char* name, int len, int start, int end) {
	struct ast *item;
	if (len <= 0) {
		len = strlen(name);
	}

	item = (struct ast*) malloc(sizeof(struct ast));
	item->name = strndup(name, len);
	item->start = start;
	item->end = end;
	item->args = NULL;

	//printf("ast_new: %s\n", item->name);

	return item;
}

static int ast_args_len(const struct ast *root) {
	struct ast **args;
	int i;

	i = 0;
	args = root->args;
	if (args) {
		while (*args) {
			args += 1;
			i += 1;
		}
	}

	return i;
}

void ast_free(struct ast *root) {
	int i = 0;

	while (root->args && root->args[i]) {
		ast_free(root->args[i]);
		i += 1;
	}

	free(root->args);
	free(root);
}

struct ast *ast_new_add(const char *name, struct ast *c1, struct ast *c2, int start, int end) {
	if (0 == strcmp(c1->name, name)) {
		ast_add(c1, c2);
		return c1;
	} else {
		struct ast *c = ast_new(name, 0, start, end);
		ast_add(c, c1);
		ast_add(c, c2);
		return c;
	}
}

void ast_add(struct ast *root, struct ast *item) {
	int len = ast_args_len(root);
	//printf("%s: %d\n", root->name, len);

	//printf("ast_add(%p, %p)\n", root, item);
	if (len) {
		root->args = (struct ast**) realloc(root->args, (len + 2) * sizeof(struct ast*));
	} else {
		root->args = malloc(2 * sizeof(struct ast*));
	}

	root->args[len+0] = item;
	root->args[len+1] = NULL;
	//printf("%s: %d\n", root->name, ast_args_len(root));
}
