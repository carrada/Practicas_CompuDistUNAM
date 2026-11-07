defmodule Consenso do
  @moduledoc """
  Arranque de la simulación de consenso.
  Autor: Jetro.
  """

  @doc "Corre el consenso con n participantes."
  def iniciar(n) when is_integer(n) and n >= 1, do: Lider.iniciar(n)
end
