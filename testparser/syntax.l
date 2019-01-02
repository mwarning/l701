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
		yycolumn += yyleng; \
	}
%}

SL "([^"]|\\")*"

%%

\ *  /* ignore */
\n   yycolumn = 1;
\(   return LPAREN;
\)   return RPAREN;
[a-z]* yylval->string.str = yytext; yylval->string.len = yyleng; return STRING;
.  fprintf(stderr, "%d:%d: Unknown token: %.*s\n", yylineno, yycolumn, yyleng, yytext);
