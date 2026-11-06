# Erick — `salida.ex`

Práctica 3. Computación Distribuida 2027-1. Consenso distribuido.

Esta guía no trae el código. Si la lees tú, sigue los pasos. Si se la pasas a una IA, pídele que implemente solo `practica03/salida.ex`. No calcules quórum ni crees procesos.

Trabajas dentro de la carpeta `practica03`.

## Entrega

Un solo archivo: `practica03/salida.ex`.  
Módulo: `Salida`.  
Cada función pública escribe su texto y regresa `:ok`.

## Qué te toca

Las frases exactas. Omar y Emilio te llaman por estos nombres. Si el texto cambia en tu archivo, la corrida cambia; ellos no arman las cadenas.

## Formato de los nombres

Documenta el módulo y cada función. Autor: Erick.

El pid se escribe tal como lo muestra Elixir, el texto que empieza con `#PID`. No lo conviertas a un número suelto.

| Función | Línea que debe verse |
|---|---|
| `iniciando/0` | `------ Iniciando consenso -----------` |
| `propone/3` | `El proceso PID propone VALOR, VECES veces` |
| `falla_propuesta/2` | `El proceso PID propone VALOR, antes de fallar` |
| `esperando/0` | `"Estoy esperando mensajes"` |
| `lista/1` | `v=[57, 95, 319]` con los valores que te pasen |
| `separador_resultado/0` | `------ Resultado del consenso -----------` |
| `no_consenso/0` | `No es posible llegar a un consenso` |
| `resumen_consenso/3` | tres líneas, abajo |
| `separador_operacion/0` | `------ Ejecucion de la operacion --------` |
| `falla_operacion/1` | `El proceso PID falla al ejecutar la operacion` |
| `registra/2` | `El proceso PID registra el valor VALOR` |
| `separador_final/0` | `----- Resumen final ---------` |
| `resumen_final/4` | cuatro líneas, abajo |

`propone(pid, valor, veces)` usa el tercer argumento tal cual. No escribas el 1 o el 2 fijos: quien llama ya manda 1 o 2.

`lista/1` recibe la lista ya ordenada. Entre el número y la coma va un espacio: `v=[57, 95, 319]`, no `v=[57,95,319]`.

`esperando/0` incluye las comillas en lo que se imprime.

`no_consenso/0` no lleva comillas.

`resumen_consenso(n, v, c)` imprime, cada una en su línea:

```text
El total de procesos que participaron es N
El acuerdo es V
Numero de procesos que terminaron el algoritmo C
```

`Numero` va sin acento.

`resumen_final(n, c, e, f)` imprime:

```text
El total de procesos que participaron es N
Numero de procesos que terminaron el algoritmo C
Procesos que confirmaron la operación: E
Procesos que no completaron la operación: F
```

En estas dos últimas, `operación` sí lleva acento. Antes de los dos puntos hay un espacio solo donde se ve en la línea: va pegado el dos puntos a la palabra, y luego un espacio y el número. La línea queda `Procesos que confirmaron la operación: 3` si E es 3.

Los separadores se copian con los mismos guiones. `separador_final/0` empieza con cinco guiones, no con seis. `separador_operacion/0` dice `Ejecucion` sin acento.

## Paso a paso

1. Crea el módulo `Salida` con una función por cada renglón de la tabla.

2. Escribe la línea y un salto de línea. No juntes dos frases en la misma línea.

3. En los resúmenes, el orden de las líneas es el de arriba. No agregues el banner dentro del resumen: el banner es otra función y lo llama Omar.

4. No leas mensajes ni mires cuántos procesos fallaron. Si te pasan `f` igual a 0, imprimes 0.

## Cómo probarlo solo

Compila este archivo y llama, con un pid cualquiera:

- `Salida.iniciando()`
- `Salida.esperando()`
- `Salida.lista([57, 95, 319])`
- `Salida.propone(self(), 57, 1)`
- `Salida.falla_propuesta(self(), 640)`
- `Salida.no_consenso()`
- `Salida.resumen_consenso(5, 247, 3)`
- `Salida.registra(self(), 247)`
- `Salida.resumen_final(5, 3, 3, 0)`

Tiene que verse `"Estoy esperando mensajes"` con comillas, `v=[57, 95, 319]`, y en el resumen final la palabra `operación` con acento. `Numero` sin acento.

## Terminado cuando

Esas líneas coinciden y el único archivo de tu entrega es `practica03/salida.ex`.
