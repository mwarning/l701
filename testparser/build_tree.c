
#include <stdio.h>

#include "build_tree.h"


void consume_parens(struct string_t *string)
{
	printf("found: '%.*s'\n", string->len, string->str);
}
