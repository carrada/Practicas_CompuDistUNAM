defmodule Lider do
  @moduledoc """
  Crea a los participantes, junta sus propuestas y decide si hay consenso.
  Autor: Omar.
  """

  @espera 5_000

  @doc "Corre las etapas del consenso con n participantes."
  def iniciar(n) when is_integer(n) and n >= 1 do
    Salida.iniciando()
    yo = self()

    procesos =
      Enum.map(1..n, fn id ->
        pid = spawn(Participante, :loop, [id])
        send(pid, {:proponer, yo})
        {id, pid}
      end)

    respuestas = recibir(n)
    propuestas = for {:propuesta, id, valor} <- respuestas, do: {id, valor}
    valores = propuestas |> Enum.map(fn {_id, valor} -> valor end) |> Reglas.ordenar()

    Salida.esperando()
    Salida.lista(valores)

    if Reglas.hay_consenso?(n, length(valores)) do
      con_consenso(n, valores, propuestas, procesos)
    else
      Salida.separador_resultado()
      Salida.no_consenso()
      :sin_consenso
    end
  end

  defp con_consenso(n, valores, propuestas, procesos) do
    valor = Reglas.acordado(valores)
    ids_validos = MapSet.new(Enum.map(propuestas, fn {id, _valor} -> id end))

    activos =
      Enum.filter(procesos, fn {id, _pid} -> MapSet.member?(ids_validos, id) end)

    Enum.each(activos, fn {_id, pid} -> send(pid, {:decision, valor}) end)

    decisiones = recibir(length(activos))
    c = Enum.count(decisiones, &match?({:decision_ok, _id}, &1))
    ids_ok = MapSet.new(for {:decision_ok, id} <- decisiones, do: id)

    Salida.esperando()
    Salida.separador_resultado()
    Salida.resumen_consenso(n, valor, c)

    operan = Enum.filter(procesos, fn {id, _pid} -> MapSet.member?(ids_ok, id) end)

    Salida.separador_operacion()
    Enum.each(operan, fn {_id, pid} -> send(pid, {:operar, valor}) end)

    operaciones = recibir(length(operan))
    e = Enum.count(operaciones, &match?({:registro_ok, _id}, &1))
    f = Enum.count(operaciones, &match?({:fallo_operacion, _id}, &1))

    Salida.separador_final()
    Salida.resumen_final(n, c, e, f)
    {:ok, %{n: n, valor: valor, c: c, e: e, f: f}}
  end

  defp recibir(0), do: []

  defp recibir(faltan) do
    receive do
      {:propuesta, id, valor} ->
        [{:propuesta, id, valor} | recibir(faltan - 1)]

      {:fallo_propuesta, id, valor} ->
        [{:fallo_propuesta, id, valor} | recibir(faltan - 1)]

      {:decision_ok, id} ->
        [{:decision_ok, id} | recibir(faltan - 1)]

      {:registro_ok, id} ->
        [{:registro_ok, id} | recibir(faltan - 1)]

      {:fallo_operacion, id} ->
        [{:fallo_operacion, id} | recibir(faltan - 1)]
    after
      @espera ->
        raise "Timeout: faltan #{faltan} respuestas"
    end
  end
end
