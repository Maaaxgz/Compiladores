%{
#include <stdio.h>
#include <stdlib.h>
#include "parser.tab.h" /* Bison genera este archivo, aqui estan los tokens */

int yylineno; 
%}

%option yylineno
%option noyywrap

%%

"int"       { return T_INT; }
"float"     { return T_FLOAT; }
"double"    { return T_DOUBLE; }
"char"      { return T_CHAR; }
"void"      { return T_VOID; }
"short"     { return T_SHORT; }
"return"    { return T_RETURN; }
"include"   { return T_INCLUDE; }
"define"    { return T_DEFINE; }

[0-9]+\.[0-9]+  { return NUM_FLOAT; }
[0-9]+          { return NUM_INT; }

[a-zA-Z_][a-zA-Z0-9_]* { return IDENTIFIER; }

"="   { return ASSIGN; }
"+"   { return PLUS; }
"-"   { return MINUS; }
"*"   { return MULT; }
"/"   { return DIV; }
"++"  { return INCREMENT; }

"("   { return LPAREN; }
")"   { return RPAREN; }
"{"   { return LBRACE; }
"}"   { return RBRACE; }
";"   { return SEMICOLON; }
","   { return COMMA; }
"#"   { return HASH; }
"<"   { return LT; }
">"   { return GT; }
"."   { return DOT; }

"//".* { /* Ignorar comentarios linea */ }
"/*"([^*]|(\*+[^*/]))*\*+"/" { /* Ignorar comentarios bloque */ }

[ \t\n]+    { /* Ignorar espacios */ }

.           { printf("Error lexico inesperado: %s\n", yytext); }

%%