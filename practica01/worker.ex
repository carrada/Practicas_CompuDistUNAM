defmodule Worker do
  @moduledoc """
  Proceso trabajador: recibe un intervalo, pide sus primos y responde al coordinador.
  Autor: Emiliano.
  """

  @doc "Espera un trabajo, calcula los primos del intervalo y responde al coordinador."
  def loop do
    receive do
      {:trabajo, id, a, b, pid_coordinador} ->
        primos = Algebra.primes_between(a, b)
        send(pid_coordinador, {:resultado, id, primos})
    end
  end
end
