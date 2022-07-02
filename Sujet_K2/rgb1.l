%{

#include "rgb.tab.h"

%}

%%
"add"   { return ADD; }
[a-zA-Z][a-zA-Z]* 	{ yylval.chaine = strdup(yytext); return RGB;}
[ \t]	{;} /* Ignore les espaces */
\n		{ ; } /* fin de traitement par yylex */
. 		{return yytext[0];}
%%
