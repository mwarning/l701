%option 8bit
%option never-interactive
%option noyywrap
%option bison-bridge
%option bison-locations
%option reentrant
%option nodefault
%option warn
%option yylineno
%option outfile="build_lex.c"
%option header-file="build_lex.h"

%{
#include "build_parse.h"

#define YY_USER_ACTION \
	{ \
		yylloc->first_line = yylloc->last_line; \
		yylloc->first_column = yylloc->last_column; \
		yylloc->last_line = yylineno; \
		yylloc->last_column = yycolumn; \
		yylloc->start = yylloc->end; \
		yylloc->end = yylloc->end + yyleng; \
	}
%}

SL "([^"]|\\")*"

%%
[ \n\t]+         ; /* ignore */
";"    return ';';
","    return ',';
"."    return '.';
"("    return '(';
")"    return ')';
"["    return '[';
"]"    return ']';
"{"    return '{';
"}"    return '}';
"+"    return '+';
"-"    return '-';
"*"    return '*';
"/"    return '/';
"="    return '=';
"//"[^\n]*"\n"  return COMMENT;
[=+\-*/^]*	    *yylval = ast_new(yytext, yyleng, yylloc->start, yylloc->end); return OP;
[0-9]*          *yylval = ast_new(yytext, yyleng, yylloc->start, yylloc->end); return NUMBER;
[a-zA-Z_]*      *yylval = ast_new(yytext, yyleng, yylloc->start, yylloc->end); return STRING;
.               fprintf(stderr, "%d:%d: Unknown token: %.*s\n", yylineno, yycolumn, yyleng, yytext);
