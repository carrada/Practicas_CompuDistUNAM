# Omar — `lider.ex`

Práctica 3. Computación Distribuida 2027-1. Consenso distribuido.

Esta guía no trae el código. Si la lees tú, sigue los pasos. Si se la pasas a una IA, pídele que implemente solo `practica03/lider.ex`. No escribas al participante, las reglas ni el texto de las frases.

Trabajas dentro de la carpeta `practica03`.

## Entrega

Un solo archivo: `practica03/lider.ex`.  
Módulo: `Lider`.  
Función pública: `iniciar/1`.

## Qué te toca

Crear los participantes, juntar lo que contestan y decidir si hay consenso. Las cuentas salen de `Reglas`. Las líneas salen de `Salida`. Tú no generas el número aleatorio ni armas la frase.

## Formato de los nombres

| Qué | Cómo se escribe |
|---|---|
| Arranque | `Lider.iniciar(n)` |
| Crear a alguien | `spawn(Participante, :loop, [id])` |
| Ids | 1, 2, … hasta `n` |
| Documentación | `@moduledoc` y `@doc`. Autor: Omar |

Guarda, al crearlos, la pareja `{id, pid}`. El pid no viene en la respuesta; la respuesta trae el `id`.

Mensajes que mandas:

| A quién | Mensaje |
|---|---|
| Todos, al empezar | `{:proponer, self()}` |
| Quien mandó `{:propuesta, id, valor}` | `{:decision, valor_acordado}` |
| Quien mandó `{:decision_ok, id}` | `{:operar, valor_acordado}` |

Respuestas que cuentas:

| Mensaje | Qué significa |
|---|---|
| `{:propuesta, id, valor}` | propuesta válida |
| `{:fallo_propuesta, id, valor}` | no entra a la lista ni a la decisión |
| `{:decision_ok, id}` | suma uno a C |
| `{:registro_ok, id}` | suma uno a E |
| `{:fallo_operacion, id}` | suma uno a F |

Tienes que recibir tantas respuestas como mensajes mandaste en esa etapa. Si pasan `5_000` milisegundos y falta alguna, corta con un error que diga cuántas faltan.

## Paso a paso

1. Crea el módulo y `iniciar/1`.

2. Llama a `Salida.iniciando/0` antes de que los participantes propongan.

3. Crea los `n` procesos y a cada uno mándale `{:proponer, self()}`. `self()` aquí es el líder. Guárdalo en una variable antes de entrar a una función que cambie de proceso.

4. Recibe `n` respuestas. Arma la lista solo con los valores de `{:propuesta, id, valor}`.

5. Llama a `Salida.esperando/0`. Ordena con `Reglas.ordenar/1` y muestra esa lista con `Salida.lista/1`.

6. Pregunta `Reglas.hay_consenso?(n, cantidad)`. La cantidad es el tamaño de la lista válida, no `n`.

7. Si no hay consenso, llama a `Salida.separador_resultado/0` y a `Salida.no_consenso/0`, y termina. No mandes `{:decision, _}` ni `{:operar, _}`. No imprimas el resumen final.

8. Si hay consenso, el valor es `Reglas.acordado/1` de la lista ya ordenada. Mándaselo, en `{:decision, valor}`, solo a los pid cuya propuesta fue válida.

9. Recibe un `{:decision_ok, id}` por cada uno de esos. Ese número es C.

10. Llama otra vez a `Salida.esperando/0`. Las líneas de "2 veces" las imprime cada participante al recibir la decisión, antes de este segundo aviso, porque ellos contestan al recibir.

11. `Salida.separador_resultado/0` y `Salida.resumen_consenso(n, valor, c)`.

12. `Salida.separador_operacion/0`. Manda `{:operar, valor}` solo a quienes mandaron `{:decision_ok, id}`.

13. Recibe una respuesta por cada uno. `{:registro_ok, id}` suma E. `{:fallo_operacion, id}` suma F. Quien falló en la propuesta no está en esta etapa y no suma F.

14. `Salida.separador_final/0` y `Salida.resumen_final(n, c, e, f)`.

15. E + F tiene que ser igual a C. Si no da, estás contando a alguien que no llegó a la decisión.

## Cómo probarlo sin los demás

En un archivo que no se entrega:

- `Salida` con funciones vacías que regresen `:ok`.
- `Reglas.ordenar/1`, `Reglas.hay_consenso?/2` y `Reglas.acordado/1` de verdad, o las mismas cuentas: quórum `div(n, 2) + 1`, consenso si hay al menos ese número, acordado igual al menor.
- `Participante.loop/1` de mentira. Para probar el no-consenso con `n = 5`, tres de ellos contestan `{:fallo_propuesta, id, valor}` y dos contestan `{:propuesta, id, valor}`. `iniciar(5)` debe llamar a `no_consenso` y no debe mandar `{:decision, _}`.
- Para el consenso, cinco contestan propuesta. Los que reciban `{:decision, valor}` contestan `{:decision_ok, id}`. De esos, al recibir `{:operar, valor}`, unos contestan `{:registro_ok, id}` y otros `{:fallo_operacion, id}`. E + F es 5 si los cinco propusieron.

Con `n = 5` y tres fallos de propuesta, no hay consenso. Con tres o más propuestas, sí, y el valor es el menor de esas propuestas.

## Terminado cuando

Esos dos caminos terminan sin quedarse esperando, y el único archivo de tu entrega es `practica03/lider.ex`.
