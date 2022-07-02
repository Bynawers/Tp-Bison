
%{

#include "moncompilo.tab.h"

%}


%%
[0-9]+ 	 { yylval.val = atoi(yytext); return NOMBRE;}
"print" { return PRINT; }
[a-zA-Z][a-zA-Z0-9]*	{ yylval.nom = strdup(yytext); return NOMVAR; }
"("		{ return PO; }
")"		{ return PF; }
"+"		{ return PLUS; }
"-"		{ return MOINS; }
"*"		{ return MULT; }
"/"		{ return DIV; }
":="	{ return AFFECT; }
[ \t]	{;} /* Ignore les espaces */
\n		{ return FDL; } 
. 		{ return yytext[0];}
%%
