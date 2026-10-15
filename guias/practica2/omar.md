# Omar — `mesa.ex`

Práctica 2. Computación Distribuida 2027-1. La cena de los filósofos.

Esta guía no trae el código. Si la lees tú, sigue los pasos y escribe el archivo. Si se la pasas a una IA, pídele que implemente solo `mesa.ex`. No escribas cómo se presta un palillo, ni el ciclo del filósofo, ni las frases de la salida.

## Entrega

Un solo archivo: `mesa.ex`.  
Módulo: `Mesa`.  
No crees `palillo.ex`, `filosofo.ex` ni `bitacora.ex`.

## Qué te toca

Armar la mesa y encenderla. Creas los cinco palillos, los cinco filósofos y la bitácora, y les pasas los pid que el contrato ya fijó. Tú no decides cuándo un palillo está libre ni cuándo un filósofo come.

También dejas `pares/0`, una función pura, para poder comprobar el cableado sin levantar procesos.

## Formato de los nombres

| Qué | Cómo se escribe |
|---|---|
| Archivo | `mesa.ex` |
| Módulo | `Mesa` |
| Pares | `pares/0`, sin argumentos |
| Arranque | `iniciar/0`, sin argumentos |
| Lo que regresa `iniciar` | el átomo `:ok` |
| Documentación | `@moduledoc`, y `@doc` en `pares` y en `iniciar`. Autor: Omar |

`pares/0` regresa esta lista, en este orden. Cada tupla es `{id_filosofo, id_palillo_a, id_palillo_b}`:

| Filósofo | Palillo a | Palillo b |
|---|---|---|
| 1 | 5 | 1 |
| 2 | 1 | 2 |
| 3 | 2 | 3 |
| 4 | 3 | 4 |
| 5 | 4 | 5 |

O sea: `[{1, 5, 1}, {2, 1, 2}, {3, 2, 3}, {4, 3, 4}, {5, 4, 5}]`.

Procesos que creas, con estos argumentos y ningún otro:

| Proceso | Arranque |
|---|---|
| Bitácora | `spawn(Bitacora, :loop, [])` |
| Palillo | `spawn(Palillo, :loop, [id])`, con `id` de 1 a 5 |
| Filósofo | `spawn(Filosofo, :loop, [id, palillo_a, palillo_b, pid_bitacora, pid_mesa])` |

`palillo_a` es la tupla `{id_palillo_a, pid_de_ese_palillo}`.  
`palillo_b` es `{id_palillo_b, pid_de_ese_palillo}`.  
`pid_mesa` eres tú: el `self()` del proceso que ejecuta `iniciar`, guardado antes de crear a los filósofos.

Mensaje que esperas de cada filósofo, cuando ya cenó tres veces:

`{:listo, id_filosofo}`

Tienen que llegar cinco. El `id_filosofo` viene en el mensaje por si quieres reconocerlo. Para saber que ya acabaron basta contar cinco. Si no usas el id, nómbralo con guion bajo al inicio.

## Paso a paso

1. Crea `mesa.ex` y documenta el módulo.

2. Escribe `pares/0` con la lista de arriba, tal cual. Pruébala antes de crear procesos.

3. Escribe `iniciar/0`. Guarda `self()` en una variable, por ejemplo `yo`. Dentro de un `spawn`, `self()` ya es otro proceso, así que el pid de la mesa se captura aquí.

4. Crea la bitácora y guarda su pid.

5. Crea los cinco palillos. Guarda un mapa de número de palillo a pid, para poder armar las tuplas del filósofo. Las llaves del mapa son los enteros 1, 2, 3, 4 y 5.

6. Recorre `pares()`. Por cada `{id, id_a, id_b}` crea un filósofo con `{id_a, pid_a}`, `{id_b, pid_b}`, el pid de la bitácora y `yo`.

7. Recibe exactamente cinco `{:listo, id_filosofo}`. En el `receive` pon `after` de `60_000` milisegundos. Si se cumple, termina con un error que diga cuántos filósofos faltaron.

8. Regresa `:ok`. No imprimas la bitácora ni esperes más mensajes.

## Cómo probarlo sin los demás

En un archivo que no se entrega:

- Un `Palillo.loop/1` que no haga nada, o que ignore los mensajes.
- Un `Bitacora.loop/0` igual de vacío.
- Un `Filosofo.loop/5` que, al arrancar, mande `{:listo, id}` a `pid_mesa` y termine.

Con esos sustitutos, `Mesa.iniciar()` regresa `:ok`. Si tu `receive` no reconoce la tupla, se va a los 60 segundos.

`Mesa.pares()` tiene que ser exactamente la lista de cinco tuplas. El filósofo 1 queda atado a los palillos 5 y 1, en ese orden dentro de la tupla.

La cena de verdad, con hambre y palillos, se ve el día en que existan los otros tres archivos. Ese día no reescribes `mesa.ex`.

## Terminado cuando

`pares/0` coincide con la tabla y, con el filósofo de mentira, `iniciar/0` regresa `:ok`.
