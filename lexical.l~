%{
	/*definitions of manifest constants		
	LT,LE,EQ,NE,GT,GE,RELOP,
	STRUCT,RETURN,IF,ELSE,WHILE,
	ID,FLOAT,TYPE,
	SEMI,COMMA,ASSIGNOP,
	PLUS,MINUS,STAR,DIV,AND,OR,DOT,NOT,
	LP,RP,LB,RB,LC,RC */
	
	#include "syntax.tab.h"	

%}

/*regular definitions */
delim		[ \t\n]
ws		{delim}+
letter		[A-Za-z]
digit		[0-9]
int		0|[1-9][0-9]*|0[1-7][0-7]*|0x[1-9A-Fa-f][0-9A-Fa-f]*
float		[0-9]+.[0-9]+
id		[A-Za-z_][A-Za-z0-9_]*
type		{int}|{float}

%%
{ws}		{/*no action and no return*/}
struct		{return(STRUCT);}
return		{return(RETURN);}
if		{return(IF);}
else		{return(ELSE);}
while		{return(WHILE);}
{int}		{
			printf("Integer value %d\n", atoi(yytext));
			REJECT;
		}
{float}		{	REJECT;

		}
{type}		{
		
		}
{id}		{
	
		}
";"		{return SEMI;}
","		{return COMMA;}
"="		{return ASSIGNOP;}
">"		{yylval = GT; return RELOP;}
"<"		{yylval = LT; return RELOP;}
">="		{yylval = GE; return RELOP;}
"<="		{yylval = LE; return RELOP;}
"=="		{yylval = EQ; return RELOP;}
"!="		{yylval = NE; return RELOP;}
"+"		{return PLUS;}
"-"		{return MINUS;}
"*"		{return STAR;}
"/"		{return DIV;}
"&&"		{return AND;}
"||"		{return OR;}
"."		{return DOT;}
"!"		{return NOT;}
"("		{return LP;}
")"		{return RP;}
"["		{return LB;}
"]"		{return RB;}
"{"		{return LC;}
"}"		{return RC;}
.		{printf("Error type A at line %d: Mysterious character \'%s\'\n", yylineno, yytext);}

%%
