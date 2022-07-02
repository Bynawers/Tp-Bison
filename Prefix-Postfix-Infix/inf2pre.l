
%{

#include "inf2post.tab.h"

%}


%%
[0-9]+ 	{ 
		yylval.chaine = strdup(yytext);
		if (!yylval.chaine) exit(22);
		return NOMBRE; }
[ \t]	{ ; } /* Ignore les espaces */
"("		{ return PO; }
")"		{ return PF; }
\n		{ return 0; } /* fin de traitement par yylex */
. 		{ return yytext[0]; }
%%
