# Emilio — `palillo.ex`

Práctica 2. Computación Distribuida 2027-1. La cena de los filósofos.

Esta guía no trae el código. Si la lees tú, sigue los pasos y escribe el archivo. Si se la pasas a una IA, pídele que implemente solo `palillo.ex`, con estos nombres, y que no escriba al filósofo, la mesa ni la bitácora.

## Entrega

Un solo archivo: `palillo.ex`.  
Módulo: `Palillo`.  
No crees `filosofo.ex`, `mesa.ex` ni `bitacora.ex`.

## Qué te toca

El proceso de un palillo. Administra su estado, LIBRE u OCUPADO, y se lo presta a un solo filósofo a la vez. El estado vive dentro del proceso. No uses una variable global, un Agent ni un GenServer.

No imprimes nada. Quien escribe las frases es Erick. Tú solo contestas mensajes.

## Formato de los nombres

| Qué | Cómo se escribe |
|---|---|
| Archivo | `palillo.ex` |
| Módulo | `Palillo` |
| Función pública | `loop` |
| Argumento | `id`, entero del 1 al 5, el número de este palillo |
| Cómo lo arranca Omar | `spawn(Palillo, :loop, [id])` |
| Estado libre | el átomo `:libre` |
| Estado ocupado | el átomo `:ocupado` |
| Documentación | `@moduledoc` y `@doc` en `loop`. Autor: Emilio |

Mensaje que recibes para prestarlo. Tres campos, en este orden:

`{:solicitar, pid_filosofo, id_filosofo}`

Mensaje que contestas cuando sí se lo das. Dos campos:

`{:conceder, id}`

`id` es el número de este palillo, el mismo con el que naciste. El `send` va a `pid_filosofo`.

Mensaje que recibes para soltarlo:

`{:liberar, pid_filosofo, id_filosofo}`

## Paso a paso

1. Crea `palillo.ex` con el módulo `Palillo`. Documenta que es el proceso de un palillo y que el autor eres Emilio.

2. `loop/1` recibe el `id` y arranca el proceso en `:libre`, sin dueño y con la cola de espera vacía. La cola es una lista de tuplas `{pid_filosofo, id_filosofo}`.

3. A partir de ahí el proceso no se muere. Después de atender un mensaje, vuelve a esperar con el estado nuevo. Un palillo atiende a muchos filósofos a lo largo de la cena.

4. Si llega `{:solicitar, pid_filosofo, id_filosofo}` y estás en `:libre`, pasa a `:ocupado`, guarda a ese filósofo como dueño y mándale `{:conceder, id}`.

5. Si llega `solicitar` y ya estás en `:ocupado`, no contestes todavía. Mete esa petición al final de la cola. El filósofo se queda esperando su `:conceder`; no le toca a ti volver a pedírselo.

6. Si llega `{:liberar, pid_filosofo, id_filosofo}` y ese `pid_filosofo` es el dueño:
   - si la cola está vacía, vuelves a `:libre` y olvidas al dueño
   - si hay alguien en la cola, lo sacas del frente, ese pasa a ser el dueño, sigues en `:ocupado` y le mandas `{:conceder, id}`

7. Si el `liberar` no viene del dueño, no cambies el estado ni la cola. Sigue esperando.

8. No hace falta conocer a los cinco filósofos ni a la bitácora. Este proceso solo ve los mensajes que le llegan.

## Cómo probarlo solo

En un archivo que no vas a entregar, abre dos procesos de prueba además del palillo 1.

1. Arranca `spawn(Palillo, :loop, [1])`.
2. Desde el primer proceso de prueba manda `{:solicitar, pid_del_primero, 1}`. Tiene que llegar `{:conceder, 1}` a ese pid.
3. Desde el segundo, manda otro `solicitar` con su propio pid. No debe llegarle `:conceder` todavía.
4. El primero manda `{:liberar, pid_del_primero, 1}`. Ahora el segundo sí recibe `{:conceder, 1}`.
5. Un `liberar` mandado por un pid que no es el dueño deja al palillo como estaba.

## Terminado cuando

Esas cinco comprobaciones se cumplen y el único archivo de tu entrega es `palillo.ex`.
