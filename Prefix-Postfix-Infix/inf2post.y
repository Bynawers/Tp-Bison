%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#if YYBISON
int yylex();
int yyerror();
#endif
char *concatener(char c, char *s1, char *s3);
%}

%union {
	char *chaine;
	}
%token <chaine> TEXTE
%token NOMBRE
%token PO
%token PF
%left '+' '-'
%left '*'

%type <chaine> instruction
%type <chaine> expression
%type <chaine> NOMBRE

%%
instruction:
		expression { printf("%s\n",$1); free($1); }
	;
expression:
		expression '+' expression { $$ = concatener ('+',$1,$3); }
	|	expression '-' expression { $$ = concatener ('-',$1,$3); }
	|	expression '*' expression { $$ = concatener ('*',$1,$3); }
	|	PO expression PF { $$ = $2; }
	| 	NOMBRE { $$ = $1; }
	;  
%%

char *concatener (char c, char *s1, char *s3) {
	char *s = malloc(4+strlen(s1)+strlen(s3)); // 4 pour les 2 espaces, l'opérateur et le '\0'
	if (!s) exit(2);
	sprintf(s,"%s %s %c",s1,s3,c); // Postfixe
//	sprintf(s,"%c %s %s",c,s1,s3); // Prefixe
	free(s1);
	free(s3);
	return s;
}

