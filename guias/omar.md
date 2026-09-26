# Omar — `server.ex`

Práctica 1. Computación Distribuida 2027-1.

Esta guía no trae el código. Si la lees tú, sigue los pasos y escribe el archivo. Si se la pasas a una IA, pídele que implemente solo `server.ex`, con estos nombres, y que no escriba la criba ni el `receive` de adentro del trabajador.

## Entrega

Un solo archivo: `server.ex`.  
Módulo: `Server`.  
No entregues el trabajador falso, no crees `algebra.ex`, `worker.ex` ni `benchmark.ex`.

## Qué te toca

El coordinador. Parte `[1, n]` en bloques, crea los trabajadores, les manda su intervalo, junta las respuestas y regresa una sola lista ordenada.

No mides el tiempo. No implementas la criba. No escribes lo que el trabajador hace al recibir el mensaje: eso es `worker.ex`. Tú solo lo arrancas y le hablas.

El número de trabajadores entra nada más como el argumento `k`. No dejes cuatro procesos escritos a mano.

## Formato de los nombres

| Qué | Cómo se escribe |
|---|---|
| Archivo | `server.ex` |
| Módulo | `Server` |
| Partir el rango | `intervalos`, dos argumentos: `n` y `k` |
| Buscar los primos | `start`, dos argumentos: `k` y `n` |
| `n` | entero `>= 1`, límite superior. Se buscan primos `<= n` |
| `k` | entero `>= 1`, número de trabajadores |
| Cada bloque | tupla de tres campos: `{id, a, b}` |
| `id` | entero que empieza en 1 y va en orden |
| `a`, `b` | enteros, intervalo cerrado. Si el bloque está vacío, `a` es mayor que `b` |
| Pid del coordinador | guárdalo en una variable `yo` con `self()` en el proceso de `start`, antes de crear trabajadores |
| Documentación | `@moduledoc`, y `@doc` en `intervalos` y en `start`. Autor: Omar |

`intervalos(n, k)` regresa una lista de tuplas `{id, a, b}`. Es una función pura: no crea procesos. Sirve para probar el reparto sin Emiliano.

`start(k, n)` regresa la lista de primos, no una tupla y no un átomo `:ok`.

Mensaje que mandas a cada trabajador, cinco campos, en este orden:

`{:trabajo, id, a, b, yo}`

El átomo es `:trabajo`. El último campo es el pid del coordinador, la variable `yo`. Dentro del trabajador, `self()` ya es otro proceso; por eso el pid se manda en el mensaje y se captura en `start`.

Mensaje que esperas, tres campos:

`{:resultado, id, primos}`

El átomo es `:resultado`. `primos` es la lista de ese trabajador. Los mensajes pueden llegar en cualquier orden. No armes la lista final según quién contesta primero.

## Cómo se parte `[1, n]`

Los bloques cubren desde 1 hasta `n`, sin huecos y sin traslapes.

- `base` es la división entera de `n` entre `k`
- `resto` es el residuo de `n` entre `k`
- Los primeros `resto` bloques miden `base + 1`
- Los demás miden `base`
- El `id` del primero es 1
- Si un bloque mide 0 (pasa cuando hay más trabajadores que números), ese trabajador recibe un intervalo con `a` mayor que `b` y debe poder contestar lista vacía. Tú igual lo creas y lo cuentas entre los `k` mensajes

Ejemplos que tu `intervalos/2` tiene que cumplir:

| Llamada | Lista |
|---|---|
| `intervalos(40, 4)` | `[{1, 1, 10}, {2, 11, 20}, {3, 21, 30}, {4, 31, 40}]` |
| `intervalos(20, 3)` | `[{1, 1, 7}, {2, 8, 14}, {3, 15, 20}]` |
| `intervalos(5, 2)` | `[{1, 1, 3}, {2, 4, 5}]` |
| `intervalos(5, 8)` | `[{1, 1, 1}, {2, 2, 2}, {3, 3, 3}, {4, 4, 4}, {5, 5, 5}, {6, 6, 5}, {7, 6, 5}, {8, 6, 5}]` |

En el último, los tres bloques finales tienen el inicio mayor que el fin. Están vacíos. Los cinco primeros cubren el 1, el 2, el 3, el 4 y el 5.

## Paso a paso

1. Crea `server.ex` con el módulo `Server`.

2. Escribe `intervalos(n, k)` con la regla de arriba. Conviene una función privada recursiva que lleve el inicio actual, el `id` actual y cuántos bloques faltan. Cuando el `id` pasa de `k`, regresas lista vacía. Cada paso agrega una tupla `{id, a, b}` y avanza el inicio solo si el tamaño del bloque fue mayor que 0.

3. Prueba `intervalos/2` contra la tabla de arriba antes de meter procesos. Si esta función falla, `start` también va a fallar.

4. Escribe `start(k, n)`. Guarda `self()` en `yo`.

5. Recorre la lista de `intervalos(n, k)`. Por cada `{id, a, b}`:
   - crea el proceso con `spawn` de tres argumentos: módulo `Worker`, átomo `loop`, lista de argumentos vacía
   - mándale `{:trabajo, id, a, b, yo}`

6. Recibe exactamente `k` mensajes `{:resultado, id, primos}`. Lleva la cuenta de cuántos faltan. El `id` llega en el mensaje por si quieres reconocerlo; para armar la lista final no hace falta usarlo, porque al final se ordena todo. Si no usas esa variable, nómbrala con guion bajo al inicio para que el compilador no avise.

7. En ese `receive` pon `after` de `60_000` milisegundos. Si se cumple, termina con un error claro que diga cuántos trabajadores faltaron. Un trabajador lento retrasa el resultado, porque esperas a los `k`, pero el programa no se queda colgado para siempre.

8. Junta las listas (cada mensaje trae una lista, así que tienes una lista de listas), aplánalas y ordénalas de menor a mayor. Ese es el valor de retorno de `start`.

9. Documenta las dos funciones públicas.

## Cómo probarlo sin Emiliano

En otro archivo, que no se entrega, escribe un `Worker` temporal. Su `loop` recibe `{:trabajo, id, a, b, de}` y contesta `{:resultado, id, [id]}` cuando `a` es menor o igual que `b`, y `{:resultado, id, []}` cuando el intervalo está vacío.

Con ese sustituto, `Server.start(4, 40)` regresa `[1, 2, 3, 4]`. No es la lista de primos: es la prueba de que creaste cuatro procesos, repartiste y ordenaste las respuestas aunque no lleguen en orden.

Prueba también `start` con más trabajadores que números, por ejemplo `k = 8` y `n = 5`. Tiene que terminar. Los bloques vacíos también cuentan como respuesta.

La lista real de primos, `Server.start(4, 40)` igual a `[2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37]`, se comprueba el día en que estén `algebra.ex` y `worker.ex`. No la necesitas para cerrar tu parte.

## Terminado cuando

`intervalos/2` coincide con los cuatro ejemplos y, con el trabajador falso, `start(4, 40)` regresa `[1, 2, 3, 4]` sin quedarse bloqueado.
