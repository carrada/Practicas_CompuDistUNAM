defmodule Benchmark do
  @moduledoc """
  Mide el tiempo de `Server.start/2` para distintas cantidades de
  trabajadores y distintos límites, y escribe la tabla de resultados
  en milisegundos enteros.

  Autor: Erick
  """

  @trabajadores [1, 2, 4, 8, 16]
  @limites [10000, 100000, 500000]

  @doc """
  Recorre las 15 configuraciones (3 límites por 5 cantidades de
  trabajadores), una corrida por celda, e imprime la tabla en
  milisegundos. Las columnas son los trabajadores `1, 2, 4, 8, 16` y
  las filas los límites `10000, 100000, 500000`. Cada columna se alinea
  a la derecha con 8 caracteres.

  Regresa `:ok`.
  """
  def run do
    encabezado = ["N" | Enum.map(@trabajadores, &Integer.to_string/1)]
    IO.puts(formatear(encabezado))

    Enum.each(@limites, fn n ->
      tiempos = Enum.map(@trabajadores, fn k -> medir(k, n) end)
      IO.puts(formatear([n | tiempos]))
    end)

    :ok
  end

  # Mide Server.start(k, n) y regresa los milisegundos enteros.
  # El segundo valor de la tupla de :timer.tc (los primos) se descarta.
  defp medir(k, n) do
    {microsegundos, _primos} = :timer.tc(fn -> Server.start(k, n) end)
    div(microsegundos, 1000)
  end

  # Convierte cada celda a texto y la alinea a la derecha en 8 caracteres.
  defp formatear(celdas) do
    celdas
    |> Enum.map(fn celda -> celda |> to_string() |> String.pad_leading(8) end)
    |> Enum.join()
  end
end
