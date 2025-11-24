%{
#include <stdio.h>
%}

%%

    /* --- 1. Palabras Reservadas --- */
"int"     { printf("PALABRA_RESERVADA: int\n"); }
"float"   { printf("PALABRA_RESERVADA: float\n"); }
"double"  { printf("PALABRA_RESERVADA: double\n"); }
"char"    { printf("PALABRA_RESERVADA: char\n"); }
"void"    { printf("PALABRA_RESERVADA: void\n"); }
"short"   { printf("PALABRA_RESERVADA: short\n"); }
"return"  { printf("PALABRA_RESERVADA: return\n"); }
"include" { printf("PALABRA_RESERVADA: include\n"); }
"define"  { printf("PALABRA_RESERVADA: define\n"); }

    /* --- 2. Valores Numéricos --- */
[0-9]+\.[0-9]+ { printf("NUMERO_FLOTANTE: %s\n", yytext); }
[0-9]+         { printf("NUMERO_ENTERO: %s\n", yytext); }

    /* --- 3. Identificadores Permitidos--- */
[a-zA-Z_][a-zA-Z0-9_]* { printf("IDENTIFICADOR: %s\n", yytext); }

    /* --- 4. Operadores --- */
"="  { printf("OPERADOR: ASIGNACION\n"); }
"+"  { printf("OPERADOR: SUMA\n"); }
"-"  { printf("OPERADOR: RESTA\n"); }
"*"  { printf("OPERADOR: MULTIPLICACION\n"); }
"/"  { printf("OPERADOR: DIVISION\n"); }
"++" { printf("OPERADOR: INCREMENTO\n"); }

    /* --- 5. Delimitadores --- */
"(" { printf("DELIMITADOR: PARENTESIS_IZQ\n"); }
")" { printf("DELIMITADOR: PARENTESIS_DER\n"); }
"{" { printf("DELIMITADOR: LLAVE_IZQ\n"); }
"}" { printf("DELIMITADOR: LLAVE_DER\n"); }
";" { printf("DELIMITADOR: PUNTO_Y_COMA\n"); }
"," { printf("DELIMITADOR: COMA\n"); }
"#" { printf("DELIMITADOR: HASH\n"); }

    /* --- 6. Comentarios --- */
"//".*                       { printf("COMENTARIO_LINEA: %s\n", yytext); }
"/*"([^*]|(\*+[^*/]))*\*+"/" { printf("COMENTARIO_BLOQUE\n"); }

    /* --- Ignorar espacios y saltos de línea --- */
[ \t\n]+ { /* Ignorar espacios en blanco */ }

    /* --- Cualquier cosa no reconocida --- */
. { printf("ERROR_LEXICO: %s\n", yytext); }

%%

int main() {
    yylex();
    return 0;
}

int yywrap() {
    return 1;
}