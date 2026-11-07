defmodule Salida do
  @moduledoc """
  Módulo de salida de la Práctica 3 (consenso distribuido).

  Es el único módulo que escribe en la terminal. Cada función pública
  imprime su texto exacto, seguido de un salto de línea, y regresa `:ok`.
  No crea procesos, no calcula el quórum ni usa azar: solo da formato
  a los datos que le pasan Omar (Líder) y Emilio (Participante).

  Autor: Erick.
  """

  @doc """
  Imprime el banner de inicio del consenso.

  Autor: Erick.
  """
  def iniciando do
    IO.puts("------ Iniciando consenso -----------")
    :ok
  end

  @doc """
  Imprime la propuesta de un proceso.

  `pid` es el identificador del proceso (se muestra como `#PID<...>`),
  `valor` es el valor propuesto y `veces` es 1 al proponer o 2 al recibir
  la decisión. `veces` se usa tal cual lo manda quien llama.

  Autor: Erick.
  """
  def propone(pid, valor, veces) do
    IO.puts("El proceso #{inspect(pid)} propone #{valor}, #{veces} veces")
    :ok
  end

  @doc """
  Imprime que un proceso falló después de sacar su propuesta.

  Autor: Erick.
  """
  def falla_propuesta(pid, valor) do
    IO.puts("El proceso #{inspect(pid)} propone #{valor}, antes de fallar")
    :ok
  end

  @doc """
  Imprime la frase de espera, con comillas incluidas en la línea.

  Autor: Erick.
  """
  def esperando do
    IO.puts("\"Estoy esperando mensajes\"")
    :ok
  end

  @doc """
  Imprime la lista de valores válidos, ya ordenada, en la forma
  `v=[57, 95, 319]` (coma seguida de espacio).

  Autor: Erick.
  """
  def lista(valores) do
    IO.puts("v=[" <> Enum.join(valores, ", ") <> "]")
    :ok
  end

  @doc """
  Imprime el banner de resultado del consenso.

  Autor: Erick.
  """
  def separador_resultado do
    IO.puts("------ Resultado del consenso -----------")
    :ok
  end

  @doc """
  Imprime el aviso de que no se alcanzó el consenso (sin comillas).

  Autor: Erick.
  """
  def no_consenso do
    IO.puts("No es posible llegar a un consenso")
    :ok
  end

  @doc """
  Imprime las tres líneas del resumen del consenso.

  `n` es el total de procesos, `v` el valor acordado y `c` los procesos
  que terminaron el algoritmo. "Numero" va sin acento.

  Autor: Erick.
  """
  def resumen_consenso(n, v, c) do
    IO.puts("El total de procesos que participaron es #{n}")
    IO.puts("El acuerdo es #{v}")
    IO.puts("Numero de procesos que terminaron el algoritmo #{c}")
    :ok
  end

  @doc """
  Imprime el banner de la ejecución de la operación ("Ejecucion" sin acento).

  Autor: Erick.
  """
  def separador_operacion do
    IO.puts("------ Ejecucion de la operacion --------")
    :ok
  end

  @doc """
  Imprime que un proceso falló al ejecutar la operación.

  Autor: Erick.
  """
  def falla_operacion(pid) do
    IO.puts("El proceso #{inspect(pid)} falla al ejecutar la operacion")
    :ok
  end

  @doc """
  Imprime que un proceso registró el valor acordado.

  Autor: Erick.
  """
  def registra(pid, valor) do
    IO.puts("El proceso #{inspect(pid)} registra el valor #{valor}")
    :ok
  end

  @doc """
  Imprime el banner del resumen final (empieza con cinco guiones).

  Autor: Erick.
  """
  def separador_final do
    IO.puts("----- Resumen final ---------")
    :ok
  end

  @doc """
  Imprime las cuatro líneas del resumen final.

  `n` procesos creados, `c` procesos que terminaron el algoritmo,
  `e` procesos que confirmaron la operación y `f` los que no la
  completaron. Aquí "operación" sí lleva acento.

  Autor: Erick.
  """
  def resumen_final(n, c, e, f) do
    IO.puts("El total de procesos que participaron es #{n}")
    IO.puts("Numero de procesos que terminaron el algoritmo #{c}")
    IO.puts("Procesos que confirmaron la operación: #{e}")
    IO.puts("Procesos que no completaron la operación: #{f}")
    :ok
  end
end
