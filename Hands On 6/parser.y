%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex();
extern int yylineno;
extern char* yytext;
void yyerror(const char *s);

/* --- ESTRUCTURAS DE DATOS --- */

struct Symbol {
    char *name;
    char *type;
    int scope_level;
    struct Symbol *next;
};

struct Symbol *symbol_table = NULL;
int current_scope = 0;

/* Función para buscar */
struct Symbol* lookup(char *name) {
    struct Symbol *ptr = symbol_table;
    while (ptr != NULL) {
        if (strcmp(ptr->name, name) == 0) {
            return ptr; 
        }
        ptr = ptr->next;
    }
    return NULL; 
}

/* Función para insertar */
void install(char *name, char *type) {
    // Verificar redeclaracion en el scope
    struct Symbol *ptr = symbol_table;
    while (ptr != NULL) {
        if (strcmp(ptr->name, name) == 0 && ptr->scope_level == current_scope) {
            printf("ERROR SEMANTICO (Linea %d): Variable '%s' ya declarada en este scope.\n", yylineno, name);
            return; 
        }
        ptr = ptr->next;
    }

    struct Symbol *new_sym = (struct Symbol *) malloc(sizeof(struct Symbol));
    new_sym->name = strdup(name);
    new_sym->type = strdup(type);
    new_sym->scope_level = current_scope;
    new_sym->next = symbol_table;
    symbol_table = new_sym;
    
    printf("-> Variable declarada: %s (Tipo: %s, Scope: %d)\n", name, type, current_scope);
}

void context_check(char *name) {
    if (lookup(name) == NULL) {
        printf("ERROR SEMANTICO (Linea %d): Variable '%s' no declarada.\n", yylineno, name);
    }
}

void increase_scope() { current_scope++; }

void decrease_scope() {
    // Limpieza simple de scope
    struct Symbol *ptr = symbol_table;
    struct Symbol *prev = NULL;
    while (ptr != NULL) {
        if (ptr->scope_level > (current_scope - 1)) {
            struct Symbol *temp = ptr;
            if (prev == NULL) symbol_table = ptr->next;
            else prev->next = ptr->next;
            ptr = ptr->next;
        } else {
            prev = ptr;
            ptr = ptr->next;
        }
    }
    current_scope--;
}

char current_type[50];

%}

/* --- DEFINICIÓN DE UNION  --- */
%union {
    char *sval; /* sval sera el nombre de la variable */
}

%token <sval> IDENTIFIER /* IDENTIFIER usa el campo sval */
%token T_INT T_FLOAT T_DOUBLE T_CHAR T_VOID T_SHORT T_RETURN
%token T_INCLUDE T_DEFINE
%token T_IF T_WHILE
%token NUM_INT NUM_FLOAT
%token ASSIGN PLUS MINUS MULT DIV INCREMENT
%token LPAREN RPAREN LBRACE RBRACE SEMICOLON COMMA HASH
%token LT GT DOT 

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
    HASH T_INCLUDE LT IDENTIFIER DOT IDENTIFIER GT 
    | HASH T_DEFINE IDENTIFIER NUM_INT { install($3, "const_int"); }
    ;

var_declaration:
    type_specifier IDENTIFIER { install($2, current_type); } SEMICOLON
    | type_specifier IDENTIFIER { install($2, current_type); } ASSIGN expression SEMICOLON
    ;

fun_declaration:
    type_specifier IDENTIFIER { 
        install($2, "funcion"); 
        increase_scope(); 
    } LPAREN params RPAREN block_content
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
    type_specifier IDENTIFIER { install($2, current_type); }
    ;

block:
    LBRACE { increase_scope(); } statement_list RBRACE { decrease_scope(); }
    ;

block_content:
    LBRACE statement_list RBRACE { decrease_scope(); }
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
    | control_stmt
    ;

control_stmt:
    T_IF LPAREN expression RPAREN block 
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
    IDENTIFIER { context_check($1); } ASSIGN expression
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
    | IDENTIFIER { context_check($1); } 
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
    T_INT     { strcpy(current_type, "int"); }
    | T_FLOAT { strcpy(current_type, "float"); }
    | T_DOUBLE { strcpy(current_type, "double"); }
    | T_CHAR  { strcpy(current_type, "char"); }
    | T_VOID  { strcpy(current_type, "void"); }
    | T_SHORT { strcpy(current_type, "short"); }
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
    extern FILE *yyin;
    yyin = input;

    if (yyparse() == 0) {
        printf("\nAnalisis semantico completado.\n");
    } else {
        printf("\nEl analisis fallo.\n");
    }
    
    fclose(input);
    return 0;
}