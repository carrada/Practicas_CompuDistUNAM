# Jetro — `analisis_practica2.txt`

Práctica 2. Computación Distribuida 2027-1. La cena de los filósofos.

Esta guía no trae las respuestas redactadas. Si la lees tú, escribe el archivo siguiendo los pasos. Si se la pasas a una IA, pídele que redacte `analisis_practica2.txt` con lo que aquí se pide, sin inventar otro diseño y sin inventar una corrida.

## Entrega

Un solo archivo: `analisis_practica2.txt`.  
Texto, no código. No crees `palillo.ex`, `filosofo.ex`, `mesa.ex` ni `bitacora.ex`.

No necesitas el programa corriendo. El diseño ya está en `division_practica2.txt`. Si una IA te propone `GenServer`, variables globales o un mesero que no está en el contrato, no lo uses.

## Qué te toca

Las 9 preguntas de la sección 4 del PDF, con justificación. No son respuestas de una línea.

Al final dejas el esqueleto del reporte, para que armarlo sea pegar:

1. Integrantes: Emilio, Emiliano, Omar, Erick, Jetro.
2. Las 9 respuestas.
3. Cómo se corre: compilar los cuatro módulos y llamar `Mesa.iniciar()`.
4. El código, en este orden: `palillo.ex`, `filosofo.ex`, `mesa.ex`, `bitacora.ex`.
5. El recordatorio de entrega: el repositorio va en privado, con KevinTorres74 como colaborador. En Classroom solo se entrega el enlace HTTPS.

## Hechos que tienes que respetar

- Hay cinco filósofos y cinco palillos. Cada uno es un proceso.
- El filósofo 1 usa los palillos 5 y 1. El 2 usa 1 y 2. El 3 usa 2 y 3. El 4 usa 3 y 4. El 5 usa 4 y 5.
- Son vecinos quienes comparten un palillo. 1 está junto a 2 y a 5. 1 y 3 no son vecinos y sí pueden comer a la vez.
- El palillo nace libre. Si está ocupado, guarda la petición y concede cuando el dueño libera. El estado no está en una variable global.
- Pedir es `{:solicitar, pid_filosofo, id_filosofo}`. Conceder es `{:conceder, id_palillo}`. Soltar es `{:liberar, pid_filosofo, id_filosofo}`.
- El filósofo no come hasta tener los dos `:conceder`. Pide primero el palillo de número menor y solo entonces el mayor. El filósofo 1 pide el 1 y después el 5, aunque la frase diga "5 y 1".
- Al terminar de comer suelta los dos.
- La bitácora imprime los estados y, si dos vecinos comen a la vez, una línea que empieza con `ERROR`.
- Cada filósofo cena tres veces y luego le manda `{:listo, id}` a la mesa.

## Paso a paso

Escribe las nueve preguntas numeradas. Debajo de cada una, uno o dos párrafos.

1. Qué es la exclusión mutua aquí. Es que dos procesos no usen el mismo palillo a la vez, y por eso dos vecinos no comen juntos. Nómbrala como la sección crítica: el tramo en el que el filósofo ya tiene los palillos y está comiendo.

2. Cuáles son los recursos compartidos. Los cinco palillos. El plato no se comparte. Di qué palillos comparte cada pareja de vecinos, usando la tabla de arriba.

3. Por qué dos contiguos no pueden comer a la vez. Porque les toca un mismo palillo, y el proceso palillo solo tiene un dueño.

4. Si puede haber dos filósofos comiendo al mismo tiempo. Sí, si no son vecinos. El ejemplo del PDF es el 1 y el 3. Justifícalo con los palillos: 5 y 1 contra 2 y 3, no hay intersección.

5. Cómo se garantiza que un palillo no tenga dos dueños. Con el proceso de Emilio: en `:ocupado` no concede, encola, y el `:liberar` de otro que no es el dueño no lo suelta. No hace falta una variable global.

6. Qué hacen los procesos palillo. Guardan libre u ocupado, conceden o encolan, y al liberarse atienden al siguiente. No son los filósofos.

7. Qué hacen los mensajes. Pide, concede y suelta, más el aviso `{:evento, ...}` que no mueve palillos: solo le cuenta el estado a la bitácora. Separa esas dos cosas.

8. Qué pasa si un filósofo se queda con un solo palillo. No come. Quien necesite ese palillo espera en la cola. Si los cinco hicieran eso en círculo, nadie soltaría el que le falta: eso es el interbloqueo del PDF. En esta solución no pide el segundo hasta tener el primero, y el primero es siempre el de número menor, así que no se arma ese círculo.

9. Qué habría que cambiar para que nadie espere un palillo para siempre. La cola del palillo ya atiende en orden de llegada, pero un filósofo puede tener mala suerte una y otra vez. Explica una modificación concreta, sin reescribir el programa: por ejemplo un turno que, después de comer, no vuelva a pedir hasta que los que ya estaban esperando hayan comido, o un tope de cuántos filósofos pueden estar hambrientos a la vez. Di por qué eso acota la espera.

## Terminado cuando

`analisis_practica2.txt` tiene las nueve respuestas, usan los hechos de arriba, y cierra con el orden del reporte y el recordatorio de Classroom.
