%{
#include <stdio.h>
#include <stdlib.h>

extern int yylex();
extern int yylineno;
extern char* yytext;
void yyerror(const char *s);

%}

/* Definición de Tokens */
%token T_INT T_FLOAT T_DOUBLE T_CHAR T_VOID T_SHORT T_RETURN
%token T_INCLUDE T_DEFINE
%token IDENTIFIER NUM_INT NUM_FLOAT LITERAL_STRING
%token ASSIGN PLUS MINUS MULT DIV INCREMENT
%token LPAREN RPAREN LBRACE RBRACE SEMICOLON COMMA HASH
%token LT GT DOT 

/* Precedencia de operadores */
%left PLUS MINUS
%left MULT DIV

%%

/* --- Gramática --- */

program:
    declaration_list
    ;

declaration_list:
    declaration_list declaration
    | declaration
    ;

declaration:
    var_declaration
    | fun_declaration
    | preprocessor_directive
    ;

preprocessor_directive:
    HASH T_INCLUDE LT IDENTIFIER DOT IDENTIFIER GT { printf("Directiva include detectada\n"); }
    | HASH T_DEFINE IDENTIFIER NUM_INT { printf("Directiva define detectada\n"); }
    ;

var_declaration:
    type_specifier IDENTIFIER SEMICOLON
    | type_specifier IDENTIFIER ASSIGN expression SEMICOLON
    ;

fun_declaration:
    type_specifier IDENTIFIER LPAREN params RPAREN block
    ;

params:
    param_list
    | /* vacio */
    ;

param_list:
    param_list COMMA param
    | param
    ;

param:
    type_specifier IDENTIFIER
    ;

block:
    LBRACE statement_list RBRACE
    ;

statement_list:
    statement_list statement
    | /* vacio */
    ;

statement:
    expression_stmt
    | block
    | return_stmt
    | var_declaration
    ;

expression_stmt:
    expression SEMICOLON
    | SEMICOLON
    ;

return_stmt:
    T_RETURN expression SEMICOLON
    ;

expression:
    var_assign
    | simple_expression
    ;

var_assign:
    IDENTIFIER ASSIGN expression
    ;

simple_expression:
    simple_expression PLUS term
    | simple_expression MINUS term
    | term
    ;

term:
    term MULT factor
    | term DIV factor
    | factor
    ;

factor:
    LPAREN expression RPAREN
    | IDENTIFIER
    | IDENTIFIER LPAREN args RPAREN 
    | NUM_INT
    | NUM_FLOAT
    ;

args:
    arg_list
    | /* vacio */
    ;

arg_list:
    arg_list COMMA expression
    | expression
    ;

type_specifier:
    T_INT | T_FLOAT | T_DOUBLE | T_CHAR | T_VOID | T_SHORT
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error sintactico en la linea %d: %s\n", yylineno, s);
}

int main() {
    FILE *input = fopen("input.c", "r");
    if (!input) {
        printf("No se pudo abrir input.c\n");
        return 1;
    }
    
    // Flex que lee el archivo
    extern FILE *yyin;
    yyin = input;

    // Arrancamos el parser
    if (yyparse() == 0) {
        printf("\nAnalisis sintactico completado exitosamente.\n");
    } else {
        printf("\nEl analisis fallo.\n");
    }
    
    fclose(input);
    return 0;
}