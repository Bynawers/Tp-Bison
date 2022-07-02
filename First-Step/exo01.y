%{
#include <stdio.h>
#include <stdlib.h>
#if YYBISON
int yylex();
int yyerror();
#endif
%}

%token NOMBRE
%token SI
%token ALORS
%token SINON
%token FINSI
%left '-' '+' //token - associatif de gauche à droite
%left '*' '/' //prioritaire
%left '%'

%%
instruction:
		expression { printf("=%d\n",$1);}
	;
expression:
		expression '*' expression { $$ = $1 * $3; } |
		expression '/' expression { if ($3) $$ = $1 / $3; else yyerror("Division par 0"); } |
		expression '+' expression { $$ = $1 + $3; } |
		expression '-' expression { $$ = $1 - $3; } |
		'(' expression ')'{ $$ = $2; } |
		'|' expression '|'{ if($2 < 0) $$ = -$2; else $$ = $2; } |
		expression '%' expression { $$ = $1 % $3; } |
		SI expression ALORS expression SINON expression FINSI{ if($2) $$ = $4; else $$ = $6;} |
		NOMBRE { $$ = $1; }
	;  
%%
