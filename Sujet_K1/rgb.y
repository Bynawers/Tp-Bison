%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#if YYBISON
int yylex();
int yyerror();
#endif

#define YEL "\e[0;33m"
#define WHT "\e[0;37m"

#define LEFT 0
#define RIGHT 1

/* séparation de l'expression gauche de l'expression droite pour les futurs calculs */
int RGB_left[3];
int RGB_right[3];
/* output */
int RGB_result[3];

int nb_left = 0;
int nb_right = 0;

int push_rgb(int val, int direction);
int melange_rgb();

%}

%token MELANGE
%token RGB

%left RGB
%left MELANGE

%%
programme:
		instruction { print_result(); }
	;
instruction:
		expressionGauche MELANGE expressionDroite {	if(melange_rgb() == 0) { yyerror(YEL "Warning : Plus de 3 nombre" WHT); } }
	;
expressionGauche:
		expressionGauche expressionGauche { }
	| RGB { if(push_rgb($1, LEFT) == 0) { yyerror(YEL "Warning : Plus de 3 nombre à gauche\e[0;37m" WHT); } }
	;
expressionDroite:
		expressionDroite expressionDroite { }
	| RGB { if(push_rgb($1, RIGHT) == 0){ yyerror(YEL "Warning : Plus de 3 nombre à droite\e[0;37m" WHT); } }
	;
%%

/* fonction de d'affectation des valeurs rgb aux tableaux respectifs RGB_left / RGB_right */
int push_rgb(int val, int direction){

	if (val > 255 || val < 0) { yyerror(YEL "Warning : rgb doit être comprit entre [0;256[" WHT); }

	if (direction == LEFT){ 

		if (nb_left+1 > 3){ return 0; }

		RGB_left[nb_left] = val;
		nb_left++;
		return 1;
	}
	else if (direction == RIGHT){

		if (nb_right+1 > 3){ return 0; }

		RGB_right[nb_right] = val;
		nb_right++;
		return 1;
	}
	else { return 0; }
}

/* fonction de calcul du nouveau rgb */
int melange_rgb(){

	if (nb_left != 3 && nb_right != 3) { return 0; }
	
	for (int i = 0; i < 3; i++){
		RGB_result[i] = RGB_left[i] + RGB_right[i] - (( (float)RGB_left[i] * (float)RGB_right[i] ) / 256);
	}
	return 1;
}

void print_result(){
	for (int i = 0; i < 3; i++) { printf("%d ", RGB_result[i]); }
	printf("\n");
}