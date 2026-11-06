defmodule participante do
  @moduledoc """
  Módulo que define el comportamiento de un participante delegando
  la lógica de fallos y valores al módulo Reglas, y la impresión al módulo Salida.
  Creado por Emilio Durán Tapia
  """

  @doc """
  Inicia el participante esperando su primer mensaje.
  Solo requiere recibir su `id` inicial.
  """
  def loop(id) do
    receive do
      {:proponer, pid_lider} ->
        valor = Reglas.propuesta()

        if Reglas.falla?() do
          Salida.falla_propuesta(id, valor)
          send(pid_lider, {:fallo_propuesta, id, valor})
        else
          Salida.propone(id, 1, valor)
          send(pid_lider, {:propuesta, id, valor})
          
          esperar_decision(id, pid_lider)
        end
    end
  end

  defp esperar_decision(id, pid_lider) do
    receive do
      {:decision, valor_acordado} ->
        Salida.propone(id, 2, valor_acordado)
        send(pid_lider, {:decision_ok, id})
        
        esperar_operacion(id, pid_lider)
    end
  end

  defp esperar_operacion(id, pid_lider) do
    receive do
      {:operar, valor_operar} ->
        if Reglas.falla?() do
          Salida.falla_operacion(id)
          send(pid_lider, {:fallo_operacion, id})
        else
          Salida.registra(id, valor_operar)
          send(pid_lider, {:registro_ok, id})
        end
    end
  end
end