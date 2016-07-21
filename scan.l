/*
** scan.y
** Lex file to parse expression
**
** By poilynx
** 21 Jul 16
*/
%{
#include <stdio.h>
#include "gram.h"
%}

whitespace	[ \t\n\r]
integer		[0-9]+
float		{integer}([.]{integer})?
word		[A-Za-z]+
%%
{whitespace} {};
{float} {
	yylval.fnumber = atof((char*) yytext);
	return NUMBER;
}
{word} {
	yylval.string = strdup(yytext);
	return WORD;
}
"," return COMMA;
"+"	return PLUS;
"-"	return MINUS;
"*"	return ASTERISK;
"/"	return SLASH;
"^"	return CARET;
"("	return LB;
")"	return RB;


%%
int yywrap() { 
	return 1; 
}

