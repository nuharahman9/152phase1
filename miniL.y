%{
   
    #include <stdio.h>
    #include <stdlib.h>
    
    extern FILE * yyin; 
    int yyerror(const char* s);
%}

%union 
{
    char* id;
    int num;
}

%error-verbose
%start P 

%token <num> NUMBER
%token <id> IDENT

%token FUNCTION 
%token BEGIN_PARAMS 
%token END_PARAMS 
%token BEGIN_LOCALS 
%token END_LOCALS 
%token BEGIN_BODY 
%token END_BODY 
%token INTEGER 
%token ARRAY 
%token OF 
%token IF 
%token THEN 
%token ENDIF 
%token ELSE 
%token WHILE 
%token DO 
%token IN 
%token BEGIN_LOOP 
%token END_LOOP  
%token BREAK 
%token CONTINUE 
%token READ 
%token WRITE 
%token TRUE 
%token FALSE 
%token RETURN
%token FOR 

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

%token SEMICOLON 
%token COLON 
%token COMMA 
%token L_PAREN 
%token R_PAREN 
%token L_SQUARE_BRACKET 
%token R_SQUARE_BRACKET

%left ASSIGN

%%

P: functions {}

functions: fx functions {}

fx: FUNCTION id SEMICOLON BEGIN_PARAMS decs END_PARAMS BEGIN_LOCALS decs END_LOCALS BEGIN_BODY statements END_BODY {}

decs: dec SEMICOLON decs {}

dec: ids COLON INTEGER {}

ids: id {}

id: IDENT {}

statements: statement SEMICOLON statements {} | statement SEMICOLON {}

statement: st_return {} | st_continue {}  | st_break  {}|  st_write {} | st_read {} | st_while {} | st_if {p} | st_var {}  | st_do {} | st_for {}

st_break: BREAK {}  
st_return: RETURN expression {} 

st_continue: CONTINUE {}

st_write: WRITE x  {}

st_read: READ x  {}

st_while: WHILE bool_exp BEGIN_LOOP statements END_LOOP {} 

st_if: IF bool_exp THEN statements ENDIF {} 

st_do: DO BEGIN_LOOP statements END_LOOP {} 

st_for: FOR x ASSIGN number SEMICOLON bool_exp SEMICOLON x ASSIGN expression BEGIN_LOOP statements END_LOOP {}


bool_exp: relation_exps {}} |  bool_exp OR relation_exps {}

relation_exps: relation_exp {} | relation_exps AND relation_exp {}

relation_exp: NOT exp_comp {} | exp_comp  {} | TRUE  {} | FALSE  {} | L_PAREN bool_exp R_PAREN  {}

exp_comp: expression comp expression {} 

comp: EQ {} | NEQ {} | GT {} | LTE {} | GTE {}

st_var: x ASSIGN expression {} 

x: id {} | id L_SQUARE_BRACKET expression R_SQUARE_BRACKET {}} | id L_SQUARE_BRACKET expression R_SQUARE_BRACKET L_SQUARE_BRACKET expression R_SQUARE_BRACKET {}

expression: multiplicative_exp add_sub_exp {}

multiplicative_exp: term {} | term MULT multiplicative_exp {} | term DIV multiplicative_exp {} | term MOD multiplicative_exp {}

add_sub_exp: ADD expression {} | SUB expression {} |  %empty {}

term: x {} | number {} | L_PAREN expression R_PAREN {} | id L_PAREN expression exp_loop R_PAREN {} 

number: NUMBER {}
exp_loop: COMMA expression exp_loop {} | %empty {}


%%
int yyerror (const char* s) {
    extern int line;
    extern int  pos;
    printf("Error at line %d, column %d: unexpected symbol %s\n", line, pos, s); 
    exit(1);
}
		 

