defmodule algebra do
    def primo_intervalo(a, b) when a > b do
    []
end

def primo_intervalo(a, b) do
    primo_intervalo(a, b, a)
end

defp primo_intervalo(act, b, _)
    when act > b do
    []
end