# Emilio — `algebra.ex`

Práctica 1. Computación Distribuida 2027-1.

Esta guía no trae el código. Si la lees tú, sigue los pasos y escribe el archivo. Si se la pasas a una IA, pídele que implemente solo lo que dice aquí, con estos nombres, y que no invente otros módulos.

## Entrega

Un solo archivo: `algebra.ex`.  
Módulo: `Algebra`.  
No entregues pruebas, no crees `worker.ex`, `server.ex` ni `benchmark.ex`, y no abras un proyecto Mix.

## Qué te toca

La criba de Eratóstenes, en funciones puras. Sin procesos, sin `spawn`, sin `send` y sin `receive`.

La función pública es `Algebra.primes_between/2`. Recibe dos enteros, `a` y `b`, y regresa los primos del intervalo cerrado `[a, b]`, de menor a mayor.

Emiliano la va a llamar desde cada trabajador. El intervalo a veces no empieza en 2. Por ejemplo, un trabajador puede pedir los primos de 21 a 30. Tu función tiene que servir para cualquier `[a, b]`, no solo para `[1, n]`.

## Formato de los nombres

Escríbelos tal cual. Elixir distingue mayúsculas.

| Qué | Cómo se escribe |
|---|---|
| Archivo | `algebra.ex` |
| Módulo | `Algebra` |
| Función pública | `primes_between` |
| Primer argumento | `a` (entero, inicio del intervalo, incluido) |
| Segundo argumento | `b` (entero, fin del intervalo, incluido) |
| Resultado | lista de enteros, de menor a mayor, o `[]` |
| Variables internas | snake_case, en español: `desde`, `limite`, `candidato` |
| Funciones privadas | las nombras tú, en snake_case, con `defp` |
| Documentación | `@moduledoc` en el módulo y `@doc` en `primes_between` |

La llamada que el resto del equipo ya tiene acordada es `Algebra.primes_between(a, b)`. No la renombres a `primos`, `sieve` ni `criba`.

`1` no es primo. Si `a` es mayor que `b`, o si en el intervalo no hay primos, regresas lista vacía.

## Paso a paso

1. Crea `algebra.ex` y dentro el módulo `Algebra`. En el `@moduledoc` pon que es la criba sobre un intervalo cerrado y que el autor eres Emilio.

2. Declara `primes_between` con exactamente dos parámetros, `a` y `b`. Documenta con `@doc` que regresa los primos de `[a, b]` ordenados.

3. Resuelve primero los casos vacíos, en una cláusula aparte:
   - `a` o `b` no son enteros
   - `a` es mayor que `b`
   - `b` es menor que 2  
   En esos casos regresa `[]`.

4. En el caso normal, el límite izquierdo real es el mayor entre `a` y `2`. Así, si el intervalo empieza en 1, el 1 no entra a la lista.

5. Calcula la raíz entera de `b`. `:math.sqrt` regresa un flotante; hay que quedarse con la parte entera y revisar que no se haya quedado una unidad abajo o arriba por el redondeo. Todo compuesto entre `a` y `b` tiene un factor primo menor o igual que esa raíz. Esos primos chicos se calculan aquí mismo, dentro de `Algebra`. Ningún otro módulo te los va a pasar.

6. Saca los primos desde 2 hasta esa raíz con la criba clásica del PDF, en recursión:
   - si la raíz es menor que 2, no hay primos base (pasa cuando `b` es 2 o 3, y esos números sí son primos)
   - si la lista está vacía, terminaste
   - si no, la cabeza es primo: consérvala y quítale al resto sus múltiplos  
   Cuidado con los rangos de Elixir: si armas un rango cuyo fin es menor que el inicio, en Elixir 1.19 camina hacia atrás. Si la raíz es menor que 2, no armes ese rango; regresa lista vacía directo.

7. Parte de los enteros que van desde ese límite izquierdo hasta `b`. Por cada primo de la raíz, tacha sus múltiplos dentro de esa lista. Si el primo mismo está en la lista, no lo borres: él sí se queda.

8. Lo que sobre es el resultado. Si recorriste la lista de menor a mayor y solo quitaste elementos, ya queda ordenada. No hace falta un proceso que la ordene.

9. Comenta cada función privada con una línea de qué hace. El lineamiento de la práctica pide el código documentado.

## Cómo saber que ya quedó

Prueba solo este archivo, en IEx o con un script que no vas a entregar. Estas salidas son las del PDF y del contrato del equipo:

| Llamada | Tiene que regresar |
|---|---|
| `primes_between(1, 20)` | `[2, 3, 5, 7, 11, 13, 17, 19]` |
| `primes_between(11, 20)` | `[11, 13, 17, 19]` |
| `primes_between(21, 30)` | `[23, 29]` |
| `primes_between(31, 40)` | `[31, 37]` |
| `primes_between(1, 40)` | `[2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37]` |
| `primes_between(1, 1)` | `[]` |
| `primes_between(2, 2)` | `[2]` |
| `primes_between(3, 3)` | `[3]` |
| `primes_between(8, 10)` | `[]` |
| `primes_between(4, 4)` | `[]` |
| `primes_between(8, 7)` | `[]` |

## Terminado cuando

Esas once llamadas coinciden y el único archivo que vas a subir es `algebra.ex`.
