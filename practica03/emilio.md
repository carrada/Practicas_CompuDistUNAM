# Emilio — `participante.ex`

Práctica 3. Computación Distribuida 2027-1. Consenso distribuido.

Esta guía no trae el código. Si la lees tú, sigue los pasos. Si se la pasas a una IA, pídele que implemente solo `practica03/participante.ex`. No escribas el líder, las reglas ni las frases.

Trabajas dentro de la carpeta `practica03`.

## Entrega

Un solo archivo: `practica03/participante.ex`.  
Módulo: `Participante`.  
Función pública: `loop/1`.

## Qué te toca

Un proceso participante. Omar te crea con `spawn(Participante, :loop, [id])`. Tú no creas a los demás y no decides si hubo consenso.

El valor sale de `Reglas.propuesta/0`. El fallo sale de `Reglas.falla?/0`. Las líneas las escribe `Salida`: tú solo llamas las funciones con los datos.

## Formato de los nombres

| Qué | Cómo se escribe |
|---|---|
| Argumento de `loop` | `id`, entero desde 1 |
| Tu pid, para las frases | `self()` |
| Documentación | `@moduledoc` y `@doc`. Autor: Emilio |

Mensaje que esperas primero:

`{:proponer, pid_lider}`

Si fallas antes de proponer, avisas y terminas:

`{:fallo_propuesta, id, valor}`

Si propones:

`{:propuesta, id, valor}`

Luego esperas:

`{:decision, valor}`

y contestas:

`{:decision_ok, id}`

Luego esperas:

`{:operar, valor}`

y contestas una de estas dos:

`{:registro_ok, id}`

`{:fallo_operacion, id}`

El `send` de todas esas respuestas va a `pid_lider`. En la decisión y en la operación el líder no manda su pid otra vez: guárdalo cuando llega `{:proponer, pid_lider}`.

Llamadas a Salida, y ninguna otra:

| Momento | Llamada |
|---|---|
| Propuesta enviada | `Salida.propone(self(), valor, 1)` |
| Fallo antes de enviar | `Salida.falla_propuesta(self(), valor)` |
| Decisión recibida | `Salida.propone(self(), valor, 2)` |
| Fallo al registrar | `Salida.falla_operacion(self())` |
| Registro hecho | `Salida.registra(self(), valor)` |

El 1 y el 2 no son un contador que compartes con nadie. Son las veces que marca el PDF: 1 al proponer, 2 al aceptar la decisión.

## Paso a paso

1. Crea el módulo y `loop/1`.

2. Espera `{:proponer, pid_lider}`.

3. Obtén `valor` con `Reglas.propuesta/0`.

4. Si `Reglas.falla?/0` es `true`, llama a `Salida.falla_propuesta/2`, manda `{:fallo_propuesta, id, valor}` y deja morir el proceso. No esperes la decisión.

5. Si no falló, llama a `Salida.propone/3` con un 1, manda `{:propuesta, id, valor}` y espera `{:decision, valor}`.

6. Con esa decisión, llama a `Salida.propone/3` con un 2 y manda `{:decision_ok, id}`. El valor que imprimes es el que llegó en la decisión, el acordado, no hace falta volver a proponer otro número.

7. Espera `{:operar, valor}`. Vuelve a llamar a `Reglas.falla?/0`. Esta tirada no depende de la anterior: quien ya propuso puede fallar aquí.

8. Si falla, `Salida.falla_operacion/1`, mensaje `{:fallo_operacion, id}` y el proceso termina.

9. Si no falla, `Salida.registra/2`, mensaje `{:registro_ok, id}` y el proceso termina.

10. No calcules el mínimo ni el quórum. No imprimas con `IO.puts`: si la frase cambia, la cambia Erick en `Salida`.

## Cómo probarlo sin los demás

En un archivo que no se entrega, escribe un `Reglas` temporal cuya `propuesta/0` regrese un número fijo y cuya `falla?/0` puedas poner en `true` o `false`. Escribe un `Salida` temporal que te reenvíe a ti cada llamada, para ver el orden.

Arranca `loop` y mándale `{:proponer, self()}`.

- Con fallo en la propuesta, llega `{:fallo_propuesta, id, valor}` y no llega `{:decision_ok, id}`.
- Sin fallos, después de la propuesta le mandas `{:decision, 247}` y debe llegar `{:decision_ok, id}` tras la llamada con veces 2. Luego `{:operar, 247}` y, si `falla?/0` es `false`, llega `{:registro_ok, id}`.
- Si `falla?/0` es `false` en la propuesta y `true` en la operación, llega `{:fallo_operacion, id}` y no `{:registro_ok, id}`.

## Terminado cuando

Esos tres caminos se cumplen y el único archivo de tu entrega es `practica03/participante.ex`.
