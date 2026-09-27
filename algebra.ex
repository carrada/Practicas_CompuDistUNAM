@moduledoc "La criba es sobre un intervalo cerrado. Creado por Emilio Durán Tapia"

# Función principal
# Recibe el inicio y el final de un intervalo

@doc """
    Función que devuelve una lista con los números primos entre a y b.
    ## Ejemplo
        iex> algebra.primes_between(1, 10)
        [2, 3, 5, 7]
    """
defmodule algebra do
    def primes_between(a, b) when a > b do
    []
end

def primes_between(a, b) do
    primes_between(a, b, a)
end

# Se recorren los números del intervalo
defp primes_between(act, b, _)
    when act > b do
    []
end

defp primes_between(act, b, _)do
if esprimo(actual) do
[]