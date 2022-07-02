%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <ctype.h>

#if YYBISON
int yylex();
int yyerror();
#endif

#define YEL "\e[0;33m"
#define WHT "\e[0;37m"

/* séparation de l'expression gauche de l'expression droite pour les futurs calculs */
int RGB_transform[6];
/* output */
int RGB_result[3];

int nb_rgb = 0;

int is_a_color(char* name);
void add_color();
char* rgb_to_color();

%}

%union {
	char* chaine;
}

%token ADD
%token <chaine> RGB

%left RGB
%left ADD

%%
programme:
		instruction { printf("result : %s\n", rgb_to_color()); }
	;
instruction:
		expression ADD expression { add_color(); }
	;
expression:
		RGB {	if(is_a_color($1) == 0) { yyerror( "Warning : error syntax color\n"); } }
	;
%%

int is_a_color(char* name) {

	if (nb_rgb > 3) { return 0; }

	if (strcmp(name,"noir") == 0) {
		printf("noir\n");
		RGB_transform[nb_rgb] = 0; RGB_transform[nb_rgb+1] = 0; RGB_transform[nb_rgb+2] = 0; 
		nb_rgb = nb_rgb+3;
	}
	else if (strcmp(name,"rouge") == 0) { 
		printf("rouge\n"); 
		RGB_transform[nb_rgb] = 1; RGB_transform[nb_rgb+1] = 0; RGB_transform[nb_rgb+2] = 0; 
		nb_rgb = nb_rgb+3;
	}
	else if (strcmp(name,"vert") == 0) { 
		printf("vert\n"); 
		RGB_transform[nb_rgb] = 0; RGB_transform[nb_rgb+1] = 1; RGB_transform[nb_rgb+2] = 0;
		nb_rgb = nb_rgb+3;
	}
	else if (strcmp(name,"bleu") == 0) { 
		printf("bleu\n");
		RGB_transform[nb_rgb] = 0; RGB_transform[nb_rgb+1] = 0; RGB_transform[nb_rgb+2] = 1;
		nb_rgb = nb_rgb+3;
	}
	else if (strcmp(name,"jaune") == 0) { 
		printf("jaune\n");
		RGB_transform[nb_rgb] = 1; RGB_transform[nb_rgb+1] = 1; RGB_transform[nb_rgb+2] = 0;
		nb_rgb = nb_rgb+3;
	}
	else if (strcmp(name,"cyan") == 0) { 
		printf("cyan\n"); 
		RGB_transform[nb_rgb] = 0; RGB_transform[nb_rgb+1] = 1; RGB_transform[nb_rgb+2] = 1;
		nb_rgb = nb_rgb+3;
	}
	else if (strcmp(name,"magenta") == 0) { 
		printf("magenta\n"); 
		RGB_transform[nb_rgb] = 1; RGB_transform[nb_rgb+1] = 0; RGB_transform[nb_rgb+2] = 1;
		nb_rgb = nb_rgb+3;
	}
	else if (strcmp(name,"blanc") == 0) { 
		printf("blanc\n"); 
		RGB_transform[nb_rgb] = 1; RGB_transform[nb_rgb+1] = 1; RGB_transform[nb_rgb+2] = 1;
		nb_rgb = nb_rgb+3;
	}
	else { return 0; }

	return 1;
}

void add_color(){
	for (int i = 0; i < 3; i++) {
		RGB_result[i] = (RGB_transform[i] || RGB_transform[i+3]);
	}
}

char* rgb_to_color(){

	if (RGB_result[0] == 0 && RGB_result[1] == 0 && RGB_result[2] == 0) {
		return "noir";
	}
	else if (RGB_result[0] == 1 && RGB_result[1] == 0 && RGB_result[2] == 0) { 
		return "rouge";
	}
	else if (RGB_result[0] == 0 && RGB_result[1] == 1 && RGB_result[2] == 0) { 
		return "vert";
	}
	else if (RGB_result[0] == 0 && RGB_result[1] == 0 && RGB_result[2] == 1) { 
		return "bleu";
	}
	else if (RGB_result[0] == 1 && RGB_result[1] == 1 && RGB_result[2] == 0) { 
		return "jaune";
	}
	else if (RGB_result[0] == 0 && RGB_result[1] == 1 && RGB_result[2] == 1) { 
		return "cyan";
	}
	else if (RGB_result[0] == 1 && RGB_result[1] == 0 && RGB_result[2] == 1) { 
		return "magenta";
	}
	else if (RGB_result[0] == 1 && RGB_result[1] == 1 && RGB_result[2] == 1) { 
		return "blanc";
	}
	else { return 0; }
}