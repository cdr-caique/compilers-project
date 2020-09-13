%{

#include "parser.tab.h"

%}

%%

"int"						          {return tokenInt;}
"float"					          {return tokenFloat;}
"char"					          {return tokenChar;}
"str"						          {return tokenStr;}

"is"						          {return tokenIs;}

"if"    				          {return tokenIf;}
"while" 				          {return tokenWhile;}

"nout"                    {return tokenOutputNum;}
"cout"					          {return tokenOutputChar;}
"sout"					          {return tokenOutputStr;}

"begin" 				          {return tokenBegin;}
"end" 					          {return tokenEnd;}

">"    					          {return tokenGreater;}
">="    				          {return tokenGreaterEqual;}
"<"    					          {return tokenLesser;}
"<="    				          {return tokenLesserEqual;}
"="    					          {return tokenEqual;}
"~="    				          {return tokenNotEqual;}

"or"    				          {return tokenOR;}
"and"    				          {return tokenAND;}

"exit"                 		{return tokenExit;}

[a-zA-Z]	               	{yylval.id = yytext[0]; return tokenIdentifier;}
[a-zA-Z][_a-zA-Z0-9]*     {yylval.str = strdup(yytext); return tokenWord;}
[0-9]+                    {yylval.intNum = atoi(yytext); return tokenIntNumber;}
[0-9]*\.[0-9]+"f"?        {yylval.floatNum = atof(yytext); return tokenFloatNumber;}

[ \t]                		  ;
[ \n]                		  ;
[-+=(){};*/^%]            {return yytext[0];}

.                      		{ECHO; yyerror ("Token nao reconhecido");}

%%

int yywrap (void)
{
  return 1;
}
