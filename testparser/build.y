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
#include "ast.h"

#define YYLTYPE yyltype
typedef struct yyltype
{
	int first_line;
	int first_column;
	int last_line;
	int last_column;
	int start;
	int end;
} yyltype;

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
%token ';'
%token COMMENT
%token OP
%token STRING
%token NUMBER
%token '-' '+' '*' '/' '=' '.'

/* operator precedence - first ones have lower precedence */
%left ':'
%left '+' '-'
%left '*' '/'
%left '.'
%left '='

%%

start:
	expr_list expr_end { ast_add(root, $1); }

expr_end:
	%empty
	| ';'

expr_list:
	expr { $$ = $1; }
	| expr_list ',' expr { $$ = ast_new_add(",", $1, $3, @2.start, @2.end); }
	| expr_list ';' expr { $$ = ast_new_add(";", $1, $3, @2.start, @2.end); }

expr:
	NUMBER { printf("parse number: %s\n", $1->name); $$ = $1; }
	| STRING { printf("parse string: %s\n", $1->name); $$ = $1; }
	| expr '+' expr { $$ = ast_new_add("+", $1, $3, @2.start, @2.end); }
	| expr '-' expr { $$ = ast_new_add("-", $1, $3, @2.start, @2.end); }
	| expr '*' expr { $$ = ast_new_add("*", $1, $3, @2.start, @2.end); }
	| expr '/' expr { $$ = ast_new_add("/", $1, $3, @2.start, @2.end); }
	| expr '.' expr { $$ = ast_new_add(".", $1, $3, @2.start, @2.end); }
	| expr '=' expr { $$ = ast_new_add("=", $1, $3, @2.start, @2.end); }
	| expr ':' expr { $$ = ast_new_add(":", $1, $3, @2.start, @2.end); }
	| scope

scope:
	  '(' ')' { $$ = ast_new("()", 0, @1.start, @2.end); }
	| '[' ']' { $$ = ast_new("[]", 0, @1.start, @2.end); }
	| '{' '}' { $$ = ast_new("{}", 0, @1.start, @2.end); }
	| '(' expr_list ')' { $$ = ast_new("()", 0, @1.start, @3.end); ast_add($$, $2); }
	| '[' expr_list ']' { $$ = ast_new("[]", 0, @1.start, @3.end); ast_add($$, $2); }
	| '{' expr_list '}' { $$ = ast_new("{}", 0, @1.start, @3.end); ast_add($$, $2); }
