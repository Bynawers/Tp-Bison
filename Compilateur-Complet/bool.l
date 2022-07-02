%{

#include "bool.tab.h"

%}


%%
[0-9]+ 	             { yylval.val = atoi(yytext); return NUMBER; }
"print" { return PRINT; }
[a-zA-Z][a-zA-Z0-9]* { yylval.nom = strdup(yytext); return VARIABLE; }
[ \t]	               { ; } /* Ignore les espaces */
":="    { return AFFECT; }
"("		  { return PO; }
")"		  { return PF; }
"+"     { return ADD; }
"-"     { return SOUST; }
"/"     { return DIV; }
"*"     { return MULT; }
\n		  { return FDL; } /* fin de traitement par yylex */
. 		  { return yytext[0]; }
%%
