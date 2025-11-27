# Hands-on 5: Analizador Sintáctico (Flex + Bison)

## Integrantes
* Jose Maximiliano Gonzalez Bahena

## Descripción
Este proyecto implementa un Analizador Sintáctico para un subconjunto del lenguaje C, integrando **Flex** (análisis léxico) y **Bison** (análisis sintáctico).

El sistema valida que el código fuente cumpla con la gramática definida, soportando estructuras como:
* **Declaraciones:** Variables globales y locales, funciones y directivas de preprocesador (`#include`, `#define`).
* **Sentencias:** Bloques de código `{ ... }`, asignaciones, retorno de valores y estructuras de control (`if`).
* **Expresiones:** Operaciones aritméticas respetando precedencia (suma, resta, multiplicación, división) y llamadas a funciones.

## Requisitos
* GCC
* Flex
* Bison (WinFlexBison en Windows)

## Instrucciones de Compilación
Para construir el analizador desde cero, ejecute los siguientes comandos en orden:

1. **Generar el Parser (Sintáctico):**
   ```
   bison -d parser.y
   ```
   Esto genera los archivos `parser.tab.c` y `parser.tab.h`.
    

2. **Generar el Scanner (Lexico)**
   ```
   flex lexer.l
   ```
   Esto genera el archivo `lex.yy.c`.

3. **Compilar el ejecutable**
   ```
   gcc parser.tab.c lex.yy.c -o analizador_sintactico.exe
   ```

4. **Ejecutar la prueba**
   ```
   ./analizador_sintactico.exe
   ```
   El programa buscará automáticamente el archivo input.c
