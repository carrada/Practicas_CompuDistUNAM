# Emiliano — `worker.ex`

Práctica 1. Computación Distribuida 2027-1.

Esta guía no trae el código. Si la lees tú, sigue los pasos y escribe el archivo. Si se la pasas a una IA, pídele que implemente solo `worker.ex`, con estos nombres, y que no escriba la criba ni el coordinador.

## Entrega

Un solo archivo: `worker.ex`.  
Módulo: `Worker`.  
No entregues el archivo de prueba, no crees `algebra.ex` ni `server.ex`.

## Qué te toca

Un proceso trabajador. Recibe un intervalo, pide los primos a `Algebra.primes_between/2` y le contesta al coordinador con un mensaje.

Omar es quien arranca el proceso. Tú no llamas a `spawn` desde dentro de `loop`. Tú escribes la función que el `spawn` va a ejecutar.

No implementes la criba. No partas el intervalo. No sepas cuántos trabajadores hay ni cuál es `n`. El trabajador solo ve el intervalo que le llegó. Así se puede cambiar el número de trabajadores sin tocar este archivo.

## Formato de los nombres

| Qué | Cómo se escribe |
|---|---|
| Archivo | `worker.ex` |
| Módulo | `Worker` |
| Función pública | `loop` |
| Aridad | cero argumentos. No es `loop(id, a, b)` |
| Cómo lo arranca Omar | `spawn` de 3 argumentos: el módulo `Worker`, el átomo `loop`, y una lista vacía de argumentos |
| Documentación | `@moduledoc` en el módulo y `@doc` en `loop`. Autor: Emiliano |

Mensaje que recibes. Una tupla de cinco campos, en este orden:

| Posición | Nombre | Tipo |
|---|---|---|
| 1 | átomo `trabajo` | se escribe `:trabajo` |
| 2 | `id` | entero, empieza en 1 |
| 3 | `a` | entero, inicio incluido |
| 4 | `b` | entero, fin incluido |
| 5 | `pid_coordinador` | el pid de Omar, no el tuyo |

En el `receive` tiene que verse así, con esos nombres y ese orden:

`{:trabajo, id, a, b, pid_coordinador}`

Mensaje que contestas. Una tupla de tres campos, en este orden:

| Posición | Nombre | Tipo |
|---|---|---|
| 1 | átomo `resultado` | se escribe `:resultado` |
| 2 | `id` | el mismo entero que llegó |
| 3 | `primos` | lista de enteros, ordenada, solo primos de `[a, b]` |

Se escribe `{:resultado, id, primos}`.

El `send` va dirigido a `pid_coordinador`. Si usas `self()` aquí, el mensaje te llega a ti y Omar se queda esperando hasta el timeout.

## Paso a paso

1. Crea `worker.ex` con el módulo `Worker` y documenta que es el proceso trabajador.

2. Escribe `loop` sin parámetros.

3. Dentro, un `receive` con una sola cláusula, la tupla de cinco campos de arriba. No agregues una cláusula que se trague cualquier mensaje: un mensaje mal formado se quedaría sin contestar y el coordinador lo notaría.

4. Calcula los primos con la llamada ya fijada: `Algebra.primes_between(a, b)`. Esa función la escribe Emilio. Tú no la copies dentro de `worker.ex`. Si `a` es mayor que `b`, esa función regresa `[]`; no hace falta otro cálculo.

5. Manda `{:resultado, id, primos}` al `pid_coordinador`.

6. Ahí termina el proceso. No dejes un ciclo infinito ni vuelvas a llamar a `loop`. Cada trabajador hace un solo intervalo.

7. Documenta `loop` con `@doc`: espera un trabajo, calcula los primos del intervalo y responde al coordinador.

## Cómo probarlo sin Emilio

En otro archivo, que no se entrega, escribe un módulo `Algebra` temporal con la misma función `primes_between/2`, que sepa regresar primos de un rango chico. Compila ese archivo antes de probar `worker.ex`. En `worker.ex` la llamada se queda como `Algebra.primes_between(a, b)`.

Prueba de aceptación, hecha desde el proceso en el que estás (su pid es el "coordinador" de la prueba):

1. Arranca `loop` con `spawn` de tres argumentos, como va a hacer Omar.
2. Mándale `{:trabajo, 1, 1, 10, self()}`.
3. Espera, con `receive` y un `after` de un par de segundos, el mensaje `{:resultado, 1, lista}`.
4. `lista` tiene que ser `[2, 3, 5, 7]`.

Segunda prueba: mándale `{:trabajo, 2, 8, 7, self()}`. El intervalo está al revés. Tiene que llegar `{:resultado, 2, []}`.

Si pasa el `after`, el `send` no salió, salió hacia otro pid, o el patrón del `receive` no coincide con la tupla.

## Terminado cuando

Las dos pruebas contestan con esas tuplas y el único archivo de tu entrega es `worker.ex`.
