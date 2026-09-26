# Erick — `benchmark.ex`

Práctica 1. Computación Distribuida 2027-1.

Esta guía no trae el código. Si la lees tú, sigue los pasos y escribe el archivo. Si se la pasas a una IA, pídele que implemente solo `benchmark.ex`. No reescribas `Server`, `Worker` ni `Algebra`.

## Entrega

Un solo archivo: `benchmark.ex`.  
Módulo: `Benchmark`.  
La tabla con los tiempos reales de la criba sale el día de la integración, llamando a tu `run` sin modificarlo. Hoy puedes terminar el medidor con un `Server` de mentira.

## Qué te toca

Medir `Server.start/2` y escribir la tabla de la práctica, en milisegundos.

No partes intervalos, no cribas y no creas trabajadores. Solo llamas a `Server.start(k, n)`.

## Formato de los nombres

| Qué | Cómo se escribe |
|---|---|
| Archivo | `benchmark.ex` |
| Módulo | `Benchmark` |
| Función pública | `run` |
| Aridad | cero. Se llama `Benchmark.run()` |
| Valor de retorno | el átomo `:ok` |
| Trabajadores | la lista `[1, 2, 4, 8, 16]`, en ese orden, de izquierda a derecha en la tabla |
| Límites | la lista `[10000, 100000, 500000]`, en ese orden, de arriba hacia abajo |
| Argumentos de la llamada | primero `k` (trabajadores), después `n` (límite): `Server.start(k, n)` |
| Unidad | milisegundos enteros |
| Documentación | `@moduledoc` y `@doc` en `run`. Autor: Erick |

Esas dos listas ya están decididas. No las cambies y no le preguntes al equipo qué `n` usar.

Los atributos de módulo, si los usas para no repetir las listas, se escriben con `@` y un nombre en snake_case, por ejemplo `@trabajadores` y `@limites`.

## La tabla

Quince corridas: cinco cantidades de trabajadores por tres valores de `n`. Una corrida por celda. Si repites cada celda tres veces y publicas la mediana, escríbelo en el encabezado; con una vez ya se cumple el PDF.

Cada celda es el tiempo de esa configuración, en milisegundos enteros. Se obtiene midiendo la llamada con `:timer.tc` y dividiendo los microsegundos entre `1000` con división entera, no con división de flotantes.

El encabezado y las filas van alineados a la derecha, cada columna a 8 caracteres. Con unos tiempos de ejemplo se vería así (los números de las celdas son ficticios; los tuyos salen de la medición):

```text
       N       1       2       4       8      16
   10000      12       7       5       4       6
  100000
  500000
```

`run` imprime la tabla y regresa `:ok`. No regreses la tabla como lista.

## Paso a paso

1. Crea `benchmark.ex` con el módulo `Benchmark`. Documenta que mide `Server.start/2` y escribe los tiempos en milisegundos.

2. Deja fijos, en ese orden, los trabajadores `1, 2, 4, 8, 16` y los límites `10000, 100000, 500000`.

3. Escribe una función privada que reciba `k` y `n`, llame a `Server.start(k, n)` dentro de `:timer.tc`, se quede con los microsegundos (el otro valor de esa tupla es la lista de primos; no la imprimas en cada celda) y los convierta a milisegundos enteros.

4. Escribe `run` sin argumentos. Primero imprime el encabezado: la letra `N` y después las cinco cantidades de trabajadores, cada una alineada a 8 caracteres por la derecha.

5. Por cada `n`, mide los cinco `k` y arma una fila: el `n` alineado a 8 caracteres y después los cinco tiempos, también a 8. Imprímela.

6. Al terminar las tres filas, regresa `:ok`.

7. No modifiques los otros módulos. Si `Server.start` cambia de nombre o de orden de argumentos, la integración se rompe. El orden es `(k, n)`, no `(n, k)`.

## Cómo probarlo sin Omar

En otro archivo, que no se entrega, escribe un módulo `Server` temporal con `start/2`. Que espere un poco, más mientras más grande sea `k`, y que regrese una lista fija, por ejemplo `[2, 3, 5]`.

Compila ese sustituto y luego `benchmark.ex`. Llama `Benchmark.run()`. Tiene que:

- imprimir 1 encabezado y 3 filas
- mostrar las columnas 1, 2, 4, 8 y 16
- mostrar las filas 10000, 100000 y 500000
- cambiar el número de una columna a otra, porque la espera depende de `k`
- regresar `:ok`

Esos tiempos del sustituto no se entregan. Sirven para ver que el medidor y el formato están bien.

La tabla que va al reporte es la que salga cuando existan `algebra.ex`, `worker.ex` y `server.ex`, compilados antes de `benchmark.ex`, y se llame `Benchmark.run()`. Ese día no reescribes este archivo.

## Terminado cuando

`Benchmark.run()` recorre las 15 configuraciones, imprime la tabla en milisegundos y regresa `:ok`, aunque sea contra el `Server` temporal.
