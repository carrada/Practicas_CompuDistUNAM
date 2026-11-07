# Pruebas de la práctica 3, según el PDF.
# Correr desde practica03: elixir pruebas.exs

Code.require_file("reglas.ex")
Code.require_file("salida.ex")

fallo = fn condicion, mensaje ->
  if condicion, do: raise(mensaje)
end

fallo.(Reglas.quorum(5) != 3, "con 5 procesos el quórum es 3")
fallo.(Reglas.quorum(4) != 3, "con 4 procesos el quórum es 3")
fallo.(Reglas.quorum(1) != 1, "con 1 proceso el quórum es 1")
fallo.(Reglas.hay_consenso?(5, 2), "2 propuestas no alcanzan con 5 procesos")
fallo.(not Reglas.hay_consenso?(5, 3), "3 propuestas sí alcanzan")
fallo.(Reglas.ordenar([410, 57, 95]) != [57, 95, 410], "la lista se ordena de menor a mayor")
fallo.(Reglas.acordado([410, 57, 95]) != 57, "el acuerdo es el menor")

Enum.each(1..100, fn _ ->
  propuesta = Reglas.propuesta()
  fallo.(propuesta < 1 or propuesta > 1000, "la propuesta sale de 1..1000")
end)

capturar = fn fun ->
  {:ok, entrada} = StringIO.open("")
  original = Process.group_leader()
  Process.group_leader(self(), entrada)
  fun.()
  Process.group_leader(self(), original)
  {_input, salida} = StringIO.contents(entrada)
  salida
end

texto = capturar.(fn ->
  Salida.iniciando()
  Salida.esperando()
  Salida.lista([57, 95, 319, 386, 410])
  Salida.no_consenso()
  Salida.resumen_consenso(5, 247, 3)
  Salida.separador_operacion()
  Salida.separador_final()
  Salida.resumen_final(5, 3, 3, 0)
end)

fallo.(not String.contains?(texto, "------ Iniciando consenso -----------"), "banner de inicio")
fallo.(not String.contains?(texto, "\"Estoy esperando mensajes\""), "la espera lleva comillas")
fallo.(not String.contains?(texto, "v=[57, 95, 319, 386, 410]"), "formato de v=")
fallo.(not String.contains?(texto, "No es posible llegar a un consenso"), "frase sin consenso")
fallo.(not String.contains?(texto, "El acuerdo es 247"), "el acuerdo")
fallo.(not String.contains?(texto, "Numero de procesos que terminaron el algoritmo 3"), "C sin acento en Numero")
fallo.(not String.contains?(texto, "------ Ejecucion de la operacion --------"), "banner de operacion")
fallo.(not String.contains?(texto, "----- Resumen final ---------"), "el resumen final empieza con cinco guiones")
fallo.(not String.contains?(texto, "Procesos que confirmaron la operación: 3"), "E con acento")
fallo.(not String.contains?(texto, "Procesos que no completaron la operación: 0"), "F con acento")

IO.puts("reglas y salida ok")

{salida_casos, 0} =
  System.cmd("elixir", ["-e", ~S"""
  Code.require_file("salida.ex")
  Code.require_file("reglas.ex")
  Code.require_file("lider.ex")

  defmodule Participante do
    def loop(id) do
      receive do
        {:proponer, lider} ->
          caso = Application.fetch_env!(:practica3, :caso)

          if id in caso.fallos_propuesta do
            send(lider, {:fallo_propuesta, id, 1000 - id})
          else
            send(lider, {:propuesta, id, 1000 - id})

            receive do
              {:decision, _valor} ->
                send(lider, {:decision_ok, id})

                receive do
                  {:operar, _valor} ->
                    if id in caso.fallos_operacion do
                      send(lider, {:fallo_operacion, id})
                    else
                      send(lider, {:registro_ok, id})
                    end
                end
            end
          end
      end
    end
  end

  correr = fn caso ->
    Application.put_env(:practica3, :caso, caso)
    {:ok, entrada} = StringIO.open("")
    original = Process.group_leader()
    Process.group_leader(self(), entrada)
    resultado = Lider.iniciar(5)
    Process.group_leader(self(), original)
    {_in, texto} = StringIO.contents(entrada)
    {resultado, texto}
  end

  sin = correr.(%{fallos_propuesta: [1, 2, 3], fallos_operacion: []})
  {resultado, texto} = sin
  if resultado != :sin_consenso, do: raise("debio no haber consenso, dio #{inspect(resultado)}")
  if not String.contains?(texto, "v=[995, 996]"), do: raise("v= del caso sin consenso: #{texto}")
  if not String.contains?(texto, "No es posible llegar a un consenso"), do: raise("falta la frase")
  if String.contains?(texto, "Resumen final"), do: raise("sin consenso no lleva resumen final")
  if String.contains?(texto, "Ejecucion de la operacion"), do: raise("sin consenso no opera")
  if String.contains?(texto, "El acuerdo es"), do: raise("sin consenso no anuncia acuerdo")

  con = correr.(%{fallos_propuesta: [1, 2], fallos_operacion: []})
  {resultado, texto} = con
  {:ok, resumen} = resultado
  if resumen.valor != 995, do: raise("el menor de 995, 996 y 997 es 995, dio #{resumen.valor}")
  if resumen.c != 3 or resumen.e != 3 or resumen.f != 0, do: raise("C=3 E=3 F=0, dio #{inspect(resumen)}")
  if not String.contains?(texto, "v=[995, 996, 997]"), do: raise("lista valida #{texto}")
  if not String.contains?(texto, "El acuerdo es 995"), do: raise("acuerdo")
  if not String.contains?(texto, "Numero de procesos que terminaron el algoritmo 3"), do: raise("C")
  if not String.contains?(texto, "Procesos que confirmaron la operación: 3"), do: raise("E")
  if not String.contains?(texto, "Procesos que no completaron la operación: 0"), do: raise("F no cuenta a quien cayo en la propuesta")
  esperas = texto |> String.split("\n") |> Enum.count(&(&1 == "\"Estoy esperando mensajes\""))
  if esperas != 2, do: raise("con consenso se espera dos veces, hubo #{esperas}")

  mixto = correr.(%{fallos_propuesta: [], fallos_operacion: [1, 2]})
  {{:ok, resumen}, texto} = mixto
  if resumen.c != 5 or resumen.e != 3 or resumen.f != 2, do: raise("cinco propusieron, dos fallan la operacion: #{inspect(resumen)}")
  if resumen.e + resumen.f != resumen.c, do: raise("E + F tiene que ser C")
  if not String.contains?(texto, "El acuerdo es 995"), do: raise("minimo de 995..999")

  IO.puts("casos del lider ok")
  """], cd: __DIR__)

IO.puts(String.trim(salida_casos))

Code.require_file("participante.ex")
Code.require_file("lider.ex")
Code.require_file("consenso.ex")

revisar_corrida = fn texto, n ->
  propuestas =
    Regex.scan(~r/El proceso (#PID<\d+\.\d+\.\d+>) propone (\d+), 1 veces/, texto)

  fallos_propuesta =
    Regex.scan(~r/El proceso (#PID<\d+\.\d+\.\d+>) propone (\d+), antes de fallar/, texto)

  if length(propuestas) + length(fallos_propuesta) != n do
    raise("cada proceso propone o falla una vez:\n#{texto}")
  end

  valores =
    Enum.map(propuestas, fn [_, _pid, valor] -> String.to_integer(valor) end) |> Enum.sort()

  [lista] = Regex.run(~r/v=\[([^\]]*)\]/, texto) |> Enum.drop(1)

  leidos =
    if lista == "" do
      []
    else
      lista |> String.split(", ") |> Enum.map(&String.to_integer/1)
    end

  if leidos != valores, do: raise("v= no es la lista ordenada de propuestas validas:\n#{texto}")

  sin_consenso = String.contains?(texto, "No es posible llegar a un consenso")

  if sin_consenso do
    if length(valores) >= Reglas.quorum(n), do: raise("anuncio sin consenso con quórum")
    if String.contains?(texto, "Resumen final"), do: raise("no debe operar ni resumir")
    if String.contains?(texto, "registra el valor"), do: raise("no registra sin consenso")
  else
    if length(valores) < Reglas.quorum(n), do: raise("siguio sin quórum")
    [acuerdo] = Regex.run(~r/El acuerdo es (\d+)/, texto) |> Enum.drop(1)
    if String.to_integer(acuerdo) != hd(valores), do: raise("el acuerdo no es el menor")

    decisiones = Regex.scan(~r/El proceso (#PID<\d+\.\d+\.\d+>) propone (\d+), 2 veces/, texto)
    [c] = Regex.run(~r/Numero de procesos que terminaron el algoritmo (\d+)/, texto) |> Enum.drop(1)
    if length(decisiones) != String.to_integer(c), do: raise("C no coincide con las decisiones")
    if String.to_integer(c) != length(valores), do: raise("C debe ser el numero de propuestas validas")

    pids_ok = MapSet.new(Enum.map(propuestas, fn [_, pid, _] -> pid end))
    Enum.each(decisiones, fn [_, pid, valor] ->
      if not MapSet.member?(pids_ok, pid), do: raise("decidio alguien que no propuso")
      if String.to_integer(valor) != String.to_integer(acuerdo), do: raise("la decision no muestra el valor acordado")
    end)

    registros = Regex.scan(~r/El proceso (#PID<\d+\.\d+\.\d+>) registra el valor (\d+)/, texto)
    fallos_op = Regex.scan(~r/El proceso (#PID<\d+\.\d+\.\d+>) falla al ejecutar la operacion/, texto)
    [e] = Regex.run(~r/Procesos que confirmaron la operación: (\d+)/, texto) |> Enum.drop(1)
    [f] = Regex.run(~r/Procesos que no completaron la operación: (\d+)/, texto) |> Enum.drop(1)

    if length(registros) != String.to_integer(e), do: raise("E")
    if length(fallos_op) != String.to_integer(f), do: raise("F")
    if String.to_integer(e) + String.to_integer(f) != String.to_integer(c), do: raise("E + F = C")

    pids_caidos = MapSet.new(Enum.map(fallos_propuesta, fn [_, pid, _] -> pid end))
    Enum.each(registros ++ fallos_op, fn
      [_, pid, valor] ->
        if MapSet.member?(pids_caidos, pid), do: raise("quien fallo la propuesta no opera")
        if String.to_integer(valor) != String.to_integer(acuerdo), do: raise("registro de otro valor")
      [_, pid] ->
        if MapSet.member?(pids_caidos, pid), do: raise("quien fallo la propuesta no opera")
    end)
  end
end

Enum.each(1..20, fn _ ->
  texto = capturar.(fn -> Consenso.iniciar(5) end)
  revisar_corrida.(texto, 5)
end)

IO.puts("20 corridas reales con 5 procesos ok")
IO.puts("pruebas ok")
