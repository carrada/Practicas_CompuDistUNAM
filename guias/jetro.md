# Jetro — `analisis.txt`

Práctica 1. Computación Distribuida 2027-1.

Esta guía no trae las respuestas redactadas. Si la lees tú, escribe `analisis.txt` siguiendo los pasos. Si se la pasas a una IA, pídele que redacte ese archivo con lo que aquí se pide, sin inventar otro diseño y sin inventar tiempos.

## Entrega

Un solo archivo: `analisis.txt`.  
Texto, no código. No crees `algebra.ex`, `worker.ex`, `server.ex` ni `benchmark.ex`.

No necesitas la tabla de Erick ni el programa corriendo. El diseño ya está fijo en el reparto del equipo. Tus respuestas tienen que coincidir con ese diseño. Si una IA te propone `GenServer`, `Task` o varios nodos, no lo uses: la práctica usa `spawn`, `send` y `receive` en una sola máquina.

## Qué te toca

Las 8 preguntas de la sección 2.7 del PDF, con justificación. No son respuestas de una línea.

Además, el orden del PDF de entrega, para que al final solo se pegue texto y código:

1. Integrantes: Emilio, Emiliano, Omar, Erick, Jetro.
2. Las 8 respuestas, que salen de tu `analisis.txt`.
3. La tabla de tiempos, que la pega Erick en el hueco que tú dejes.
4. El código, en este orden: `algebra.ex`, `worker.ex`, `server.ex`, `benchmark.ex`.

## Hechos que tienes que respetar

Úsalos en las respuestas. No los cambies.

- Emilio, en `Algebra.primes_between(a, b)`, criba un intervalo cerrado. No usa procesos.
- Omar, en `Server.intervalos(n, k)`, parte `[1, n]` en `k` bloques `{id, a, b}`. `base` es la división entera de `n` entre `k`. `resto` es el residuo. Los primeros `resto` bloques miden uno más. Si sobran trabajadores, hay bloques vacíos con `a` mayor que `b`.
- Omar, en `Server.start(k, n)`, crea cada trabajador con `spawn` de tres argumentos (`Worker`, `loop`, sin argumentos extra) y le manda `{:trabajo, id, a, b, yo}`. `yo` es el pid del coordinador.
- Emiliano, en `Worker.loop`, recibe ese mensaje, llama `Algebra.primes_between(a, b)` y contesta `{:resultado, id, primos}`. El trabajador no sabe cuántos compañeros hay.
- El coordinador espera las `k` respuestas. Pueden llegar en cualquier orden. Al final aplana y ordena. El `receive` tiene un `after` de 60 segundos; si falta alguien, corta con error.
- Erick mide `Server.start(k, n)` con `:timer.tc` y publica milisegundos. Trabajadores: 1, 2, 4, 8 y 16. Límites: 10000, 100000 y 500000.
- Cada trabajador sí calcula su intervalo. No vale un solo proceso que haga todo y luego finja que hubo trabajadores.
- Todo corre en un solo nodo de la máquina virtual de Erlang. No hay varias computadoras.

## Paso a paso

Escribe `analisis.txt` con un título y, debajo, las ocho preguntas numeradas. Cada una: la pregunta, y luego tu respuesta en uno o dos párrafos.

1. Cómo se divide el trabajo. Explica `intervalos`: de 1 a `n`, bloques sin huecos ni traslapes, qué significan `base` y `resto`, y que cada trabajador solo criba su `[a, b]`. Menciona qué pasa con un bloque vacío.

2. Cómo se comunican. Describe los dos mensajes con el orden de los campos: de ida `trabajo`, `id`, `a`, `b` y el pid del coordinador; de vuelta `resultado`, `id` y la lista. Di que van con `send` y `receive`, y que el pid del coordinador viaja en el mensaje porque dentro del trabajador `self()` ya es otro proceso.

3. Qué pasa si un trabajador tarda más. El coordinador no entrega la lista hasta tener las `k` respuestas, así que el más lento marca el tiempo total. El `after` de 60 segundos evita que se quede esperando para siempre. No digas que los demás cancelan al lento ni que se ignora su resultado.

4. Más trabajadores que núcleos. Los planificadores de la BEAM (por lo general, uno por núcleo) reparten los procesos en el tiempo. No hay un núcleo físico por proceso. Los procesos de más sí corren, pero se turnan, y crearlos y hablarles tiene un costo.

5. Si el tiempo baja siempre al aumentar trabajadores. La respuesta es que no tiene por qué. Explica el costo de crear procesos, copiar las listas en los mensajes y esperar al más lento. Con un `n` chico ese costo puede comerse el cálculo; con un `n` grande puede haber mejora, y esa mejora no tiene que ser proporcional al número de trabajadores. Al final de esta pregunta deja el hueco, escrito exactamente así, para que Erick pegue sus números el día de la integración. Tú no inventes los tiempos:

```text
TABLA_DE_ERICK
N        1    2    4    8    16
10000
100000
500000
```

6. Costos extra. Crear el proceso, copiar la lista al mandarla (los procesos no comparten esa lista), el `receive`, y al final aplanar y ordenar. También: cada trabajador vuelve a calcular, por su cuenta, los primos chicos que necesita para cribar su intervalo. Ese trabajo se repite.

7. Un solo proceso contra varios. Con `k = 1` hay un solo proceso y un solo intervalo, de 1 a `n`, y no hay mensajes de más. Con varios procesos el intervalo se parte y hay que sincronizar las respuestas. Compara esas dos situaciones. Recuerda el requisito: cada trabajador tiene que calcular de verdad.

8. Si esto es un sistema distribuido. Separa tres ideas y aplícalas a esta práctica:
   - concurrencia: hay varios procesos en marcha, aunque se turnen en un núcleo
   - paralelismo: de verdad avanzan al mismo tiempo, cuando hay varios núcleos
   - distribución: los procesos están en máquinas distintas, unidos por la red, y uno puede fallar sin tumbar a los otros  
   Esta práctica es concurrente y, con varios núcleos, puede ser paralela. No es un sistema distribuido en sentido estricto: todo vive en un solo nodo. El estilo de comunicación (mensajes, sin memoria compartida) es el mismo que Erlang usa cuando sí hay varias máquinas, pero aquí nadie conecta otro nodo.

## Terminado cuando

`analisis.txt` tiene las ocho respuestas justificadas, coinciden con los hechos de arriba, y la pregunta 5 termina con el hueco `TABLA_DE_ERICK` vacío.
