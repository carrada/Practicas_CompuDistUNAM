defmodule Benchmark do
  @moduledoc """
  Mide el tiempo de `Server.start/2` para distintas cantidades de
  trabajadores y distintos límites, y escribe la tabla en milisegundos.

  No parte intervalos, no criba y no crea trabajadores: solo llama a
  `Server.start(k, n)` y mide la llamada.

  Autor: Erick
  """

  @trabajadores [1, 2, 4, 8, 16]
  @limites [10000, 100000, 500000]

  @doc """
  Mide `Server.start(k, n)` para cada `k` en `[1, 2, 4, 8, 16]` y cada
  `n` en `[10000, 100000, 500000]`, una corrida por celda.

  Imprime la tabla de tiempos en milisegundos enteros (columnas de 8
  caracteres alineadas a la derecha) y regresa `:ok`.

  Autor: Erick
  """
  def run do
    ["N" | @trabajadores]
    |> fila()
    |> IO.puts()

    Enum.each(@limites, fn n ->
      tiempos = Enum.map(@trabajadores, fn k -> medir(k, n) end)
      IO.puts(fila([n | tiempos]))
    end)

    :ok
  end

  # Mide Server.start(k, n) y regresa los milisegundos enteros.
  # El segundo valor de la tupla (la lista de primos) se descarta.
  defp medir(k, n) do
    {microsegundos, _primos} = :timer.tc(fn -> Server.start(k, n) end)
    div(microsegundos, 1000)
  end

  defp fila(valores), do: Enum.map_join(valores, "", &celda/1)

  defp celda(valor), do: valor |> to_string() |> String.pad_leading(8)
end
