/*
** main.c
** Expression Parser
**
** By poilynx
** 21 Jul 16
*/
#include <stdio.h>
#include <stdlib.h>
int yyerror();
int yyparse();
int yylex();

int main() {
	return yyparse();
}

