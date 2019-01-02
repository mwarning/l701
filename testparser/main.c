
#include <stdio.h>
#include <stdlib.h>

#include "build_tree.h"
#include "build_parse.h"
#include "build_lex.h"

int main(int argc, const char** argv)
{
	FILE *myfile = NULL;

	if (argc == 2) {
		myfile = fopen(argv[1], "r");
		// make sure it's valid:
		if (!myfile) {
			printf("cannot open file");
			return -1;
		}
	}

	struct top_level top;

	yyscan_t scanner;

	yylex_init(&scanner);
	if (myfile) {
		yyset_in(myfile, scanner);
	} else {
		yyset_in(stdin, scanner);
	}
	int rc = yyparse(scanner, &top);
	yylex_destroy(scanner);

	return rc;
}
