
nclude <stdio.h>
#include <set>
#include <map>
#include <stdlib.h>
#include <cstring>

using std::string;
using std::set;
using std::map;

int yylex(void);
void yyerror( const char* msg );
int numTemps, numLabels = 0;
string tem();
string lab();

extern int currLine;
extern int currPos;
FILE* yyin;
bool hasMain = false;

map<string, string> varTemp;
map<string, int> arrSize; 
set<string> definedFns

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

start: 
        functions
;
functions: /* ε */ 
    { 
        if( !hasMain ){
            printf( "No main function declared\n" );
        } 
    }
    | function functions { }
;

declarations: /* ε */ { 
        $$.code = strdup( "" );
        $$.place = strdup( "" );
    }
    | declaration SEMICOLON declarations { 
        string temp;
        temp.append( $1.code ).append( $3.code );
        $$.code = strdup( temp.c_str() );
        $$.place = strdup( "" );
    };
;

function: FUNCTION ident SEMICOLON BEGIN_PARAMS declarations END_PARAMS BEGIN_LOCALS declarations END_LOCALS BEGINBODY statements ENDBODY 
    {
        string temp = "func ";
        string s = $2.place;
        temp.append( s ).append( "\n" );

        if( s == "main" ){
                hasMain = true;
        }

        temp.append( declares ).append( $8.code );

        string statements = $11.code;
        if( statements.find( "continue" ) != string::npos ){
            printf( "ERROR: Continue outside loop in function %s\n", $2.place);
        }

        temp.append( statements ).append( "endfunc\n\n" );
        printf( temp.c_str() );
    }

ident: IDENT { 
    if( definedFns.find( $1 ) != definedFns.end() ){
        printf( "function %s is declared already.\n", $1 );
    } else {
        definedFns.insert( $1 );
    }
    $$.place = strdup( $1 );
    $$.code = strdup( "" );
    // printf( "ident -> IDENT %s\n", $1 ); 
}
;

identifiers: ident { 
    // printf( "identifiers -> ident\n"); 
    $$.place = strdup( $1.place );
    $$.code = strdup( "" );
}
| ident COMMA identifiers { 
    //printf( "identifiers -> ident COMMA identifiers\n"); 
    string s;
    s.append( $1.place ).append( "|" ).append( $3.place );
    $$.place = strdup( s.c_str() );
    $$.code = strdup( "" );
}
;

statements: statement SEMICOLON { 
    //printf( "statements -> ε\n"); 
    $$.code = strdup( $1.code );
}
| statement SEMICOLON statements { 
    //printf( "statements -> statement SEMICOLON statements\n"); 
    string temp;
    temp.append( $1.code );
    temp.append( $3.code );
    $$.code = strdup( temp.c_str() );
}
;

bool_expr: rel { printf( "bool_expr -> rel\n"); }
    | rel OR bool_expr { printf( "bool_expr -> rel OR bool_expr\n"); }
;

rel: relex { printf( "rel -> relex\n"); }
    | relex AND rel { printf( "bool_expr -> relex AND rel\n"); }
;

relex: relsub { printf( "relex -> relsub\n"); }
    | NOT relsub  { printf( "relex _> NOT relsub\n"); }
;

relsub: expression comp expression { printf( "relsub -> expression comp expression\n"); }
    | TRUE                           { printf( "relsub -> TRUE\n"); }
    | FALSE                          { printf( "relsub -> FALSE\n"); }
    | L_PAREN bool_expr R_PAREN      { printf( "relsub -> L_PAREN bool_expr R_PAREN\n"); }
;

comp: EQ       { printf( "comp -> EQ\n"); }
    | NEQ  { printf( "comp -> NEQ\n"); }
    | GT   { printf( "comp -> GT\n"); }
    | LTE  { printf( "comp -> LTE"); }
    | LT   { printf( "comp -> LT\n"); 
    | GTE  { printf( "comp -> GTE\n"); }
;

var: ident { 
    if( DEBUG_OUTPUT ) { printf( "var -> ident\n" );} 
    string id = $1.place;
    //check undeclared vars check1
    if( definedFns.find( id) == definedFns.end() && varTemp.find( id ) == varTemp.end() ){ //was not found
        string s = "Using an undeclared variable " + $1.place;
        yyerror( s.c_str() );
    }
    else if( arrSize[id] > 1 ){ //check if array check6
        string s = "Identifier did not provide index for array identifer " + id;
        yyerror( s.c_str() );
    }
    $$.place = strdup( id.c_str() );
    $$.code = strdup( "" )
    $$.arr = false;
}
| ident L_SQUARE_BRACKET expression R_SQUARE_BRACKET {
    if(DEBUG_OUTPUT) printf( " var -> ident L_SQUARE_BRACKET expression R_SQUARE_BRACKET\n" ); 
    string id = $1.place;
    //check undeclared vars check1
    if( definedFns.find( id) == definedFns.end() && varTemp.find( id ) == varTemp.end() ){ //was not found
        string s = "Using an undeclared variable " + $1.place;
        yyerror( s.c_str() );
    }
    else if( arrSize.find( id ) == arrSize.end() ){ //check if array check6
        string s = "Identifier is not an array identifer " + id;
        yyerror( s.c_str() );
    }
    string t;
    t.append( $1.place ).append( ", " ).append( $3.place );
    $$.code = strdup( $3.code );
    $$.place = strdup( t.c_str() );
    $$.arr = true;
}
;

var_list: var {
    if(DEBUG_OUTPUT) printf( "var_list -> var\n" );
    string t;
    if( $1.arr ){
        t.append( ".[]| ");
    }
    else {
        t.append( ".| " );
    }
    t.append( $1.place ).append( "\n" );

    $$.code = strdup( t.c_str() );
    $$.place = strdup( "" );
}
| var COMMA var_list {
    if(DEBUG_OUTPUT) printf( "var_list -> var COMMA var_list\n" ); 
    string t;
    if( $1.arr ){
        t.append( ".[]| ");
    }
    else {
        t.append( ".| " );
    }
    t.append( $1.place ).append( "\n" ).append( $3.code );

    $$.code = strdup( t.c_str() );
    $$.place = strdup( "" );
}
;
expression: mult {
    if( DEBUG_OUTPUT ) printf( "expression -> mult\n"); 
    $$.code = strdup( $1.code );
    $$.place = strdup( $1.place );
}
| mult SUB expression {
    if(DEBUG_OUTPUT) printf( "expression -> mult SUB expression\n");
    string t;
    string dest = tem();

    t.append( $1.code ).append( $3.code );
    t.append( ". " + dst + "\n" );
    t.append( "- " + dst + ", " ).append( $1.place ).append( ", " ).append( $3.place ).append( "\n");

    $$.code = strdup( t.c_str() );
    $$.place = strdup( dst.c_str() );
}
| mult PLUS expression {
    if( DEBUG_OUTPUT) printf( "expression -> mult PLUS expression\n");
    string t;
    string dest = tem();

    t.append( $1.code ).append( $3.code );
    t.append( ". " + dst + "\n" );
    t.append( "+ " + dst + ", " ).append( $1.place ).append( ", " ).append( $3.place ).append( "\n");

    $$.code = strdup( t.c_str() );
    $$.place = strdup( dst.c_str() );
}
;

term: x {printf("term -> x\n");} | number {printf("term -> number\n");} | L_PAREN expression R_PAREN {printf("term -> L_PAREN expression R_PAREN\n");} | id L_PAREN expression exp_loop R_PAREN {printf("term -> id L_PAREN expression exp_loop R_PAREN\n");} 

number: NUMBER {printf("number -> NUMBER %d\n", $1); }
exp_loop: COMMA expression exp_loop {printf("exp_loop -> COMMA expression exp_loop\n");} | %empty {printf("exp_loop -> epsilon\n");}

st_write: WRITE x  {printf("st_write -> WRITE x SEMICOLON\n");}

st_read: READ x  {printf("st_read -> READ x SEMICOLON\n");}

st_while: WHILE bool_exp BEGIN_LOOP statements END_LOOP {printf("st_while -> WHILE bool_exp BEGIN_LOOP statements END_LOOP\n");} 

st_if: IF bool_exp THEN statements ENDIF {printf("st_if -> IF bool_exp THEN statements ENDIF\n");} 

mult: term {
    if(DEBUG_OUTPUT) printf( "mult -> term\n"); 
    $$.code = strdup( $1.code );
    $$.place = strdup( $$.place );
}
}
| term MOD mult  {
    if( DEBUG_OUTPUT ) printf( "mult -> term MOD mult\n");
    string t;
    string dest = tem();

    t.append( $1.code ).append( $3.code );
    t.append( ". " + dst + "\n" );
    t.append( "% " + dst + ", " ).append( $1.place ).append( ", " ).append( $3.place ).append( "\n");

    $$.code = strdup( t.c_str() );
    $$.place = strdup( dst.c_str() );
}
| term MULT mult {
    if( DEBUG_OUTPUT) printf( "mult -> term MULT mult\n"); 
    string t;
    string dest = tem();

    t.append( $1.code ).append( $3.code );
    t.append( ". " + dst + "\n" );
    t.append( "* " + dst + ", " ).append( $1.place ).append( ", " ).append( $3.place ).append( "\n");

    $$.code = strdup( t.c_str() );
    $$.place = strdup( dst.c_str() );
}
;

term: var { printf( "term -> var\n" ); }
| SUB var {
    if(DEBUG_OUTPUT) printf( "term -> SUB var\n" ); 
    string dst = tem();
    string t;

    string dst = tem();
    //. __temp__11
    //call fibonacci, __temp__11
    t.append( $3.code );
    t.append( ". " + dst + "\n" )
    t.append( "call " ).append($1.place ).append( ", " + dst + "\n" );

    $$.code = strdup( t.c_str );
}
| ident L_PAREN  R_PAREN { printf( "term -> ident L_PAREN R_PAREN\n" ); }
;

exp: expression { printf( "exp -> expression\n"); }
    | expression COMMA exp { printf( "expression COMMA exp\n"); }
;
%%
int yyerror (const char* s) {
    extern int line;
    extern int  pos;
    printf("Error at line %d, column %d: unexpected symbol %s\n", line, pos, s); 
    exit(1);
}
		 

