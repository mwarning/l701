
#pragma once

struct top_level {
	int n;
};

struct string_t {
	char const *str;
	unsigned int len;
};


void consume_parens(struct string_t *string);
