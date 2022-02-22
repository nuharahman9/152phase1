%{
   
    #include <stdio.h>
    #include <stdlib.h>
    #include <vector> 
    #include <string> 
    
    extern FILE * yyin; 
    int yyerror(const char* s);

    char *idToken; 
    int numberToken; 
    int count_names = 0; 
    enum Type { Integer, Array }l
    struct Symbol { 
        std::string name; 
        Type type; 
    } 
    struct Function { 
        std::string name; 
        std::vector<Symbol> declarations; 
    };
    std::vector <Function> symbol_table; 
    Function *get_function(){
        int last = symbol_table.size()-1; 
        return &symbol_table[last];
    }
    bool find(std::string &value) {
        Function *f = get_function();
        for(int i=0; i < f->declarations.size(); i++) {
        Symbol *s = &f->declarations[i];
        if (s->name == value) {
      return true;
        }
      }
    return false;
    }

    void add_function_to_symbol_table(std::string &value) {
        Function f; 
        f.name = value; 
        symbol_table.push_back(f);
    }

    void add_variable_to_symbol_table(std::string &value, Type t) {
        Symbol s;
        s.name = value;
        s.type = t;
        Function *f = get_function();
        f->declarations.push_back(s);
    }

    void print_symbol_table(void) {
        printf("symbol table:\n");
        printf("--------------------\n");
        for(int i=0; i<symbol_table.size(); i++) {
            printf("function: %s\n", symbol_table[i].name.c_str());
            for(int j=0; j<symbol_table[i].declarations.size(); j++) {
            printf("  locals: %s\n", symbol_table[i].declarations[j].name.c_str());
            }
        }
        printf("--------------------\n");
    }


%}

%union 
{
    char* op_val; 
}

%error-verbose
%start P 



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

%token <op_val> NUMBER
%token <op_val> IDENT
%type <op_val> symbol 

%%

P: functions {}

functions: fx functions {}

fx: FUNCTION symbol SEMICOLON BEGIN_PARAMS decs END_PARAMS BEGIN_LOCALS decs END_LOCALS BEGIN_BODY statements END_BODY {}

decs: dec SEMICOLON decs {}

dec: symbol COLON INTEGER {}

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

st_for: FOR x ASSIGN symbol SEMICOLON bool_exp SEMICOLON x ASSIGN expression BEGIN_LOOP statements END_LOOP {}


bool_exp: relation_exps {}} |  bool_exp OR relation_exps {}

relation_exps: relation_exp {} | relation_exps AND relation_exp {}

relation_exp: NOT exp_comp {} | exp_comp  {} | TRUE  {} | FALSE  {} | L_PAREN bool_exp R_PAREN  {}

exp_comp: expression comp expression {} 

comp: EQ {} | NEQ {} | GT {} | LTE {} | GTE {}

st_var: x ASSIGN expression {} 

x: symbol {} | symbol L_SQUARE_BRACKET expression R_SQUARE_BRACKET {}} | symbol L_SQUARE_BRACKET expression R_SQUARE_BRACKET L_SQUARE_BRACKET expression R_SQUARE_BRACKET {}

expression: multiplicative_exp add_sub_exp {}

multiplicative_exp: term {} | term MULT multiplicative_exp {} | term DIV multiplicative_exp {} | term MOD multiplicative_exp {}

add_sub_exp: ADD expression {} | SUB expression {} |  %empty {}

term: x {} | symbol {} | L_PAREN expression R_PAREN {} | symbol L_PAREN expression exp_loop R_PAREN {} 

symbol: NUMBER {} | IDENT {}
exp_loop: COMMA expression exp_loop {} | %empty {}


%%
int yyerror (const char* s) {
    extern int line;
    extern int  pos;
    printf("Error at line %d, column %d: unexpected symbol %s\n", line, pos, s); 
    exit(1);
}
		 

