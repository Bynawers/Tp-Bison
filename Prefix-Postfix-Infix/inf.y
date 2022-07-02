%{
#include <stdio.h>
#include <stdlib.h>
#if YYBISON
int yylex();
int yyerror();
#endif
%}

%token NOMBRE
%token PO
%token PF
%left '+' '-'
%left '*'

%%
instruction:
		expression { printf("= %d\n",$1); }
	;
expression:
		expression '+' expression { $$ = $1 + $3; }
	|	expression '-' expression { $$ = $1 - $3; }
	|	expression '*' expression { $$ = $1 * $3; }
	|	PO expression PF { $$ = $2; }
	| 	NOMBRE { $$ = $1; }
	;  
%%

