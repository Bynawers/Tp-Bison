%{

#include "bool.tab.h"

%}


%%
[0-1] 	{ yylval.val = atoi(yytext); return BINARY; }
[ \t]	{ ; } /* Ignore les espaces */
"=>" { return IMPLIQUE; }
"<=>" { return EQUIVALENT; }
"NON" { return NOT; }
"("		{ return PO; }
")"		{ return PF; }
\n		{ return 0; } /* fin de traitement par yylex */
. 		{ return yytext[0]; }
%%
