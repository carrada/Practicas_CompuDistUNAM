defmodule Filosofo do
  @moduledoc """
  Proceso filósofo: piensa, consigue sus dos palillos, come y los suelta.
  Autor: Cristopher Emiliano.
  """

  @ciclos 3

  @doc "Repite tres cenas y avisa a la mesa cuando termina."
  def loop(id, palillo_a, palillo_b, pid_bitacora, pid_mesa) do
    cenar(id, palillo_a, palillo_b, pid_bitacora, @ciclos)
    send(pid_mesa, {:listo, id})
  end

  # Un ciclo: pensar, pedir de menor a mayor, comer y soltar los dos.
  defp cenar(_id, _palillo_a, _palillo_b, _pid_bitacora, 0), do: :ok

  defp cenar(id, palillo_a, palillo_b, pid_bitacora, restantes) do
    send(pid_bitacora, {:evento, id, :pensando})
    Process.sleep(espera())

    send(pid_bitacora, {:evento, id, :hambriento})

    {id_a, _pid_a} = palillo_a
    {id_b, _pid_b} = palillo_b
    send(pid_bitacora, {:evento, id, {:solicita, id_a, id_b}})

    [primero, segundo] =
      Enum.sort_by([palillo_a, palillo_b], fn {id_palillo, _pid} -> id_palillo end)

    pedir(id, primero, pid_bitacora)
    pedir(id, segundo, pid_bitacora)

    send(pid_bitacora, {:evento, id, :comiendo})
    Process.sleep(espera())

    send(pid_bitacora, {:evento, id, :termino})
    soltar(id, primero, pid_bitacora)
    soltar(id, segundo, pid_bitacora)

    cenar(id, palillo_a, palillo_b, pid_bitacora, restantes - 1)
  end

  # Pide un palillo y no sigue hasta que conceden ese mismo número.
  defp pedir(id, {id_palillo, pid_palillo}, pid_bitacora) do
    send(pid_palillo, {:solicitar, self(), id})
    send(pid_bitacora, {:evento, id, {:esperando, id_palillo}})

    receive do
      {:conceder, ^id_palillo} ->
        send(pid_bitacora, {:evento, id, {:obtuvo, id_palillo}})
    end
  end

  # Devuelve el palillo y avisa que ya lo soltó.
  defp soltar(id, {id_palillo, pid_palillo}, pid_bitacora) do
    send(pid_palillo, {:liberar, self(), id})
    send(pid_bitacora, {:evento, id, {:libero, id_palillo}})
  end

  # Entre 100 y 300 milisegundos, para que las cenas se intercalen.
  defp espera, do: :rand.uniform(201) + 99
end
