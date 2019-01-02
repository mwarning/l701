%define api.pure full
%define parse.error verbose
%param {yyscan_t scanner}
%parse-param {struct top_level *top}
%locations

%output "build_parse.c"
%defines "build_parse.h"

%union {
    struct string_t string;
}

%code requires {
#include "build_tree.h"

    typedef void *yyscan_t;
}

%code {
#include "build_lex.h"

#include <stdio.h>

void yyerror(YYLTYPE *yylval, yyscan_t scanner, struct top_level *top, char const *msg)
{
	(void) scanner;
	(void) top;
    fprintf(stderr, "%d:%d: %s\n", yylval->first_line, yylval->first_column, msg);
}

}

%token end_of_file 0 "end of file"
%token LPAREN
%token RPAREN
%token<string> STRING
%%

start:
	LPAREN STRING RPAREN { consume_parens(&$2); }
