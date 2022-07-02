%{

#include "rgb.tab.h"

%}

%%
"add"   { return ADD; }
"noir" { yylval = 0; return RGB; }
"rouge" { yylval = 1; return RGB; }
"vert" { yylval = 2; return RGB; }
"bleu" { yylval = 3; return RGB; }
"jaune" { yylval = 4; return RGB; }
"magenta" { yylval = 5; return RGB; }
"cyan" { yylval = 6; return RGB; }
"blanc" { yylval = 7; return RGB; }
[ \t]	{;} /* Ignore les espaces */
\n		{ ; } /* fin de traitement par yylex */
. 		{return yytext[0];}
%%
