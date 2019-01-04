%define api.pure full
%define parse.error verbose
%param {yyscan_t scanner}
%parse-param {struct ast *root}
%locations

//%lex-param {yyscan_t scanner}
//%parse-param {yyscan_t scanner}

%output "build_parse.c"
%defines "build_parse.h"

/*
%union {
    struct string_t string;
    struct number_t number;
    int n;
}
*/

%code requires {
#include "build_tree.h"

#define YYSTYPE struct ast*
    typedef void *yyscan_t;
}

%code {
#include "build_lex.h"

#include <stdio.h>

void yyerror(YYLTYPE *yylval, yyscan_t scanner, struct ast *root, char const *msg)
{
	(void) scanner;
	(void) root;
    fprintf(stderr, "%d:%d: %s\n", yylval->first_line, yylval->first_column, msg);
}

}

%token end_of_file 0 "end of file"
%token LCURVEDPAREN
%token RCURVEDPAREN
%token LSQUAREPAREN;
%token RSQUAREPAREN;
%token LCURLYPAREN;
%token RCURLYPAREN;
%token SEMICOLON;
%token DOUBLE_NEWLINE;
%token COMMENT
%token PLUS
%token MUL
%token EQUAL
%token STRING;
%token NUMBER;

%%

start:
	LCURVEDPAREN STRING RCURVEDPAREN { $$ = ast_new("()", 2); ast_add($$, $1); ast_add(root, $$); }
	| LSQUAREPAREN NUMBER RSQUAREPAREN { $$ = ast_new("[]", 2); ast_add($$, $1); ast_add(root, $$); }
	//| <<EOF>> { out = $$; printf("done\n"); }

program:
  %empty {
    // printf("Empty program\n");
  }
  | NUMBER { out = $$; ; printf("done\n"); };

expr:
	NUMBER
	| expr '+' NUMBER { /*printf("%d %d %d\n", $1, $2, $3);*/ }
