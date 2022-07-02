
%{

#include "exo01.tab.h"

%}


%%
[0-9]+ 	{ yylval = atoi(yytext); return NOMBRE;}
"alors" {return ALORS;}
"si" {return SI;}
"sinon" {return SINON; }
"finsi" {return FINSI; }
[ \t]	{;} /* Ignore les espaces */
\n		{ return 0;} /* fin de traitement par yylex */
. 		{return yytext[0];}
%%
