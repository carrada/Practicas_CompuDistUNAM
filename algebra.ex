defmodule Algebra do
  @moduledoc """
  Búsqueda de números primos en un intervalo cerrado [a, b]
  mediante una criba segmentada.
  Creado por Emilio Durán Tapia
  """

  @doc """
  Regresa los números primos de [a, b] ordenados de menor a mayor.
  """

  # Resuelve todos los casos en los que el intervalo no contiene resultados.
  def primes_between(a, b)
      when not is_integer(a) or not is_integer(b) or a > b or b < 2 do
    []
  end

  # Calcula los primos base y tacha sus múltiplos dentro del intervalo.
  def primes_between(a, b) do
    limite_izquierdo = max(a, 2)

    raiz_aproximada = trunc(:math.sqrt(b))
    raiz = integer_sqrt(raiz_aproximada, b)

    primos_base = primes_up_to(raiz)
    candidatos = build_range(limite_izquierdo, b)

    sieve_segment(candidatos, primos_base)
  end

  # Corrige la raíz entera por posibles errores de redondeo de sqrt.
  defp integer_sqrt(r, n) when (r + 1) * (r + 1) <= n do
    integer_sqrt(r + 1, n)
  end

  # Corrige hacia abajo si sqrt produjo una aproximación demasiado grande.
  defp integer_sqrt(r, n) when r * r > n do
    integer_sqrt(r - 1, n)
  end

  # Regresa la raíz entera correcta.
  defp integer_sqrt(r, _n) do
    r
  end

  # Obtiene los primos desde 2 hasta la raíz mediante la criba clásica.
  defp primes_up_to(root) when root < 2 do
    []
  end

  # Construye la lista de candidatos y aplica la criba clásica.
  defp primes_up_to(root) do
    numeros = build_range(2, root)
    classic_sieve(numeros)
  end

  # Aplica recursivamente la criba clásica hasta terminar la lista.
  defp classic_sieve([]) do
    []
  end

  # Conserva la cabeza como primo y elimina sus múltiplos del resto.
  defp classic_sieve([p | rest]) do
    [p | classic_sieve(remove_multiples(rest, p))]
  end

  # Elimina recursivamente los múltiplos de un primo de una lista.
  defp remove_multiples([], _p) do
    []
  end

  # Conserva un número cuando no es divisible entre el primo.
  defp remove_multiples([x | rest], p) when rem(x, p) != 0 do
    [x | remove_multiples(rest, p)]
  end

  # Elimina un número cuando es múltiplo del primo.
  defp remove_multiples([_x | rest], p) do
    remove_multiples(rest, p)
  end

  # Recorre los candidatos y tacha los múltiplos de cada primo base.
  defp sieve_segment(candidates, []) do
    candidates
  end

  # Tacha los múltiplos de un primo, conservando al propio primo.
  defp sieve_segment(candidates, [p | rest]) do
    candidatos_filtrados = remove_multiples_keep_self(candidates, p)
    sieve_segment(candidatos_filtrados, rest)
  end

  # Elimina los múltiplos de p excepto cuando el elemento es p mismo.
  defp remove_multiples_keep_self([], _p) do
    []
  end

  # Conserva el propio primo aunque sea divisible entre sí mismo.
  defp remove_multiples_keep_self([p | rest], p) do
    [p | remove_multiples_keep_self(rest, p)]
  end

  # Conserva los números que no son múltiplos de p.
  defp remove_multiples_keep_self([x | rest], p) when rem(x, p) != 0 do
    [x | remove_multiples_keep_self(rest, p)]
  end

  # Elimina los números que son múltiplos de p.
  defp remove_multiples_keep_self([_x | rest], p) do
    remove_multiples_keep_self(rest, p)
  end

  # Construye recursivamente una lista ascendente desde start hasta finish.
  defp build_range(start, finish) when start > finish do
    []
  end

  # Agrega el número actual y continúa hasta llegar al final.
  defp build_range(start, finish) do
    [start | build_range(start + 1, finish)]
  end
end
```

