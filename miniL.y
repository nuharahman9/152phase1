%{
    #define YY_NO_UNPUT
    #include <stdio.h>
    #include <stdlib.h>
    void yyerror(const char* msg);
%}

%union {
    char* VIdent;
    int Vnum;
}

%error-verbose
%start program

%token <Vnum> NUMBER
%token <VIdent> IDENT

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
{printf("function -> FUNCTION Ident SEMICOLON BEGIN_PARAMS DeclarMult END_PARAMS BEGIN_LOCALS DeclarMult END_LOCALS BEGIN_BODY StateMult END_BODY\n”);}      

Declar: 
Ident COLON INTEGER 
{printf("Declar -> Ident COLON INTEGER\n");}
| Ident COLON ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF INTEGER 
{printf("Declar -> Ident COLON ARRAY L_SQUARE_BRACKET NUMBER %d R_SQUARE_BRACKET OF INTEGER\n", $5);}
;

DeclarMult: 
%empty 
{printf("DeclarMult -> epsilon\n");}
| Declar SEMICOLON DeclarMult 
{printf("DeclarMult -> Declar SEMICOLON DeclarMult\n");}
;

Identifiers:     
Ident
{printf("Identifiers -> Ident \n");}
| Ident COMMA Identifiers
{printf("Identifiers -> Ident COMMA Identifiers\n");}

StateMult: 
State SEMICOLON StateMult 
{printf("StateMult -> State SEMICOLON StateMult\n");}
| State SEMICOLON 
{printf("StateMult -> State SEMICOLON\n");}
;

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
;

ElseState: 
%empty 
{printf("ElseState -> epsilon\n");} 
| ELSE StateMult 
{printf("ElseState -> ELSE StateMult\n");}
;

Var:             
Ident L_SQUARE_BRACKET Expression R_SQUARE_BRACKET
{printf("Var -> Ident  L_SQUARE_BRACKET Exp R_SQUARE_BRACKET\n");}
| Ident
{printf("Var -> Ident \n");}
;

VarMult:            
Var
{printf("VarMult -> Var\n");}
| Var COMMA VarMult
{printf("VarMult -> Var COMMA VarMult\n");}
;

Exp: 
Exps 
{printf("Exp -> Exps\n");} 
| Exps ADD Exp 
{printf("Exp -> Exps ADD Exp\n");} 
| Exps SUB Exp 
{printf("Exp -> Exps SUB Exp\n");}
;

ExpMult: 
%empty 
{printf("ExpMult -> epsilon\n");} 
| Exp COMMA ExpMult
{printf("ExpMult -> Exp COMMA ExpMult\n");} 
| Exp
{printf("ExpMult -> Exp\n");}

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
| SUB Vari
{printf("Term -> SUB Vari\n”);} 
| NUMBER 
{printf("Term -> NUMBER %d\n", $1);}
| SUB NUMBER
{printf("Term -> SUB NUMBER %d\n", $2);} 
| L_PAREN Exp R_PAREN 
{printf("Term -> L_PAREN Exp R_PAREN\n");}
| SUB L_PAREN Exp R_PAREN
{printf("Term -> SUB L_PAREN Exp R_PAREN\n");} 
| Ident L_PAREN Exp R_PAREN 
{printf("Term -> Ident L_PAREN ExpMult R_PAREN\n");}
;

BoolEx:
ExRA 
{printf("ExBool -> ExRel\n");}
| ExRA OR BoolEx
{printf("ExBool -> ExAndRel OR ExBool\n");}
;

ExRA:           
ExR
{printf("ExAndRel -> ExRel\n");}
                 | ExR AND ExRA
                 {printf("ExAndRel -> ExRel AND ExAndRel\n");}
;

ExR:          
NOT ExR1 
{printf("ExRel -> NOT ExRel1\n");}
| ExR1
{printf("ExRel -> ExRel1\n");}
;

ExR1:  
Exp Comp Exp
{printf("ExRel -> Exp Comp Exp\n");}
| TRUE
{printf("ExRel -> TRUE\n");}
| FALSE
{printf("ExRel -> FALSE\n");}
| L_PAREN BoolEx R_PAREN
{printf("ExRel -> L_PAREN BoolEx R_PAREN\n");}
;

Comp: 
EQ 
{printf(“Comp -> EQ\n");} 
| NEQ 
{printf(“Comp -> NEQ\n");} 
| LT 
{printf(“Comp -> LT\n");} 
| GT 
{printf(“Comp -> GT\n");} 
| LTE 
{printf(“Comp -> LTE\n");} 
| GTE 
{printf(“Comp -> GTE\n");}
;


Ident:      
IDENT
{printf("Ident -> IDENT %s \n", $1);}

%%

		 
void yyerror(const char* s) 
{
  extern int lineNum;
  extern char* yytext;

  printf("ERROR: %s at symbol \"%s\" on line %d\n", s, yytext, lineNum);
  exit(1);
}
