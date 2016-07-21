/*
** gram.y
** Yacc file to parse expression
**
** By poilynx
** 21 Jul 16
*/
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
int yyerror();
int yylex();
%} 
%token <fnumber> NUMBER
%token <string> WORD
%token PLUS MINUS ASTERISK SLASH CARET LB RB COMMA
%type <fnumber> A B C D E
%type <numlist> X Y
%union {
	double fnumber;
	char * string;
	struct {int n;double vals[32];} numlist;
}

%left ADD SUB
%left UMINUS

%%
A	: {$$ = 0;}
	| B {printf("%lf\n",$1);$$=0;}
	;

B	: B PLUS C {$$ = $1 + $3;}
	| B MINUS C {$$ = $1 - $3;}
	| C {$$ = $1;}
	;

C	: C ASTERISK D {$$ = $1 * $3;}
	| C SLASH D {
		if($3 == 0) {
			yyerror("The divisor cannot be 0");
			exit(1);
		} else
			$$ = $1 / $3;
	}
	| D {$$ = $1;}
	;

D	: E CARET D {$$ = pow($1,$3);}
	| E {$$ = $1;}
	;
E	: LB B RB {$$ = $2;}
	| WORD LB Y RB {
		if(strcmp($1,"sqr") == 0) {
			if($3.n != 1) {
				yyerror("Number of 'sqr' func parameters does not match.");
				exit(1);
			} else 
				$$ = sqrt($3.vals[0]);
		} else if(strcmp($1,"avg") == 0) {
			double sum;
			int i;
			if($3.n == 0) return 0;
			for(i=0,sum=0;i<$3.n;i++) {
				sum += $3.vals[i];
			}
			$$ = sum / $3.n;
		} else {
			yyerror("Unrecognized function.");
			exit(1);
		}
}
	| NUMBER {$$ = $1;}
	| PLUS B {$$ = $2;} %prec UMINUS
	| MINUS B {$$ = - $2;} %prec UMINUS
	;
Y	: B X {
		int i;
		for(i=0;i<$2.n;i++) {
			$$.vals[i+1] = $2.vals[i];
		}
		$$.n = $2.n+1;
		$$.vals[0] = $1;
	}
  	| {$$.n=0;}
  	;
X	: X COMMA B {
  		memcpy(&$$,&$1,
			sizeof($1.n)+$1.n*sizeof($1.vals[0]));
		$$.vals[$$.n++]=$3;}
	| {$$.n=0;}
	;

%%

int yyerror(char *s) {
	fprintf(stderr,"error: %s\n",s);
	return -1;
}
