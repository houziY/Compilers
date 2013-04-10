%option yylineno

%{
	#include <stdio.h>
	#include <string.h>
	#include "syntax.tab.h"

	struct Node{
		int isToken;
		int line;
		int column;
		char type[16];
		char text[32];
		struct Node *firstChild;
		struct Node *nextSibling; 
	};

	void setNode(char *type,char *text);
%}

/*regular definitions */
delim		[ \t\n]
ws		{delim}+
letter		[A-Za-z]
digit		[0-9]
type		int|float
id		({letter}|_)({letter}|{digit}|_)*
int		[0]|[1-9][0-9]*
int8		[0][1-7][0-7]*
int16		[0][xX][1-9A-Fa-f][0-9A-Fa-f]*
float		[-+]?(([0-9]*\.[0-9]+)|([0-9]+\.[0-9]*))
relop		>|<|>=|<=|==|!=

%%
{ws}		{/*no action and no return*/}
struct		{setNode("STRUCT",yytext);return(STRUCT);}
return		{setNode("RETURN",yytext);return(RETURN);}
if		{setNode("IF",yytext);return(IF);}
else		{setNode("ELSE",yytext);return(ELSE);}
while		{setNode("WHILE",yytext);return(WHILE);}
{type}		{setNode("TYPE",yytext);return TYPE;}
{int}		{setNode("INT",yytext);return INT;}
{int8}		{setNode("INT",yytext);return INT;}
{int16}		{setNode("INT",yytext);return INT;}
{float}		{setNode("FLOAT",yytext);return FLOAT;}
{id}		{setNode("ID",yytext);return ID;}
{relop}		{setNode("RELOP",yytext);return RELOP;}
";"		{setNode("SEMI",yytext);return SEMI;}
","		{setNode("COMMA",yytext);return COMMA;}
"="		{setNode("ASSIGNOP",yytext);return ASSIGNOP;}
"+"		{setNode("PLUS",yytext);return PLUS;}
"-"		{setNode("MINUS",yytext);return MINUS;}
"*"		{setNode("STAR",yytext);return STAR;}
"/"		{setNode("DIV",yytext);return DIV;}
"&&"		{setNode("AND",yytext);return AND;}
"||"		{setNode("OR",yytext);return OR;}
"."		{setNode("DOT",yytext);return DOT;}
"!"		{setNode("NOT",yytext);return NOT;}
"("		{setNode("LP",yytext);return LP;}
")"		{setNode("RP",yytext);return RP;}
"["		{setNode("LB",yytext);return LB;}
"]"		{setNode("RB",yytext);return RB;}
"{"		{setNode("LC",yytext);return LC;}
"}"		{setNode("RC",yytext);return RC;}
.		{printf("Error type A at line %d: Mysterious character \'%s\'\n", yylineno, yytext);}

%%

void setNode(char *type,char *text){
	yylval.node = (struct Node *)malloc(sizeof(struct Node));
	yylval.node->isToken = 1;
	yylval.node->line = yylineno;
	strcpy(yylval.node->type, type);
	strcpy(yylval.node->text, text);
	yylval.node->firstChild = NULL;
	yylval.node->nextSibling = NULL;
}
