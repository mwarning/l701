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
%token ';'
%token COMMENT
%token OP
%token STRING
%token NUMBER
%token '-' '+' '*' '/' '=' '.'

/* operator precedence - first ones have higher precedence */
%left ':'
%left '+' '-'
%left '*' '/'
%left '.'
%left '='

%%

/*
a = b; b = c;
{
	foo()
};
{
	bar(1, 3; 4 + 5).x 12
}
a.b.c[];
a+c + d

foo { foo sd sd sd; }
[1, 2, 3; 4, 5, 6]
a.b.c()[12]
var x = { a: 12, c: 34}
struct foo {
}

- matrix ()
- webrtc
- preview
- chat feature (dtn)
- bugfixing / polishing (android versionen)

*/

start:
	expr_list expr_end { printf("start\n"); ast_add(root, $1); }

expr_end:
	%empty
	| ';'

expr_list:
	expr { printf("expr\n"); $$ = $1; }
	| expr_list ',' expr { printf("expr_list ',' expr\n"); $$ = ast_new_add(",", $1, $3); }
	| expr_list ';' expr { printf("expr_list ';' expr\n"); $$ = ast_new_add(";", $1, $3); }

expr:
	NUMBER { printf("parse number: %s\n", $1->name); $$ = $1; }
	| STRING { printf("parse string: %s\n", $1->name); $$ = $1; }
	| expr '+' expr { printf("parse %s + %s\n", $1->name, $3->name); $$ = ast_new_add("+", $1, $3); }
	| expr '-' expr { printf("parse %s + %s\n", $1->name, $3->name); $$ = ast_new_add("-", $1, $3); }
	| expr '*' expr { printf("parse %s * %s\n", $1->name, $3->name); $$ = ast_new_add("*", $1, $3); }
	| expr '/' expr { printf("parse %s * %s\n", $1->name, $3->name); $$ = ast_new_add("/", $1, $3); }
	| expr '.' expr { printf("parse %s . %s\n", $1->name, $3->name); $$ = ast_new_add(".", $1, $3); }
	| expr '=' expr { printf("parse %s = %s\n", $1->name, $3->name); $$ = ast_new_add("=", $1, $3); }
	| expr ':' expr { printf("parse %s : %s\n", $1->name, $3->name); $$ = ast_new_add(":", $1, $3); }
	| scope

scope:
	  '(' ')' { $$ = ast_new("()", 0, 0, 0); }
	| '[' ']' { $$ = ast_new("[]", 0, 0, 0); }
	| '{' '}' { $$ = ast_new("{}", 0, 0, 0); }
	| '(' expr_list ')' { $$ = ast_new("()", 0, 0, 0); ast_add($$, $2); }
	| '[' expr_list ']' { $$ = ast_new("[]", 0, 0, 0); ast_add($$, $2); }
	| '{' expr_list '}' { $$ = ast_new("{}", 0, 0, 0); ast_add($$, $2); }
