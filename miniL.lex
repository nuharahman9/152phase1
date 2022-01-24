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
   for {printf("FOR\n"); currPos += yyleng;} 
   beginloop {printf("BEGINLOOP\n"), pos += yyleng;}
   endloop {printf("ENDLOOP\n"), pos += yyleng;}
   continue {printf("CONTINUE\n"), pos += yyleng;} 
   break {printf("BREAK\n"), pos += yyleng;} 
   and {printf("AND\n"); currPos += yyleng;}
   or {printf("OR\n"); currPos += yyleng;}
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

  {DIGIT}+       {printf("Number  %s\n", yytext); pos += yyleng;} 
  [0-9_]+[0-9A-Za-z_]* {printf("There is an error at line %i, column %i: identifier \"%s\" must begin with a letter\n", line, pos, yytext), pos += yyleng;} 
  [0-9A-Za-z_]+[_]+    {printf("Thre is an error at line %i, column %i: identifier \"%s\" cannot end with an underscore\n", line, pos, yyext), pos += yyleng;} 
  [ ] {pos += yyleng;} 
  "\n" {pos = 1; line++;}
  [\t] {pos += yyleng;}

  
 [A-Za-z]+[A-Za-z0-9_]*[A-Za-z0-9] {printf("Ident %s\n", yytext), pos += yyleng;} 
  . {printf("THre is an error at line %i, column %i: unrecognized symbol \"%s\"", line pos, yytext), pos += yyleng; exit(0);} 

"*"      {printf("Mult\n"); numOps++;} 
"/"      {print("Div\n"); numOps++;}
"("      {printf("OpenP\n"); numParens++;}
")"      {printf("CloseP\n"); numParens++}
"+"      {printf("Plus\n"); numOps++;}
"-"      {printf("Minus\n"); numOps++;}
"="      {printf("Equal\n"); numEqs++;}
{DIGIT}+ {printf("Number %s\n" , yytext); numNums++;}
.        {printf("Invalid Syntax %s\n");}

%%
	/* C functions used in lexer */

int main(int argc, char ** argv)
{
   if (argc == 2) 
   {
	yyin = fopen(argv[1], "r");
   }
	yylex();
	
   if (argc == 2)
   {
	fclose(yyin);
   }
   
   printf("This is the number of equals: %d\n" , numEqs);
   printf("This is the number of numbers: %d\n" , numNums);
   printf("This is the number of operations: %d\n" , numOps);
   printf("This is the number of parantheses: %d\n" , numParens);
}
