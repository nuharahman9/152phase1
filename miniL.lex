

   /* cs152-miniL phase1 */
   
%{   
   /* write your C code here for definitions of variables and including headers */
int line = 0;
int pos = 1;
%}

   /* some common rules */
DIGITS [0-9]

%%
   /* specific lexer rules in regex */
"-"	{pos += yyleng; return SUB;}
"+" 	{pos += yyleng; return ADD;}
"*" 	{pos += yyleng; return MULT;}
"/" 	{pos += yyleng; return DIV;}
"%" 	{pos += yyleng; return MOD;}

"==" 	{pos += yyleng; return EQ;}
"<>" 	{pos += yyleng; return NEQ;}
"<" 	{pos += yyleng; return LT;}
">" 	{pos += yyleng; return GT;}
"<=" 	{pos += yyleng; return LTE;}
">=" 	{pos += yyleng; return GTE;}

";" 	{pos += yyleng; return SEMICOLON;}
":" 	{pos += yyleng; return COLON;}
"," 	{pos += yyleng; return COMMA;
"(" 	{pos += yyleng; return LPAREN;}
")" 	{pos += yyleng; return RPAREN;}}
"[" 	{pos += yyleng; return L_SQUARE_BRACKET;}
"]" 	{pos += yyleng; return R_SQUARE_BRACKET;}
":=" 	{pos += yyleng; return ASSIGN;}


%%
	/* C functions used in lexer */
