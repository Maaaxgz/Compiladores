# Hands-on 4: Analizador Léxico

## Integrantes 
* Jose Maximiliano Gonzalez Bahena

## Descripción
Este proyecto implementa un analizador léxico en C utilizando la herramienta Flex. Es capaz de reconocer tokens de un subconjunto del lenguaje C, incluyendo:
* Palabras reservadas (int, float, return, etc.)
* Identificadores y literales numéricos (enteros y flotantes).
* Operadores aritméticos y de asignación.
* Delimitadores y comentarios (de línea y de bloque).

## Requisitos del Sistema
* GCC (Compilador de C)
* Flex (Generador de analizadores léxicos)
* Entorno: Windows (con MinGW) o Linux.

## Instrucciones de Compilación y Ejecución
Para compilar y probar el analizador, siga estos pasos en la terminal desde la carpeta donde este contenido el analizador:

1. **Generar el código C con Flex:**
   ```
   flex lexer.l

2. **Compilar el código generado:**
    ```
    gcc lex.yy.c -o analizador.exe

3. **Ejecutar con el archivo de prueba:**
   ```
   Get-Content input.c | .\analizador.exe

4. **En  caso de usar Linux / Max:**
    ```
    ./analizador.exe < input.c