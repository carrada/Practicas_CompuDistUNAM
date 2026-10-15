# Erick — `bitacora.ex`

Práctica 2. Computación Distribuida 2027-1. La cena de los filósofos.

Esta guía no trae el código. Si la lees tú, sigue los pasos y escribe el archivo. Si se la pasas a una IA, pídele que implemente solo `bitacora.ex`. No pidas palillos ni crees filósofos.

## Entrega

Un solo archivo: `bitacora.ex`.  
Módulo: `Bitacora`.  
No crees `palillo.ex`, `filosofo.ex` ni `mesa.ex`.

## Qué te toca

Traducir los eventos a las frases del PDF, y vigilar que dos filósofos vecinos no figuren comiendo al mismo tiempo. Los demás no arman el texto: te mandan un dato y tú imprimes la línea.

## Formato de los nombres

| Qué | Cómo se escribe |
|---|---|
| Archivo | `bitacora.ex` |
| Módulo | `Bitacora` |
| Función pública | `loop` |
| Aridad de la función pública | cero. Omar hace `spawn(Bitacora, :loop, [])` |
| Mensaje que recibes | `{:evento, id_filosofo, dato}` |
| Documentación | `@moduledoc` y `@doc` en `loop`. Autor: Erick |

`id_filosofo` es un entero del 1 al 5. `dato` llega ya armado por Emiliano. Tú no lo calculas.

Frases, con punto final y con acento en Filósofo, está, terminó y liberó:

| `dato` | Línea |
|---|---|
| `:pensando` | `Filósofo N está pensando.` |
| `:hambriento` | `Filósofo N tiene hambre.` |
| `{:solicita, a, b}` | `Filósofo N solicita los palillos A y B.` |
| `{:esperando, p}` | `Filósofo N está esperando el palillo P.` |
| `{:obtuvo, p}` | `Filósofo N obtuvo el palillo P.` |
| `:comiendo` | `Filósofo N está comiendo.` |
| `:termino` | `Filósofo N terminó de comer.` |
| `{:libero, p}` | `Filósofo N liberó el palillo P.` |

N, A, B y P son los enteros que venían en el mensaje. En `solicita` se imprimen en el orden en que llegaron, sin ordenarlos.

Si al entrar alguien a comer un vecino ya estaba comiendo, una línea extra:

`ERROR: filósofos contiguos comiendo: X y Y.`

X es el número menor y Y el mayor.

Vecinos:

| Filósofo | Está junto a |
|---|---|
| 1 | 2 y 5 |
| 2 | 1 y 3 |
| 3 | 2 y 4 |
| 4 | 3 y 5 |
| 5 | 4 y 1 |

1 y 3 no son vecinos. 2 y 4 tampoco. 1 y 5 sí.

## Paso a paso

1. Crea `bitacora.ex`. La función pública `loop/0` empieza con nadie comiendo y se pone a esperar. El conjunto de quienes comen puede ser una lista o un `MapSet`; vive en los argumentos de una función privada, no en una variable global.

2. El proceso no termina. Después de imprimir, vuelve a esperar con el conjunto actualizado.

3. Al recibir `{:evento, id_filosofo, dato}`, escribe la frase de la tabla con `IO.puts`. Una línea por evento.

4. Si `dato` es `:comiendo`, revisa el conjunto antes de agregarlo. Si algún miembro es vecino de `id_filosofo`, imprime la línea ERROR. Luego mételo al conjunto.

5. Si `dato` es `:termino`, sácalo del conjunto. La comida acaba en ese aviso, no en el `libero`.

6. El resto de los datos solo se imprimen. No cambian el conjunto.

7. Un dato que no esté en la tabla no debe tumbar el proceso: ignóralo y sigue esperando. No hace falta imprimirlo.

## Cómo probarlo solo

Arranca `spawn(Bitacora, :loop, [])` y mándale eventos desde tu proceso. No necesitas palillos.

1. `{:evento, 1, :pensando}` imprime `Filósofo 1 está pensando.`
2. `{:evento, 1, {:solicita, 5, 1}}` imprime `Filósofo 1 solicita los palillos 5 y 1.`
3. `{:evento, 1, :comiendo}` y después `{:evento, 3, :comiendo}` no imprimen ERROR.
4. Sin haber mandado `:termino` del 1, manda `{:evento, 2, :comiendo}`. Tiene que salir `ERROR: filósofos contiguos comiendo: 1 y 2.`
5. Manda `{:evento, 1, :termino}` y otra vez `{:evento, 2, :comiendo}` no debe repetir el error por culpa del 1, porque el 1 ya no está en el conjunto. El 2 y el 3 tampoco son vecinos, así que esa segunda entrada del 2 tampoco marca error con el 3.

## Terminado cuando

Esas cinco comprobaciones se ven en la terminal y el único archivo de tu entrega es `bitacora.ex`.
