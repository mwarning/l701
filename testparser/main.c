
#include <stdio.h>
#include <stdlib.h>

#include "build_parse.h"
#include "build_lex.h"
#include "utils.h"
#include "ast.h"
#include "main.h"


int main(int argc, const char** argv) {
	FILE *file = NULL;

	if (argc != 2) {
		fprintf(stderr, "Expected file input\n");
	}

	file = fopen(argv[1], "r");
	if (!file) {
		printf("cannot open file");
		return EXIT_FAILURE;
	}

	struct top top = {
		.root = NULL,
		.path = strdup(argv[1])
	};

	yyscan_t scanner;

	yylex_init(&scanner);
	if (file) {
		yyset_in(file, scanner);
	} else {
		yyset_in(stdin, scanner);
	}

	int rc = yyparse(scanner, &top);
	yylex_destroy(scanner);

	printf("AST for %s\n", top.path);
	ast_print(top.root, 0);

	if (rc == 0) {
		printf("success\n");
	}

	return rc;
}
