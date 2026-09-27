# Función principal
# Recibe el inicio y el final de un intervalo
defmodule Algebra do
@moduledoc """
        La criba es sobre un intervalo cerrado. Creado por Emilio Durán Tapia
    """

@doc """
        Función que devuelve una lista con los números primos entre a y b.
    """

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

defp primes_between(act, b, _)
    when act < 2 do
        primes_between(act + 1, b, act)
end

defp primes_between(act, b, _) do
    if is_prime(act) do
        [act | primes_between(act + 1, b, act)]
    else
        primes_between(act + 1, b, act)
    end
 end

 # Revisa si un número es primo
defp is_prime(n) when n < 2 do
    false
end

defp is_prime(2) do
    true
end

defp is_prime(n) do
    no_divisors(n, 2)
end

# Busca la existencia de un divisor
defp no_divisors(n, i) when i * i > n do
    true
end

defp no_divisors(n, i) do
    if rem(n, i) == 0 do
        false
    else 
        no_divisors(n, i + 1)
        end
    end
end
