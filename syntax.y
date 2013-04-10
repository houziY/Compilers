%{
	#include<stdio.h>
	#include<stdlib.h>
	#include<string.h>
	#include<stdarg.h>
	#include "lex.yy.c"
	
	struct Node *root;
	struct Node *addToTree(char *type,int num,...);

	void printTree(struct Node *p,int depth);
	int myatoi(char* ch);

	int isError;
	
%}

/*declared types*/
%union{struct Node *node;}
/*declared tokens*/
%token <node>INT FLOAT TYPE ID SEMI COMMA
%right <node>ASSIGNOP NOT
%left  <node>PLUS MINUS STAR DIV RELOP AND OR 
%left  <node>DOT LP RP LB RB LC RC
%nonassoc <node>STRUCT RETURN IF ELSE WHILE
/*declared non-terminals*/
%type <node>Program ExtDefList ExtDef ExtDecList
%type <node>Specifier StructSpecifier OptTag Tag
%type <node>VarDec FunDec VarList ParamDec
%type <node>CompSt StmtList Stmt
%type <node>DefList Def DecList Dec
%type <node>Exp Args


%%

Program		:	ExtDefList			{$$=addToTree("Program",1,$1);root=$$;}
		;
ExtDefList	:	ExtDef ExtDefList		{$$=addToTree("ExtDefList",2,$1,$2);}
		|	/*empty*/			{$$=NULL;}
		;
ExtDef		:	Specifier ExtDecList SEMI	{$$=addToTree("ExtDef",3,$1,$2,$3);}
		|	Specifier SEMI			{$$=addToTree("ExtDef",2,$1,$2);}
		|	Specifier FunDec CompSt		{$$=addToTree("ExtDef",3,$1,$2,$3);}
		|	error SEMI			{isError = 1;}
		;
ExtDecList	:	VarDec				{$$=addToTree("ExtDecList",1,$1);}
		|	VarDec COMMA ExtDecList		{$$=addToTree("ExtDecList",3,$1,$2,$3);}
		;
Specifier	:	TYPE				{$$=addToTree("Specifier",1,$1);}
		|	StructSpecifier			{$$=addToTree("Specifier",1,$1);}		
		;
StructSpecifier	:	STRUCT OptTag LC DefList RC	{$$=addToTree("StructSpecifier",5,$1,$2,$3,$4,$5);}
		|	STRUCT Tag			{$$=addToTree("StructSpecifier",2,$1,$2);}
		;
OptTag		:	ID				{$$=addToTree("OptTag",1,$1);}
		|	/*empty*/			{$$=NULL;}
		;
Tag		:	ID				{$$=addToTree("Tag",1,$1);}
		;
VarDec		:	ID				{$$=addToTree("VarDec",1,$1);}
		|	VarDec LB INT RB		{$$=addToTree("VarDec",4,$1,$2,$3,$4);}
		;
FunDec		:	ID LP VarList RP		{$$=addToTree("FunDec",4,$1,$2,$3,$4);}
		|	ID LP RP			{$$=addToTree("FunDec",3,$1,$2,$3);}
		|	error RP			{isError = 1;}
		;
VarList		:	ParamDec COMMA VarList		{$$=addToTree("VarList",3,$1,$2,$3);}
		|	ParamDec			{$$=addToTree("VarList",1,$1);}
		;
ParamDec	:	Specifier VarDec		{$$=addToTree("ParamDec",2,$1,$2);}
		|	error COMMA			{isError = 1;} 
		|	error RB			{isError = 1;} 
		;
CompSt		:	LC DefList StmtList RC		{$$=addToTree("CompSt",4,$1,$2,$3,$4);}
		|	error RC			{isError = 1;}
		;
StmtList	:	Stmt StmtList			{$$=addToTree("StmtList",2,$1,$2);}
		|	/*empty*/			{$$=NULL;}
		;
Stmt		:	Exp SEMI			{$$=addToTree("Stmt",2,$1,$2);}
		|	CompSt				{$$=addToTree("Stmt",1,$1);}
		|	RETURN Exp SEMI			{$$=addToTree("Stmt",3,$1,$2,$3);}
		|	IF LP Exp RP Stmt ELSE Stmt	{$$=addToTree("Stmt",7,$1,$2,$3,$4,$5,$6,$7);}
		|	WHILE LP Exp RP Stmt		{$$=addToTree("Stmt",5,$1,$2,$3,$4,$5);}
		|	error SEMI			{isError = 1;}
		;

DefList		:	Def DefList			{$$=addToTree("DefList",2,$1,$2);}
		|	/*empty*/			{$$=NULL;}
		;
Def		:	Specifier DecList SEMI		{$$=addToTree("Def",3,$1,$2,$3);}
		|	error SEMI			{isError = 1;}
		;
DecList		:	Dec				{$$=addToTree("DecList",1,$1);}
		|	Dec COMMA DecList		{$$=addToTree("DecList",3,$1,$2,$3);}		

		;
Dec		:	VarDec				{$$=addToTree("Dec",1,$1);}
		|	VarDec ASSIGNOP	Exp		{$$=addToTree("Dec",3,$1,$2,$3);}
		;
Exp		:	Exp ASSIGNOP Exp		{$$=addToTree("Exp",3,$1,$2,$3);}
		|	Exp AND Exp			{$$=addToTree("Exp",3,$1,$2,$3);}
		|	Exp OR Exp			{$$=addToTree("Exp",3,$1,$2,$3);}
		|	Exp RELOP Exp			{$$=addToTree("Exp",3,$1,$2,$3);}
		|	Exp PLUS Exp			{$$=addToTree("Exp",3,$1,$2,$3);}
		|	Exp MINUS Exp			{$$=addToTree("Exp",3,$1,$2,$3);}
		|	Exp STAR Exp			{$$=addToTree("Exp",3,$1,$2,$3);}
		|	Exp DIV Exp			{$$=addToTree("Exp",3,$1,$2,$3);}
		|	LP Exp RP			{$$=addToTree("Exp",3,$1,$2,$3);}
		|	MINUS Exp			{$$=addToTree("Exp",2,$1,$2);}
		|	NOT Exp				{$$=addToTree("Exp",2,$1,$2);}
		|	ID LP Args RP			{$$=addToTree("Exp",4,$1,$2,$3,$4);}
		|	ID LP RP			{$$=addToTree("Exp",3,$1,$2,$3);}
		|	Exp LB Exp RB			{$$=addToTree("Exp",4,$1,$2,$3,$4);}
		|	Exp DOT ID			{$$=addToTree("Exp",3,$1,$2,$3);}
		|	ID				{$$=addToTree("Exp",1,$1);}
		|	INT				{$$=addToTree("Exp",1,$1);}
		|	FLOAT				{$$=addToTree("Exp",1,$1);}
		;
Args		:	Exp COMMA Args			{$$=addToTree("Args",3,$1,$2,$3);}
		|	Exp				{$$=addToTree("Args",1,$1);}
		;

%%


yyerror(char* msg){
	fprintf(stderr,"Error type B at line %d:%s\n",yylineno,msg);
}

struct Node *addToTree(char *type,int num,...){
	struct Node *current = (struct Node *)malloc(sizeof(struct Node));
	struct Node *temp = (struct Node *)malloc(sizeof(struct Node));
	current->isToken = 0;
	va_list nodeList;
	va_start(nodeList,num);
	temp = va_arg(nodeList,struct Node*);
	current->line = temp->line;
	strcpy(current->type,type);
	current->firstChild = temp;
	int i;
	for(i = 1 ; i < num ; i++){
		temp->nextSibling = va_arg(nodeList,struct Node*);
		if(temp->nextSibling != NULL)
			temp = temp->nextSibling;
	}
	temp->nextSibling = NULL;
	va_end(nodeList);
	return current;
}

void printTree(struct Node *p,int depth){
	
	if(p == NULL) return;
	int i;
	for(i = 0 ; i < depth ; i++)
		printf("  ");
	if(!p->isToken){
		printf("%s (%d)\n", p->type, p->line);
		printTree(p->firstChild , depth+1);
	}
	else{
		if(strcmp(p->type,"INT") == 0)
			printf("%s: %d\n", p->type, myatoi(p->text));
		else if(strcmp(p->type,"FLOAT") == 0)
			printf("%s: %f\n", p->type, atof(p->text));
		else if(strcmp(p->type,"TYPE") == 0 || strcmp(p->type,"ID") == 0)
			printf("%s: %s\n", p->type, p->text);
		else
			printf("%s\n", p->type);
	}
	printTree(p->nextSibling , depth);
}


int myatoi(char* ch){
	char *p = ch; 
	if(strlen(ch) <= 1)
		return atoi(ch);
	else if(p[0] == '0'){
		if(p[1] == 'x' || p[1] == 'X')
			return (int)strtoul(ch+2, 0, 16);
		else	
			return (int)strtoul(ch+1, 0, 8);
	}
	else
		return atoi(ch);
}


