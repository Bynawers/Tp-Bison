%{
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>

#if YYBISON
int yylex();
int yyerror();
#endif

const CONSTANTE = 0;

typedef struct table {
	int vc;     // 0 : constante(number)   1 : variable    2 : variableTempo
	int val;
	char *nom;
}table;

int NBVALCONST = 0;

table TDS[1024];

void traiter_constante(int val);
void traiter_variableagauche(char* nom);
void traiter_variableadroite(char* nom);

int chercher_constante(int val);
int ajouter_constante(int val);

int chercher_variable(char* nom);
int ajouter_variable(char* nom);

void afficher_TDS();

%}

%union {
	char *nom;
	int val;
}

%token <val> NUMBER
%token <nom> VARIABLE

%token AFFECT
%token PRINT
%token FDL

%token PO
%token PF

%token ADD
%token SOUST
%token MULT
%token DIV

%left ADD SOUST
%left MULT DIV
%left AFFECT

%type <val> expression

%%
programme:
		listeInstruction { printf("R 1\n"); afficher_TDS(); }
	;

listeInstruction:
		instruction listeInstruction { printf("R 2\n"); }
	| instruction { printf("R 3\n"); }
	;

instruction:
		affectation FDL { printf("R 4\n"); }
	| affichage FDL { printf("R 5\n"); }
	| FDL { printf("R 6\n"); }
	;
affichage:
		PRINT VARIABLE { printf("R 7\n"); }
	;
affectation:
		variableGauche AFFECT expression { printf("R 8\n"); }
	;
expression:
		expression ADD expression { printf("R 9\n"); }
	| expression SOUST expression { printf("R 10\n"); }
	| expression MULT expression { printf("R 11\n"); }
	| expression DIV expression { printf("R 12\n"); }
	| PO expression PF { printf("R 13\n"); }
	| NUMBER { printf("R 14\n"); traiter_constante($1); }
	| VARIABLE { printf("R 15\n"); traiter_variableadroite($1); }
	;
variableGauche:
	VARIABLE { printf("R 16\n"); traiter_variableagauche($1); }
	;
%%

void traiter_constante(int val){

	if (chercher_constante(val) == -1){
		ajouter_constante(val);
	}
}

void traiter_variableagauche(char* nom){

	if (chercher_variable(nom) == -1){
		ajouter_variable(nom);
	}

}

void traiter_variableadroite(char* nom){

}

int chercher_constante(int val){

	int i = 0;

	while (i < NBVALCONST){

		if ((TDS[i].vc == CONSTANTE) && (TDS[i].val == val)) {
			return i;
		} 
		i++;
	}

	return -1;
}

int ajouter_constante(int val){

	TDS[NBVALCONST].vc = 0; 
	TDS[NBVALCONST].val = val;
	NBVALCONST++;
	return NBVALCONST-1;
}

int chercher_variable(char* nom){

	int i = 0;

	while (i < NBVALCONST){

		if (TDS[i].vc == 1) {
			if (strcmp(TDS[i].nom, nom) == 0) { return i; }
		} 
		i++;
	}

	return -1;
}

int ajouter_variable(char* nom){

	TDS[NBVALCONST].vc = 1; 
	TDS[NBVALCONST].nom = nom;
	NBVALCONST++;
	return NBVALCONST-1;
}

void afficher_TDS(){

	int i = 0;

	printf("Table des symboles :\n");

	while (i < NBVALCONST){

		if (TDS[i].vc == 0) {
			printf("Table[%d] = %d\n",i, TDS[i].val);
		} 
		else { 
			printf("Table[%d] = %s\n",i, TDS[i].nom);
		}
		i++;
	}
}