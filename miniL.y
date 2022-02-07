%{
    #define YY_NO_UNPUT
    #include <stdio.h>
    #include <stdlib.h>
    void yyerror(const char* msg);
%}

%union {
    char* VIdent;
    int Vval;
}

%error-verbose
%start program

%token <Vval> NUMBER
%token <VIdent> Ident

%token FUNCTION BEGIN_PARAMS END_PARAMS BEGIN_LOCALS END_LOCALS BEGIN_BODY END_BODY INTEGER ARRAY OF IF THEN ENDIF ELSE WHILE DO IN BEGINLOOP ENDLOOP BREAK CONTINUE READ WRITE TRUE FALSE RETURN

%left AND
%left OR
%right NOT 
%left SUB
%left ADD
%left MULT
%left DIV
%left MOD
%left EQ
%left NEQ
%left LT
%left GT
%left LTE
%left GTE

%token SEMICOLON COLON COMMA L_PAREN R_PAREN L_SQUARE_BRACKET R_SQUARE_BRACKET

%left ASSIGN

%%

program: 
%empty 
{printf("program -> epsilon\n");} 
| function program 
{printf("program -> function program\n");}

function: 
FUNCTION Ident SEMICOLON BEGIN_PARAMS DeclarMult END_PARAMS BEGIN_LOCALS DeclarMult END_LOCALS BEGIN_BODY StateMult END_BODY 
{printf("function -> FUNCTION Ident SEMICOLON BEGIN_PARAMS DeclarMult END_PARAMS BEGIN_LOCALS DeclarMult END_LOCALS BEGIN_BODY StateMult END_BODY\n");}

DeclarMult: 
%empty 
{printf("DeclarMult -> epsilon\n");}
| Declar SEMICOLON DeclarMult 
{printf("DeclarMult -> Declar SEMICOLON DeclarMult\n");}

Declar: 
Ident COLON INTEGER 
{printf("Declar -> Ident COLON INTEGER\n");}
| Ident COLON ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF INTEGER 
{printf("Declar -> Ident COLON ARRAY L_SQUARE_BRACKET NUMBER %d R_SQUARE_BRACKET OF INTEGER\n", $5);}

StateMult: 
State SEMICOLON StateMult 
{printf("StateMult -> State SEMICOLON StateMult\n");}
| State SEMICOLON 
{printf("StateMult -> State SEMICOLON\n");}

State: 
Vari ASSIGN Exp 
{printf("State -> Vari ASSIGN Exp\n");} 
| IF BoolEx THEN StateMult ElseState ENDIF 
{printf("State -> IF BoolEx THEN StateMult ElseState ENDIF\n");} 
| WHILE BoolEx BEGINLOOP StateMult ENDLOOP 
{printf("State -> WHILE BoolEx BEGINLOOP StateMult ENDLOOP\n");} 
| DO BEGINLOOP StateMult ENDLOOP WHILE BoolEx 
{printf("State -> DO BEGINLOOP StateMult ENDLOOP WHILE BoolEx\n");} 
| READ VariMult 
{printf("State -> READ Vari\n");} 
| WRITE VariMult 
{printf("State -> WRITE Vari\n");} 
| CONTINUE 
{printf("State -> CONTINUE\n");} 
| BREAK 
{printf("State -> BREAK\n");} 
| RETURN Exp 
{printf("State -> RETURN Exp\n");}

ElseState: 
%empty 
{printf("ElseState -> epsilon\n");} 
| ELSE StateMult 
{printf("ElseState -> ELSE StateMult\n");}

BoolEx: 
NOT BoolEx 
{printf("BoolEx -> NOT BoolEx\n");} 
| CompEx 
{printf("BoolEx -> CompEx\n");}

CompEx: 
Exp Comp Exp 
{printf("CompEx -> Exp Comp Exp\n");}

Comp: 
EQ 
{printf("Comp -> EQ\n");} 
| NEQ 
{printf("Comp -> NEQ\n");} 
| LT 
{printf("Comp -> LT\n");} 
| GT 
{printf("Comp -> GT\n");} 
| LTE 
{printf("Comp -> LTE\n");} 
| GTE 
{printf("Comp -> GTE\n");}

Exp: 
Exps 
{printf("Exp -> Exps\n");} 
| Exps ADD Exp 
{printf("Exp -> Exps ADD Exp\n");} 
| Exps SUB Exp 
{printf("Exp -> Exps SUB Exp\n");}

ExpMult: 
%empty 
{printf("ExpMult -> epsilon\n");} 
| Exp 
{printf("ExpMult -> Exp\n");} 
| Exp COMMA ExpMult 
{printf("ExpMult -> Exp COMMA ExpMult\n");}

Exps: 
Term 
{printf("Exps -> Term\n");}
| Term MULT Exps 
{printf("Exps -> Term MULT Exps\n");} 
| Term DIV Exps 
{printf("Exps -> Term DIV Exps\n");} 
| Term MOD Exps 
{printf("Exps -> Term MOD Exps\n");}

Term: 
Vari 
{printf("Term -> Vari\n");} 
| NUMBER 
{printf("Term -> NUMBER %d\n", $1);} 
| L_PAREN Exp R_PAREN 
{printf("Term -> L_PAREN Exp R_PAREN\n");} 
| Ident L_PAREN Exp R_PAREN 
{printf("Term -> Ident L_PAREN ExpMult R_PAREN\n");}


Vari: 
Ident 
{printf("Vari -> Ident\n");} 
| Ident L_SQUARE_BRACKET Exp R_SQUARE_BRACKET 
{printf("Vari -> Ident L_SQUARE_BRACKET Exp R_SQUARE_BRACKET\n");}

VariMult: 
Vari 
{printf("VariMult -> Vari\n");} 
| Vari COMMA VariMult 
{printf("VariMult -> Vari COMMA VariMult\n");}

Ident: 
Ident 
{printf("Ident -> Ident %s\n", $1)} 
| Ident COMMA Ident 
{printf("Ident -> Ident COMMA Ident %s\n", $1);}

%%

void yyerror(const char* msg) 
{
    extern int rowNum;
    extern char* yytext;
    printf(“Error On Line %d At Symbol %a\n", rowNum, yytext);
    printf("%s\n", msg);
    exit(1);
}
