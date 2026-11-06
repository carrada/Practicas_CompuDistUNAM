# Jetro — `consenso.ex` y `notas_practica3.txt`

Práctica 3. Computación Distribuida 2027-1. Consenso distribuido.

Esta guía no trae el código ni las notas redactadas. Si la lees tú, escribe los dos archivos. Si se la pasas a una IA, pídele solo `practica03/consenso.ex` y `practica03/notas_practica3.txt`. No reescribas al líder ni a los participantes.

Trabajas dentro de la carpeta `practica03`.

## Entrega

- `practica03/consenso.ex`, módulo `Consenso`.
- `practica03/notas_practica3.txt`.

## Qué te toca

El arranque, de una función, y la lectura correcta del PDF. Los ejemplos impresos del PDF se contradicen con las reglas del mismo PDF. Tus notas dejan fija la lectura que ya está en `division_practica3.txt`, para que nadie programe el ejemplo equivocado.

## Formato

`Consenso.iniciar/1` recibe `n`, un entero mayor o igual que 1.

Hace una sola cosa: llama a `Lider.iniciar(n)` y regresa lo que esa función regrese. No crees procesos aquí. No calcules el quórum aquí.

Documenta el módulo y la función. Autor: Jetro.

## Paso a paso del módulo

1. Crea `consenso.ex` con el módulo `Consenso`.

2. Escribe `iniciar/1` como el puente hacia `Lider.iniciar/1`.

3. Para probarlo sin Omar, en un archivo que no se entrega define un `Lider.iniciar/1` que regrese `{:ok, n}`. `Consenso.iniciar(5)` tiene que regresar `{:ok, 5}`. Cuando exista el líder de verdad, no cambias esta función: el nombre ya es el del contrato.

## Paso a paso de las notas

Escribe `notas_practica3.txt` con estos cuatro apartados, en prosa.

1. El quórum. `Q` es la división entera de `N` entre 2, más 1. Con 5 procesos, `Q` es 3. Hay consenso cuando las propuestas válidas son 3, 4 o 5. No hay consenso cuando son 0, 1 o 2, es decir cuando fallan al menos 3 antes de proponer. Di que la división no es con decimales.

2. El ejemplo equivocado del PDF. El caso impreso con cinco propuestas y la frase de que no hay consenso no se implementa. El propio PDF dice después que cinco propuestas válidas sí alcanzan el quórum. La corrida sin consenso, con cinco procesos, tiene que mostrar los fallos y una lista `v=` de tamaño menor que 3.

3. Qué es F. F cuenta solo a quien falló al registrar, en la operación. Quien falló en la propuesta no aparece en esa cuenta y no debe imprimir "falla al ejecutar la operacion". E + F es igual a C, los que terminaron el consenso. C no es N.

4. Cómo se corre y cómo se entrega. Desde `practica03` se compilan `reglas.ex`, `salida.ex`, `participante.ex`, `lider.ex` y `consenso.ex`, y se llama `Consenso.iniciar(5)`. El repositorio de la entrega va en privado, con KevinTorres74 como colaborador. En Classroom solo se manda el enlace HTTPS. El código de cada archivo va documentado. Si no compila, la práctica queda en 0.

## Terminado cuando

`Consenso.iniciar(5)` llama a `Lider.iniciar(5)` y las notas cubren los cuatro apartados.
