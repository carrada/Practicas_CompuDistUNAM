defmodule Reglas do
  @moduledoc """
  Cuentas del consenso y el azar de las propuestas y los fallos.
  Autor: Emiliano.
  """

  @doc "Entero al azar entre 1 y 1000, inclusive."
  def propuesta, do: :rand.uniform(1000)

  @doc "true solo cuando un entero al azar del 1 al 10 sale 3."
  def falla?, do: :rand.uniform(10) == 3

  @doc "Mínimo de propuestas válidas: división entera de n entre 2, más 1."
  def quorum(n) when is_integer(n) and n >= 1, do: div(n, 2) + 1

  @doc "true si las propuestas válidas alcanzan el quórum de n."
  def hay_consenso?(n, validas) when is_integer(n) and is_integer(validas) do
    validas >= quorum(n)
  end

  @doc "Regresa otra lista, ordenada de menor a mayor."
  def ordenar(valores) when is_list(valores), do: Enum.sort(valores)

  @doc "El menor de la lista: el valor del consenso."
  def acordado(valores) when is_list(valores) do
    valores |> ordenar() |> List.first()
  end
end
