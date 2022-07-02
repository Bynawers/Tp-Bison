
%{

#include "inf.tab.h"

%}


%%
[0-9]+ 	{ yylval = atoi(yytext); return NOMBRE; }
[ \t]	{ ; } /* Ignore les espaces */
"("		{ return PO; }
")"		{ return PF; }
\n		{ return 0; } /* fin de traitement par yylex */
. 		{ return yytext[0]; }
%%
