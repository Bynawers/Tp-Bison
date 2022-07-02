%{

#include "rgb.tab.h"

%}

%%
[0-9][0-9]* 	{ yylval = atoi(yytext); return RGB;}
"melange"   {return MELANGE; }
[ \t]	{;} /* Ignore les espaces */
\n		{ ; } /* fin de traitement par yylex */
. 		{return yytext[0];}
%%
