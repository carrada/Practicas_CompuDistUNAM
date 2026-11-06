# Emiliano — `reglas.ex`

Práctica 3. Computación Distribuida 2027-1. Consenso distribuido.

Esta guía no trae el código. Si la lees tú, sigue los pasos. Si se la pasas a una IA, pídele que implemente solo `practica03/reglas.ex`. No escribas procesos ni frases.

Trabajas dentro de la carpeta `practica03`. No crees este archivo en la raíz.

## Entrega

Un solo archivo: `practica03/reglas.ex`.  
Módulo: `Reglas`.

## Qué te toca

Las cuentas y el azar, en funciones puras. El líder y el participante las van a llamar por estos nombres. No imprimes y no usas `spawn`.

## Formato de los nombres

| Función | Qué regresa |
|---|---|
| `propuesta/0` | entero entre 1 y 1000, los dos incluidos |
| `falla?/0` | `true` solo si un entero al azar del 1 al 10 sale 3; si no, `false` |
| `quorum/1` | `div(n, 2) + 1` |
| `hay_consenso?/2` | `true` si el segundo argumento es mayor o igual que `quorum` del primero |
| `ordenar/1` | la lista de enteros de menor a mayor |
| `acordado/1` | el menor de la lista |

`n` es el número inicial de participantes. `validas` es cuántas propuestas sí llegaron. Los dos argumentos de `hay_consenso?` van en ese orden: primero `n`, después `validas`.

El signo de interrogación forma parte del nombre: `falla?` y `hay_consenso?`.

Documenta el módulo y cada función. Autor: Emiliano.

## Paso a paso

1. Crea el módulo `Reglas` en `practica03/reglas.ex`.

2. `propuesta/0` saca un entero al azar de 1 a 1000. Cada llamada puede dar un número distinto.

3. `falla?/0` saca un entero al azar de 1 a 10 y regresa `true` únicamente cuando ese entero es 3. Un 1, un 2 o un 4 no fallan. No cuentes fallos entre procesos: cada llamada es independiente y no promete un fallo cada diez usos.

4. `quorum/1` es la división entera de `n` entre 2, más 1. Con 5 tiene que dar 3. No uses división con decimales: 5 entre 2 no es 2.5 dentro de esta cuenta, es 2, y 2 + 1 es 3. El PDF dice que con cinco procesos hacen falta al menos tres propuestas.

5. `hay_consenso?(n, validas)` compara `validas` con `quorum(n)`. Igual también alcanza. Con 5 procesos y 2 propuestas el resultado es `false`. Con 5 y 3 es `true`.

6. `ordenar/1` no modifica la lista original: regresa otra, de menor a mayor. `[410, 57, 95]` queda `[57, 95, 410]`.

7. `acordado/1` es el primer valor de esa lista ya ordenada, el menor. El valor del consenso es ese mínimo, no el promedio ni el mayor.

## Cómo probarlo solo

En IEx, compilando solo este archivo:

- `Reglas.quorum(5)` es 3, `Reglas.quorum(4)` es 3, `Reglas.quorum(1)` es 1.
- `Reglas.hay_consenso?(5, 2)` es `false` y `Reglas.hay_consenso?(5, 5)` es `true`.
- `Reglas.acordado(Reglas.ordenar([410, 57, 95]))` es 57.
- Varias llamadas a `Reglas.propuesta()` caen entre 1 y 1000.

## Terminado cuando

Esas comprobaciones pasan y el único archivo de tu entrega es `practica03/reglas.ex`.
