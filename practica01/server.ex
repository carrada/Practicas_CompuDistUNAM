defmodule Server do
  @moduledoc """
  Coordinador que reparte intervalos entre trabajadores y reúne sus resultados.
  Autor: Andro (Omar)
  """

  @doc """
  Divide el intervalo que nos dieron [1, n] en k bloques y regresa las tuplas {id, a, b}.

  n y k deben ser enteros positivos. Los primeros rem(n, k) bloques
  reciben un número adicional. Si k > n, los últimos bloques están
  vacíos (a > b). Esta función no va a crear procesos.
  """
  def intervalos(n, k) when is_integer(n) and n >= 1 and is_integer(k) and k >= 1 do
    repartir(1, 1, k, div(n, k), rem(n, k))
  end

  @doc """
  Crea k trabajadores para buscar los primos de [1, n].

  k y n deben ser enteros positivos. Envía los intervalos a Worker.loop/0,
  espera las k respuestas y regresa una sola lista ordenada.
  Si transcurren 60 segundos sin recibir la siguiente respuesta, lanza
  un error indicando cuántos trabajadores faltan por responder.
  """
  def start(k, n) when is_integer(k) and k >= 1 and is_integer(n) and n >= 1 do
    yo = self()

    Enum.each(intervalos(n, k), fn {id, a, b} ->
      trabajador = spawn(Worker, :loop, [])
      send(trabajador, {:trabajo, id, a, b, yo})
    end)

    k
    |> recibir_resultados([])
    |> List.flatten()
    |> Enum.sort()
  end

  # Termina el reparto cuando ya se generaron los k bloques.
  defp repartir(_inicio, id, k, _base, _resto) when id > k, do: []

  # Agrega un bloque y avanza el inicio por su tamaño; si es cero, no avanza.
  defp repartir(inicio, id, k, base, resto) do
    tamano = base + if(id <= resto, do: 1, else: 0)
    fin = inicio + tamano - 1

    [{id, inicio, fin} | repartir(inicio + tamano, id + 1, k, base, resto)]
  end

  # Regresa las listas acumuladas cuando todos los trabajadores contestaron.
  defp recibir_resultados(0, resultados), do: resultados

  # Recibe una respuesta y reduce la cantidad pendiente, incluso si trae [].
  defp recibir_resultados(faltan, resultados) do
    receive do
      {:resultado, _id, primos} ->
        recibir_resultados(faltan - 1, [primos | resultados])
    after
      60_000 ->
        raise "Tiempo de espera agotado: faltan #{faltan} trabajadores por responder."
    end
  end
end
