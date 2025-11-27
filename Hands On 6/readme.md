# Hands-on 6: Análisis Semántico

## Integrante 
* Jose Maximiliano Gonzalez Bahena

## Descripción
Este proyecto extiende el analizador sintáctico previo para implementar la fase de **Análisis Semántico**. Se valida la coherencia lógica del código fuente mediante el uso de una Tabla de Símbolos dinámica.

### Capacidades del Analizador:
1.  **Gestión de Tabla de Símbolos:** Almacena variables, funciones y constantes (`#define`) con sus respectivos tipos.
2.  **Validación de Scopes (Alcance):**
    * Manejo de variables Globales (Scope 0).
    * Variables Locales de función (Scope 1).
    * Bloques anidados (Scope 2+).
    * Detección de redeclaraciones inválidas dentro del mismo contexto.
3.  **Chequeo de Tipos y Existencia:** Verifica que toda variable utilizada haya sido declarada previamente en un scope válido.

## Requisitos
* GCC
* Flex
* Bison (WinFlexBison)

## Instrucciones de Compilación y Ejecución
Siga estos pasos para generar el analizador semántico:

1.  **Generar el Parser (Bison):**
    ```
    bison -d parser.y
    ```

2.  **Generar el Scanner (Flex):**
    ```
    flex lexer.l
    ```

3.  **Compilar el Ejecutable:**
    ```
    gcc parser.tab.c lex.yy.c -o semantico.exe
    ```

4.  **Ejecutar con el archivo de prueba:**
    ```
    ./semantico.exe
    ```

## Ejemplo de Salida Esperada
```
-> Variable declarada: globalA (Tipo: int, Scope: 0)
-> Variable declarada: resultLocal (Tipo: int, Scope: 1)
Analisis semantico completado.
```