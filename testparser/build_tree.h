
#pragma once

/*
struct top_level {
	int n;
};

struct string_t {
	char const *str;
	unsigned int len;
	//unsigned int beg;
};

struct number_t {
	char const *str;
	unsigned int len;
};
*/

struct ast {
	char *name;
	struct ast **args;
};

struct ast *ast_new(const char* name, int len);
struct ast * ast_insert(const char *name, struct ast *parent, struct ast *child);
void ast_add(struct ast *root, struct ast *item);
void ast_free(struct ast *root);
void ast_print(const struct ast *root, int indent);

/*
int consume_string(struct string_t *string);
int consume_number(struct number_t *number);
*/
