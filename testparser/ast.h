
#pragma once

struct ast {
	char *name;
	int start;
	int end;
	struct ast **args;
};

struct ast *ast_new(const char* name, int len, int start, int end);
void ast_add(struct ast *root, struct ast *item);
struct ast *ast_new_add(const char *name, struct ast *c1, struct ast *c2, int start, int end);
void ast_free(struct ast *root);
void ast_print(const struct ast *root, int indent);
