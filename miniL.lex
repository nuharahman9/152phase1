   /* cs152-miniL phase1 */
   
%{
   
 int line = 1;   
 int pos = 1;    
   /* write your C code here for definitions of variables and including headers */
%}
  DIGIT [0-9] 
 
   /* some common rules */

%%
   /* specific lexer rules in regex (might have to reorder rules later)*/
   "(" {printf("L_PAREN\n"), pos += yyleng;}
   ")" {printf("R_PAREN\n"), pos += yyleng;}
   "/" {printf("DIV\n"), pos += yyleng;} 
   "*" {printf("MULT\n"), pos += yyleng;}
   "+" {printf("ADD\n"), pos += yyleng;} 
   "-" {printf("SUB\n"), pos += yyleng;}
   "%" {printf("MOD\n"), pos += yyleng;} 

   ":=" {printf("ASSIGN\n"), pos += yyleng;} 
   ":" {printf("COLON\n"), pos += yyleng;}
   ";" {printf("SEMICOLON\n"), pos += yyleng;} 
   "[" {printf("L_SQUARE_BRACKET\n"), pos += yyleng;} 
   "]" {printf("R_SQUARE_BRACKET\n"), pos += yyleng;} 
   "," {printf("COMMA\n"), pos += yyleng;} 
   "<" {printf("LT\n"), pos += yyleng;} 
   ">" {printf("GT\n"), pos += yyleng;} 
   "<=" {printf("LTE\n"), pos += yyleng;} 
   ">=" {printf("GTE\n"), pos += yyleng;} 
   "==" {printf("EQ\n"), pos += yyleng;} 
   "<>" {printf("NEQ\n"), pos += yyleng;}


   function {printf("FUNCTION\n"), pos += yyleng;} 
   beginparams {printf("BEGIN_PARAMS\n"), pos += yyleng;} 
   endparams   {printf("END_PARAMS\n"), pos += yyleng;} 
   beginlocals {printf("BEGIN_LOCALS\n"), pos += yyleng;} 
   endlocals {printf("END_LOCALS\n"), pos += yyleng;} 
   beginbody {printf("BEGIN_BODY\n"), pos += yyleng;} 
   endbody {printf("END_BODY\n"), pos += yyleng;} 
   integer {printf("INTEGER\n"), pos += yyleng;} 
   array {printf"ARRAY\n", pos += yyleng;} 
   of {printf("OF\n"), pos += yyleng;} 
   if {printf("IF\n"), pos += yyleng;} 
   then {printf("THEN\n"), pos += yyleng;} 
   endif {printf("ENDIF\n"), pos += yyleng;}
   else {printf("ELSE\n"), pos += yyleng;} 
   while {printf("WHILE\n"), pos += yyleng;}
   do {printf("DO\n"), pos += yyleng;} 
   beginloop {printf("BEGINLOOP\n"), pos += yyleng;}
   endloop {printf("ENDLOOP\n"), pos += yyleng;}
   continue {printf("CONTINUE\n"), pos += yyleng;} 
   break {printf("BREAK\n"), pos += yyleng;} 
   read {printf("READ\n"), pos += yyleng;} 
   write {printf("WRITE\n"), pos += yyleng;} 
   not {printf("NOT\n"), pos += yyleng;} 
   true {printf("TRUE\n"), pos += yyleng;} 
   false {printf("FALSE\n"), pos += yyleng;}
   return {printf("RETURN\n"), pos += yyleng;}


   "==" {printf("EQ\n"), pos += yyleng;} 
   "<>" {printf("NEQ\n"), pos += yyleng;} 
   "<" {printf("LT\n"), pos += yyleng;} 
   ">" {printf("GT\n"), pos += yyleng;} 
   "<=" {printf("LTE\n"), pos += yyleng;}
   ">=" {printf("GTE\n"), pos += yyleng;}


   
  [##].* {line++; pos = 1;} 

  {DIGIT}+       {printf("NUMBER %s\n", yytext); pos += yyleng;} 
  [0-9_]+[0-9A-Za-z_]* {printf("Error at line %i, column %i: identifier \"%s\" must begin with a letter\n", line, pos, yytext), pos += yyleng;} 
  [0-9A-Za-z_]+[_]+    {printf("Error at line %i, column %i: identifier \"%s\" cannot end with an underscore\n", line, pos, yyext), pos += yyleng;} 
  [ ] {pos += yyleng;} 
  "\n" {pos = 1; line++;}
  [\t] {pos += yyleng;}

  
  [A-Za-z]+[A-Za-z0-9_]*[A-Za-z0-9] {printf("IDENT %s\n", yytext), pos += yyleng;} 
  . {printf("Error at line %i, column %i: unrecognized symbol \"%s\"", line pos, yytext), pos += yyleng; exit(0);} 

 
 
%%
	/* C functions used in lexer */

int main(int argc, char ** argv)
{
   yylex();
}
