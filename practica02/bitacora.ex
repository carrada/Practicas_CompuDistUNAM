defmodule Bitacora do
  @moduledoc """
  Registra los eventos de los filósofos y vigila que dos vecinos
  no estén comiendo simultáneamente.

  Autor: Erick.
  """

  @doc """
  Inicia la bitácora con un conjunto vacío de filósofos comiendo.
  Recibe eventos continuamente y no termina después de procesarlos.
  """
  def loop do
    recibir(MapSet.new())
  end

  # Mantiene el conjunto de filósofos que están comiendo.
  defp recibir(comiendo) do
    receive do
      {:evento, id, :comiendo} ->
        IO.puts("Filósofo #{id} está comiendo.")

        Enum.each(comiendo, fn otro ->
          if vecinos?(id, otro) do
            {menor, mayor} = {min(id, otro), max(id, otro)}
            IO.puts("ERROR: filósofos contiguos comiendo: #{menor} y #{mayor}.")
          end
        end)

        recibir(MapSet.put(comiendo, id))

      {:evento, id, :termino} ->
        IO.puts("Filósofo #{id} terminó de comer.")
        recibir(MapSet.delete(comiendo, id))

      {:evento, id, dato} ->
        imprimir(id, dato)
        recibir(comiendo)
    end
  end

  # Los filósofos forman un círculo de cinco posiciones.
  defp vecinos?(a, b) do
    abs(a - b) == 1 or abs(a - b) == 4
  end

  defp imprimir(id, :pensando),
    do: IO.puts("Filósofo #{id} está pensando.")

  defp imprimir(id, :hambriento),
    do: IO.puts("Filósofo #{id} tiene hambre.")

  defp imprimir(id, {:solicita, a, b}),
    do: IO.puts("Filósofo #{id} solicita los palillos #{a} y #{b}.")

  defp imprimir(id, {:esperando, palillo}),
    do: IO.puts("Filósofo #{id} está esperando el palillo #{palillo}.")

  defp imprimir(id, {:obtuvo, palillo}),
    do: IO.puts("Filósofo #{id} obtuvo el palillo #{palillo}.")

  defp imprimir(id, {:libero, palillo}),
    do: IO.puts("Filósofo #{id} liberó el palillo #{palillo}.")

  # Los eventos desconocidos no detienen el proceso.
  defp imprimir(_id, _dato), do: :ok
end
