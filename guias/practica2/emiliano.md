# Emiliano — `filosofo.ex`

Práctica 2. Computación Distribuida 2027-1. La cena de los filósofos.

Esta guía no trae el código. Si la lees tú, sigue los pasos y escribe el archivo. Si se la pasas a una IA, pídele que implemente solo `filosofo.ex`. No escribas el palillo, la mesa ni la bitácora.

## Entrega

Un solo archivo: `filosofo.ex`.  
Módulo: `Filosofo`.  
No crees `palillo.ex`, `mesa.ex` ni `bitacora.ex`.

## Qué te toca

Un filósofo. Piensa, tiene hambre, consigue sus dos palillos, come y los suelta. Lo repite tres veces. No crea los palillos: Omar te pasa sus pid. No imprimes las frases: le avisas a la bitácora con un evento y Erick escribe el texto.

No empieces a comer si te falta un palillo. No pidas los dos a la vez: primero el de número menor y, solo cuando ese ya te lo concedieron, el de número mayor. Eso evita que los cinco se queden cada uno con un palillo y ninguno pueda comer.

## Formato de los nombres

| Qué | Cómo se escribe |
|---|---|
| Archivo | `filosofo.ex` |
| Módulo | `Filosofo` |
| Función pública | `loop` |
| Aridad | 5 |
| Documentación | `@moduledoc` y `@doc` en `loop`. Autor: Emiliano |

Los cinco argumentos, en este orden:

| Posición | Nombre | Qué es |
|---|---|---|
| 1 | `id` | entero del 1 al 5, tu número |
| 2 | `palillo_a` | tupla `{id_palillo, pid}` |
| 3 | `palillo_b` | tupla `{id_palillo, pid}` |
| 4 | `pid_bitacora` | pid del proceso de Erick |
| 5 | `pid_mesa` | pid del proceso de Omar, el que te creó |

`palillo_a` y `palillo_b` llegan en el orden del PDF, que es el orden de la frase "solicita". No es el orden en el que pides. Para el filósofo 1 llegan `{5, pid}` y `{1, pid}`. Tú pides primero el 1 y después el 5.

Cómo te arranca Omar:

`spawn(Filosofo, :loop, [id, palillo_a, palillo_b, pid_bitacora, pid_mesa])`

Mensaje al palillo para pedirlo:

`{:solicitar, self(), id}`

El primer campo después del átomo es tu pid, no el del palillo. El `send` va al pid que venía dentro de la tupla del palillo.

Respuesta que esperas:

`{:conceder, id_palillo}`

`id_palillo` tiene que ser el que acabas de pedir. Si llega otro, no lo tomes como tuyo.

Mensaje al palillo para soltarlo:

`{:liberar, self(), id}`

Aviso a la bitácora:

`{:evento, id, dato}`

`dato` es exactamente uno de estos:

| Momento | `dato` |
|---|---|
| Empiezas a pensar | `:pensando` |
| Ya quieres comer | `:hambriento` |
| Vas a buscar los dos | `{:solicita, id_de_palillo_a, id_de_palillo_b}` |
| Ya mandaste el solicitar y aún no te contestan | `{:esperando, id_palillo}` |
| Te llegó el conceder | `{:obtuvo, id_palillo}` |
| Ya tienes los dos | `:comiendo` |
| Dejas de comer | `:termino` |
| Soltaste uno | `{:libero, id_palillo}` |

Al terminar los tres ciclos, a la mesa:

`{:listo, id}`

## Paso a paso

1. Crea `filosofo.ex` con el módulo `Filosofo` y documenta `loop/5`.

2. Repite el ciclo de abajo tres veces. Lleva la cuenta con un argumento o con una recursión. No uses un ciclo infinito.

3. Manda `{:evento, id, :pensando}` a `pid_bitacora`. Espera entre 100 y 300 milisegundos. `:rand.uniform(201) + 99` cae en ese rango.

4. Manda `:hambriento`.

5. Manda `{:solicita, id_a, id_b}` con los ids en el orden en que te los pasaron, no ordenados. El filósofo 1 solicita 5 y 1.

6. Ordena tus dos palillos por `id_palillo`, de menor a mayor. El resto del ciclo usa ese orden.

7. Para el primero de esa lista: mándale `{:solicitar, self(), id}`, avisa `{:esperando, id_palillo}`, y quédate en `receive` hasta ver `{:conceder, id_palillo}` con ese mismo número. Entonces avisa `{:obtuvo, id_palillo}`.

8. Repite el paso 7 con el segundo palillo. No lo pidas antes de tener el `:conceder` del primero.

9. Solo aquí mandas `:comiendo`. Espera otros 100 a 300 milisegundos.

10. Manda `:termino`.

11. Suelta los dos palillos. Por cada uno: `{:liberar, self(), id}` a su pid, y `{:evento, id, {:libero, id_palillo}}` a la bitácora.

12. Vuelve al paso 3 hasta completar tres cenas.

13. Manda `{:listo, id}` a `pid_mesa` y deja morir el proceso. No sigas esperando mensajes.

## Cómo probarlo sin los demás

En un archivo que no se entrega, crea dos procesos que hagan de palillo: al recibir `{:solicitar, pid, _id_filosofo}` contestan enseguida `{:conceder, su_id}`. Crea otro que haga de bitácora y de mesa: guarda los `{:evento, _, dato}` y el `{:listo, id}`.

Arranca tu `loop` como el filósofo 1, con palillos `{5, pid5}` y `{1, pid1}`.

En los eventos de un ciclo, el dato `:comiendo` va después de `{:obtuvo, 1}` y de `{:obtuvo, 5}`. `{:solicita, 5, 1}` usa el orden del PDF aunque hayas pedido primero el 1. `{:esperando, 1}` va antes de `{:esperando, 5}`.

Cuando hayan pasado tres ciclos, a quien pasó como `pid_mesa` le llega `{:listo, 1}` y no llega un cuarto `:pensando`.

## Terminado cuando

Esa secuencia se cumple y el único archivo de tu entrega es `filosofo.ex`.
