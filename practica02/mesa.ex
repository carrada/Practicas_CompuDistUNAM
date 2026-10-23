defmodule Mesa do
  @moduledoc """
  Crea los procesos de la cena y espera a que terminen los cinco filósofos.

  """

  @doc "Devuelve los pares de palillos en el orden del contrato, sin crear procesos."
  def pares do
    [{1, 5, 1}, {2, 1, 2}, {3, 2, 3}, {4, 3, 4}, {5, 4, 5}]
  end

  @doc """
  Inicia la bitácora, los cinco palillos y los cinco filósofos.

  Regresa `:ok` cuando todos terminan. Si pasan 60 segundos de espera,
  lanza un error que indica cuántos filósofos faltan.
  """
  def iniciar do
    pid_bitacora = spawn(Bitacora, :loop, [])
    pid_mesa = self()

    palillos = Map.new(1..5, fn id -> {id, spawn(Palillo, :loop, [id])} end)

    Enum.each(pares(), fn {id, id_a, id_b} ->
      palillo_a = {id_a, Map.fetch!(palillos, id_a)}
      palillo_b = {id_b, Map.fetch!(palillos, id_b)}
      spawn(Filosofo, :loop, [id, palillo_a, palillo_b, pid_bitacora, pid_mesa])
    end)

    limite = System.monotonic_time(:millisecond) + 60_000
    esperar(Enum.to_list(1..5), limite)
  end

  defp esperar([], _limite), do: :ok

  # Cada id cuenta una sola vez y el plazo no se reinicia al recibir mensajes.
  defp esperar(pendientes, limite) do
    restante = max(limite - System.monotonic_time(:millisecond), 0)

    receive do
      {:listo, id} ->
        esperar(List.delete(pendientes, id), limite)
    after
      restante ->
        raise "Se agotaron los 60 segundos: faltan #{length(pendientes)} filósofos por terminar."
    end
  end
end
