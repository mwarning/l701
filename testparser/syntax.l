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

\ *  ; /* ignore spaces */
\n   yycolumn = 1;
\n\n yycolumn = 2; return DOUBLE_NEWLINE;
";"  yycolumn = 2; return SEMICOLON;
"("   return '(';
")"   return ')';
"["  return '[';
"]"   return ']';
"{"   return '{';
"}"   return '}';
"="  return EQUAL;
"+"  return PLUS;
"*"  return MUL;
"//"[^\n]*"\n"  return COMMENT;
[0-9]*          *yylval = ast_new(yytext, yyleng); return NUMBER; //yylval->number.str = yytext; yylval->number.len = yyleng; return NUMBER;
[a-zA-Z]*       *yylval = ast_new(yytext, yyleng); return STRING; //yylval->string.str = yytext; yylval->string.len = yyleng; return STRING;
.  fprintf(stderr, "%d:%d: Unknown token: %.*s\n", yylineno, yycolumn, yyleng, yytext);
