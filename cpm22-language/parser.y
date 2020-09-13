%{

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define MAX 255

int computeSymbolIndex(char token);

float symbols[MAX];
float symbolValNum(char symbol);
void  updateSymbolValNum(char symbol, float val);

char  symbolsChar[MAX];
char  symbolValChar(char symbol);
void  updateSymbolValChar(char symbol, char val);

char  symbolsStr[MAX][MAX];
char  *symbolValStr(char *symbol);
void  updateSymbolValStr(char symbol, char *val);

void  updateSymbolValConditional(int condition, char symbol, int val);
void  whileLoop(char id, int token, int condition, int operation, int exp);
int   switchOperation(char a, int operation, int b);

int   EqualStatement(char symbol, int val);
int   NotEqualStatement(char symbol, int val);
int   LesserStatement(char symbol, int val);
int   LesserEqualStatement(char symbol, int val);
int   GreaterStatement(char symbol, int val);
int   GreaterEqualStatement(char symbol, int val);

void  yyerror (char *s);

%}

%union
{
  int   intNum;
  float floatNum;
  char  id;
  char* str;
}

%start  line

%token  tokenIs
%token  tokenInt tokenFloat tokenChar tokenStr
%token  tokenBegin tokenEnd
%token  tokenEqual tokenNotEqual tokenLesser tokenLesserEqual tokenGreater tokenGreaterEqual
%token  tokenIf tokenWhile
%token  tokenAND tokenOR
%token  tokenOutputStr tokenOutputChar tokenOutputNum
%token  tokenExit

%token  <intNum>    tokenIntNumber
%token  <floatNum>  tokenFloatNumber
%token  <id>        tokenIdentifier
%token  <str>       tokenWord

%right	'=' UMINUS
%left 	tokenEqual tokenNotEqual tokenLesser tokenLesserEqual tokenGreater tokenGreaterEqual tokenAND tokenOR '+''-' '*''/' '!' '<' '>' '%'

%type   <intNum>  line expNum expChar expStr term
%type   <id>      assignment
%type   <intNum>  conditional
%type   <intNum>  conditions
%type   <intNum>  operation
%type   <intNum>  relational


%%


line    :       assignment ';'		        	      {	printf("\t\tASSIGNMENT\n\n"); 		}		|
                conditional ';'             	    { printf("\t\tCONDITIONAL\n\n"); 		}		|
                whileLoop ';'               	    {	printf("\t\tREPETITION \n\n");	  }		|
                tokenExit ';'            	        { exit(EXIT_SUCCESS); 				      }		|
                tokenOutputNum expNum ';'       	{ printf("\t\tExit: %d\n\n", $2);   }		|
                tokenOutputChar expChar ';'   	  { printf("\t\tExit: %c\n\n", $2); 	}		|
                tokenOutputStr expStr ';'   	    { printf("\t\tExit: %s\n\n", $2); 	}		|
                line assignment ';'	        	    { printf("\t\tASSIGNMENT\n\n"); 		}		|
                line whileLoop ';'              	{ printf("\t\tREPETITION\n\n"); 	  }   |
                line conditional ';'        	    { printf("\t\tCONDITIONAL\n\n"); 		}		|
                line tokenOutputNum expNum ';'    { printf("\t\tExit: %d\n\n", $3);   }		|
                line tokenOutputChar expChar ';'  { printf("\t\tExit: %c\n\n", $3); 	}		|
                line tokenOutputStr expStr ';'    { printf("\t\tExit: %s\n\n", $3); 	}		|
                line tokenExit '\n'      	        { exit(EXIT_SUCCESS); 				      }		|
                line tokenExit ';'       	        {	exit(EXIT_SUCCESS); 				      }
        ;

assignment : 	tokenInt tokenIdentifier tokenIs expNum               { updateSymbolValNum($2,$4); 	 }   |
				      tokenFloat tokenIdentifier tokenIs expNum 		        { updateSymbolValNum($2,$4);   }	 |
				      tokenChar tokenIdentifier tokenIs tokenIdentifier     { updateSymbolValChar($2,$4);  }	 |
				      tokenStr tokenIdentifier tokenIs tokenWord 		        { updateSymbolValStr($2,$4); 	 }
           ;

expNum	:   tokenIntNumber      { $$ = $1;				        }		|
            tokenFloatNumber    { $$ = $1;				        } 	|
       	    expNum '+' term     {	$$ = $1 + $3;			      }   |
       	    expNum '-' term     {	$$ = $1 - $3;			      }   |
            expNum '*' term			{	$$ = $1 * $3;			      }   |
            expNum '/' term			{	$$ = $1 / $3;			      }   |
       	    expNum '^' term     {	$$ = pow ( $1, $3 );	  }   |
       	    expNum '%' term     {	$$ = $1 % $3;			      }		|
       	    tokenIdentifier     {	$$ = symbolValNum($1);	}
       	;

expChar	:   tokenIdentifier     {	$$ = symbolValChar($1);	}
       	;

expStr	:   tokenIdentifier     {	$$ = symbolValStr($1);	}
       	;

term   	:   tokenIntNumber          {	$$ = $1;				        }		|
            tokenFloatNumber        {	$$ = $1;				        }		|
			      tokenIdentifier         {	$$ = symbolValNum($1);	}
        ;

conditional :	tokenIf '(' conditions ')' tokenBegin tokenIdentifier tokenIs expNum ';' tokenEnd  { updateSymbolValConditional($3,$6,$8); }
            ;

whileLoop   : tokenWhile '(' tokenIdentifier relational expNum ')' tokenBegin tokenIdentifier tokenIs tokenIdentifier operation term ';' tokenEnd {  whileLoop($3,$4,$5,$11,$12);  }
            ;

relational :        tokenEqual            {$$ = 1;}     |
                    tokenLesserEqual      {$$ = 2;}     |
                    tokenGreaterEqual     {$$ = 3;}     |
                    tokenNotEqual         {$$ = 4;}     |
                    tokenGreater          {$$ = 5;}     |
                    tokenLesser           {$$ = 6;}
                ;

operation        :    '+'  {$$ = 1;}    |
                      '-'  {$$ = 2;}    |
                      '*'  {$$ = 3;}    |
                      '/'  {$$ = 4;}    |
                      '^'  {$$ = 5;}
                ;

conditions  :   tokenIdentifier tokenEqual expNum             {$$ = EqualStatement($1,$3);}           |
       	        tokenIdentifier tokenLesserEqual expNum       {$$ = LesserEqualStatement($1,$3);}     |
       	        tokenIdentifier tokenGreaterEqual expNum      {$$ = GreaterEqualStatement($1,$3);}    |
       	        tokenIdentifier tokenNotEqual expNum          {$$ = NotEqualStatement($1,$3);}        |
                tokenIdentifier tokenGreater expNum           {$$ = NotEqualStatement($1,$3);}        |
                tokenIdentifier tokenLesser expNum            {$$ = NotEqualStatement($1,$3);}
            ;


%%


int computeSymbolIndex(char token)
{
	int idx = -1;
	if(islower(token)) {
		idx = token - 'a' + 26;
	} else if(isupper(token)) {
		idx = token - 'A';
	}
	return idx;
}

float symbolValNum(char symbol)
{
	int symbolIdx = computeSymbolIndex(symbol);
	return symbols[symbolIdx];
}

char symbolValChar(char symbol)
{
	int symbolIdx = computeSymbolIndex(symbol);
	return symbolsChar[symbolIdx];
}

char* symbolValStr(char *symbol)
{
	int symbolIdx = computeSymbolIndex(symbol);
	return symbolsStr[symbolIdx];
}

void updateSymbolValNum(char symbol, float val)
{
	int symbolIdx = computeSymbolIndex(symbol);
	symbols[symbolIdx] = val;
}

void updateSymbolValChar(char symbol, char val)
{
	int symbolIdx = computeSymbolIndex(symbol);
	symbolsChar[symbolIdx] = val;
}

void updateSymbolValStr(char symbol, char *val)
{
	int aux, symbolIdx = computeSymbolIndex(symbol);
	for(aux=0; aux<MAX; aux++) { symbolsStr[symbolIdx][aux] = val[aux]; }
}

void updateSymbolValConditional(int condition, char symbol, int val)
{
    if(condition==1)
    {
        int symbolIdx = computeSymbolIndex(symbol);
        symbols[symbolIdx] = val;
    }
    else
    {
        printf("FALSE\n\n");
    }
}

void whileLoop(char id, int token, int condition, int operation, int exp)
{
    int idvalue = symbolValNum(id);
    int aux;
    switch(token)
    {
        //==
        case 1 :
            while(idvalue == condition)
            {
                aux = switchOperation(id, operation, exp);
                updateSymbolValNum(id, aux);
                idvalue = symbolValNum(id);
            }
        //<=
        case 2 :
            while(idvalue <= condition)
            {
                aux = switchOperation(id, operation, exp);
                updateSymbolValNum(id, aux);
                idvalue = symbolValNum(id);

            }
        //>=
        case 3 :
            while(idvalue >= condition)
            {
                aux = switchOperation(id, operation, exp);
                updateSymbolValNum(id, aux);
                idvalue = symbolValNum(id);
            }
        //!=
        case 4 :
            while(idvalue != condition)
            {
                aux = switchOperation(id, operation, exp);
                updateSymbolValNum(id, aux);
                idvalue = symbolValNum(id);
            }
        //>
        case 5 :
            while(idvalue > condition)
            {
                aux = switchOperation(id, operation, exp);
                updateSymbolValNum(id, aux);
                idvalue = symbolValNum(id);
            }
        //<
        case 6 :
            while(idvalue < condition)
            {
                aux = switchOperation(id, operation, exp);
                updateSymbolValNum(id, aux);
                idvalue = symbolValNum(id);
            }
    }
}

int switchOperation(char a, int operation, int b)
{
    int idvalue = symbolValNum(a);
    switch(operation){
        //+
        case 1 :  return idvalue + b;
        //-
        case 2 :  return idvalue - b;
        //*
        case 3 :  return idvalue * b;
        ///
        case 4 :  return idvalue / b;

        case 5 : return pow(idvalue,b);
    }
}

int EqualStatement(char symbol, int val)
{
    int symbolIdx = symbolValNum(symbol);
    if(symbolIdx==val){
        return 1;
    }
    else
    {
        return 0;
    }
}

int NotEqualStatement(char symbol, int val)
{
    int symbolIdx = symbolValNum(symbol);
    if(symbolIdx!=val){
        return 1;
    }
    else
    {
        return 0;
    }
}

int LesserStatement(char symbol, int val)
{
    int symbolIdx = symbolValNum(symbol);
    if(symbolIdx<val){
        return 1;
    }
    else
    {
        return 0;
    }
}

int LesserEqualStatement(char symbol, int val)
{
    int symbolIdx = symbolValNum(symbol);
    if(symbolIdx<=val){
        return 1;
    }
    else
    {
        return 0;
    }
}

int GreaterStatement(char symbol, int val)
{
    int symbolIdx = symbolValNum(symbol);
    if(symbolIdx>val){
        return 1;
    }
    else
    {
        return 0;
    }
}

int GreaterEqualStatement(char symbol, int val)
{
    int symbolIdx = symbolValNum(symbol);
    if(symbolIdx>=val){
        return 1;
    }
    else
    {
        return 0;
    }
}

void yyerror (char *s)
{
    fprintf (stderr, "%s\n", s);
}

int main (void)
{
	int i, j;

	for(i=0; i<MAX; i++)
  {
		symbols[i] = 0;
		symbolsChar[i] = 0;
		for(j=0; j<MAX; j++) symbolsStr[i][j] = 0;
	}

  printf("\nCPM 22 LANGUAGE\n\n");

	return yyparse();
}
