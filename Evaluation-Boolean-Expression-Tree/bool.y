%{
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

#if YYBISON
int yylex();
int yyerror();
#endif
int getBinary(int b1, int b2, char operator);
struct Tree newTree(int value, bool isOperator);

struct Tree t;

struct Tree {
	struct Tree *left;
	struct Tree *right;
	int value;
	bool isOperator;
};
%}

%union { 
	struct Tree tree;
	int val;
}

%token <val> BINARY
%token IMPLIQUE
%token EQUIVALENT
%token NOT
%token PO
%token PF

%left IMPLIQUE EQUIVALENT
%left '+' '.'
%left NOT

%type <tree> expression
%type <tree> instruction

%%
instruction:
		expression { printf("Result\n"); }
	;
expression:
		expression '+' expression { $$ = $1; }
	|	expression '.' expression { $$ = $1; }
	| expression IMPLIQUE expression { $$ = $1; }
	| expression EQUIVALENT expression { $$ = $1; }
	| NOT expression { $$ = $2; }
	|	PO expression PF { $$ = $2; }
	| 	BINARY { $$ = newTree($1, false); }
	;  
%%

struct Tree newTree(int value, bool isOperator){

	struct Tree newTree;

	newTree.value = value;
	newTree.isOperator = isOperator;
	newTree.left = NULL;
	newTree.right = NULL;

	return newTree;
}