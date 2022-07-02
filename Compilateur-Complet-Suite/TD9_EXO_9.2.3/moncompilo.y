%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#if YYBISON
int yylex();
int yyerror();
#endif

#define CONSTANTE 11
#define VARIABLE 12
#define VARTMP 13
// Table des symboles contenant les noms des variables ou les valeurs
// des constantes
#define NBMAXSYMBOLES 1024
int NBVARCONST = 0;
struct varconst {	int vc; // vaut VARIABLE VARTMP ou CONSTANTE
					int val; // Si c'est une constante
					char *nom; // Si c'est une constante
				};
struct varconst TDS[NBMAXSYMBOLES];

// Une instruction contient le texte de l'instruction et un pointeur
// vers l'instruction suivante
struct une_instruction {	char *instruction; 
							struct une_instruction *suiv; };

// Un bout de code contient plusieurs instructions avec
// un pointeur vers la première instruction
// un pointeur vers la dernière instruction
// le numéro de la variable temporaire que calcule ce bout de code
struct boutdecode {		struct une_instruction* instruction_deb; 
						struct une_instruction* instruction_fin;
						int tmpvar; };

// fonctions qui concatène des bouts de code 
struct boutdecode *concatener2(struct boutdecode *b1, struct boutdecode *b2);
struct boutdecode *concatener3(char op, struct boutdecode *b1, struct boutdecode *b2);

// fonction qui donne le code pour mettre la constante dans une variable
struct boutdecode *traiter_constante (int val);
struct boutdecode *traiter_variableadroite(char *nom);
struct boutdecode *traiter_variableagauche(char *nom, struct boutdecode *D);
struct boutdecode *traiter_affichage(char *nom);

void ecrire_code(struct boutdecode* b);
%}


// Tous les types possibles pour les terminaux et non terminaux
%union {
	struct boutdecode *codetmp;
	char *nom;
	int val;
	}

// LES TOKENS (les terminaux)
// Les tokens typés
%token <val> NOMBRE
%token <nom> NOMVAR

// Les tokens avec priorité
%left PLUS MOINS
%left MULT DIV
%left AFFECT

// Les tokens sans type ni priorité
%token PRINT
%token PO
%token PF
%token FDL

// Le typage des non-terminaux
%type <codetmp> instruction
%type <codetmp> instructiondebase
%type <codetmp> affectation
%type <codetmp> affichage
%type <codetmp> expression
%type <nom> variable_a_gauche
%type <nom> variable_a_droite

%%
programme: 
		instruction{ ecrire_code($1); }
	;
instruction:
		instructiondebase instruction{ $$ = concatener2($1, $2); }
	|	instructiondebase { $$ = $1;}
	;
instructiondebase:
		affectation FDL { $$ = $1; }
	|	affichage FDL { $$ = $1; }
	| 	FDL { $$ = NULL; }
	;
affichage:
		PRINT NOMVAR { $$ = traiter_affichage($2); }
	;
affectation: variable_a_gauche AFFECT expression { 
				$$ = traiter_variableagauche($1, $3);
				 }
	;
expression:
		expression PLUS expression { $$ = concatener3('+', $1, $3); }
	|	expression MOINS expression { $$ = concatener3('-', $1, $3); }
	|	expression MULT expression { $$ = concatener3('*', $1, $3);  }
	|	expression DIV expression { $$ = concatener3('/', $1, $3);  }
	|	PO expression PF { $$ = $2; }
	| 	NOMBRE { $$ = traiter_constante ($1);}
	| 	variable_a_droite { $$ = traiter_variableadroite($1); }
	; 
variable_a_gauche: NOMVAR { $$ = $1;}
	;
variable_a_droite: NOMVAR { $$ = $1;}
	;
%%

// ####
// 1. Gestion de la table des symboles
// ####

	// ####
	// 1.1 Gestion des CONSTANTES
	//
	// Il y a 3 fonctions :
	//  - chercher_constante qui vérifie si la constante est déjà stockée dans la TDS
	//  - ajouter_constate qui ajoute une nouvelle constante dans la TDS
	//  - traiter_constante qui est appelée par les règles de la grammaire
	//    quand on a trouvé une constante 
	// ####

// Cherche la constante de valeur val dans la TDS
// renvoie l'indice du tableau TDS si elle existe et -1 sinon
int chercher_constante (int val) {
	int i = 0;

	while (i < NBVARCONST){
		if ((TDS[i].vc == CONSTANTE) && (TDS[i].val == val)) {
			return i;
		}
		i++;
	}
	return -1;
}

// Ajoute la constante de valeur VAL dans la TDS
// renvoie l'indice du tableau TDS qui la contient
int ajouter_constante (int VAL) {
	TDS[NBVARCONST].vc = CONSTANTE; 
	TDS[NBVARCONST].val = VAL;
	NBVARCONST++;
	return NBVARCONST-1;
}

// Création d'une instruction pour une constante
struct boutdecode * traiter_constante (int val) {
	int ret = chercher_constante(val);
	if (ret==-1) ret = ajouter_constante(val);
	struct boutdecode *b = malloc(sizeof(struct boutdecode));
	struct une_instruction *I;
	I = malloc(sizeof(struct une_instruction));
	I->instruction = malloc(32*sizeof(char));
	sprintf(I->instruction,"V[%d] =  %d ;\n",ret,val);
	I->suiv = NULL;
	b->instruction_deb = I;
	b->instruction_fin = I;
	b->tmpvar = ret;
	return b;
}

	// ####
	// 1.2 Gestion des VARIABLES
	//
	// Il y a 4 fonctions :
	//  - chercher_variable qui vérifie si la variable est déjà stockée dans la TDS
	//  - ajouter_variable qui ajoute une nouvelle variable dans la TDS
	//  - traiter_variableadroite qui est appelée par les règles de la grammaire
	//    quand on a trouvé une variable à droite d'une affectation 
	//  - traiter_variableagauche qui est appelée par les règles de la grammaire
	//    quand on a trouvé une variable à gauche d'une affectation 
	// ####


// Cherche la variable de nom NOM dans la TDS
// renvoie l'indice du tableau TDS si elle existe et -1 sinon
int chercher_variable (char *NOM) {
	int i = 0;
	while (i<NBVARCONST) {
		if ((TDS[i].vc == VARIABLE) && strcmp(NOM,TDS[i].nom)==0) return i;
			i++;
		}
	return -1;
}

// Ajoute la variable de nom NOM dans la TDS
// renvoie l'indice du tableau TDS qui la contient
int ajouter_variable (char *NOM) {
	TDS[NBVARCONST].vc = VARIABLE; 
	TDS[NBVARCONST].nom = strdup(NOM);
	NBVARCONST++;
	return NBVARCONST-1;
}


// Crée un boutdecode avec instruction vide et le bon numéro de la variable temporaire
// La variable doit exister car elle est à droite dans une affectation
struct boutdecode *traiter_variableadroite(char *nom) {
	int ret = chercher_variable(nom);
	if (ret==-1) {
				fprintf(stderr,"ERREUR : variable '%s' non initialisée\n",nom);
				exit(1);
				}
	struct boutdecode *b;
	I
	b = malloc(sizeof(struct boutdecode));
	I->suiv = NULL;
	b->instruction_deb = I;
	b->instruction_fin = I;
	b->tmpvar = ret;
	return b;
}

// Crée un boutdecode avec instruction vide et le bon numéro de la variable temporaire
// Si la variable n'existe pas elle est créée
struct boutdecode *traiter_variableagauche(char *nom, struct boutdecode *D) {
	int ret = chercher_variable(nom);
	if (ret==-1) ret = ajouter_variable(nom);
	return NULL;
}



// ####
// 2. Gestion des compositions d'instructions
// ####




// Création d'une instruction
// qui est T[v0] = T[v1] op T[v3];
struct une_instruction *creer_instruction (int v0, int v1, char op, int v3) {
	struct une_instruction *I;
	I = malloc(sizeof(struct une_instruction));
	I->instruction = malloc(32*sizeof(char));
	sprintf(I->instruction,"V[%d] = V[%d] %c V[%d] ;\n",v0,v1,op,v3);
	I->suiv = NULL;
	return I;
}


// Concatène les bouts de de code b1 et b2 et la nouvelle instruction
struct boutdecode *concatener2 (struct boutdecode *b1, struct boutdecode *b2) {
	if (b1 == NULL) return b2;
	if (b2 == NULL) return b1;
	b1->instruction_fin->suiv = b2->instruction_deb;
	b1->instruction_fin = b2->instruction_fin;
	b1->tmpvar = b2->tmpvar;
	return NULL;
}

// Concatène les bouts de de code b1 et b2 et la nouvelle instruction
struct boutdecode *concatener3 (char op, struct boutdecode *b1, struct boutdecode *b2) {
	int new_var = NBVARCONST;
	TDS[new_var].vc = VARTMP;
	TDS[new_var].nom = NULL;
	NBVARCONST++;
	// Création de la nouvelle instruction
	struct une_instruction *I = creer_instruction(new_var, b1->tmpvar, op, b2->tmpvar);
	// Concaténation des intructions: celles de b1, puis celles de b2, puis la nouvelle
	// on met le tout dans b1
	b1->instruction_fin->suiv = b2->instruction_deb;
	b2->instruction_fin->suiv == I;
	b1->instruction_fin = b2->instruction_fin;
	b1->tmpvar = new_var;
	return b1;
}

struct boutdecode *traiter_affichage(char *nom){
	int ret = chercher_variable(nom);
	if (ret==-1) { fprintf(stderr,"variable \"%s\" non définie\n",nom); exit(3); } 
	return NULL;
}


// ####
// 3. Production du code en C
// ####

void ecrire_TDS(FILE *F) {
fprintf(F,"/*\n");
fprintf(F,"Table des Symboles\n");
int i;
for (i=0; i< NBVARCONST; i++) {
	fprintf(F,"\tV[%d] : ",i);
	if (TDS[i].vc == CONSTANTE) fprintf(F," CONST %d\n",TDS[i].val);
	if (TDS[i].vc == VARIABLE)  fprintf(F," VAR  \"%s\"\n",TDS[i].nom);
	if (TDS[i].vc == VARTMP)    fprintf(F," VAR  TEMP\n");
}
fprintf(F,"*/\n\n");

}

void ecrire_code(struct boutdecode* b){
	FILE *F = fopen("output.c","w");
	fprintf(F,"#include <stdio.h>\n");
	fprintf(F,"#include <stdlib.h>\n");
	fprintf(F,"\n");
	ecrire_TDS(F);
	fprintf(F,"int main () {\n");
	fprintf(F,"\tint V[%d];\n",NBVARCONST);
//	struct une_instruction* I = b->instruction_deb;
//	while (I) {
//		fprintf(F,"\t%s",I->instruction);
//		I = I->suiv;
//	}
	fprintf(F,"\treturn 0;\n");
	fprintf(F,"}\n");
}

