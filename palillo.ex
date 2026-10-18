# palillo.ex
defmodule Palillo do
  @moduledoc """
  Módulo que modela un palillo en el problema de los filósofos comensales.
  Creado por Emilio Durán Tapia
  """

  @doc """
  Punto de entrada para el proceso.
  Se invoca típicamente mediante:
      spawn(Palillo, :loop, [id])

  Inicializa el proceso con:
  - id: Identificador único del palillo.
  - estado: :libre
  - dueño: nil (sin poseedor)
  - cola: [] (cola de espera vacía de tuplas {pid_filosofo, id_filosofo})
  """
  def loop(id) do
    loop(id, :libre, nil, [])
  end

  def loop(id, :libre, _dueno, cola) do
    receive do
      {:solicitar, pid_filosofo, id_filosofo} ->
        # Se otorga inmediatamente el palillo al filósofo solicitante
        send(pid_filosofo, {:conceder, id})
        # Pasa a :ocupado, registrando al filósofo como dueño
        loop(id, :ocupado, {pid_filosofo, id_filosofo}, cola)

      {:liberar, _pid_filosofo, _id_filosofo} ->
        # Estando libre no hay dueño asignado; cualquier señal de liberación
        # es ajena y se ignora sin alterar el estado ni la cola.
        loop(id, :libre, nil, cola)
    end
  end

  def loop(id, :ocupado, {dueno_pid, _dueno_id} = dueno, cola) do
    receive do
      {:solicitar, pid_filosofo, id_filosofo} ->
        # El palillo está ocupado: no se contesta todavía.
        # Se agrega la tupla {pid_filosofo, id_filosofo} al final de la cola de espera.
        nueva_cola = cola ++ [{pid_filosofo, id_filosofo}]
        loop(id, :ocupado, dueno, nueva_cola)

      {:liberar, ^dueno_pid, _id_filosofo} ->
        # La liberación proviene legítimamente del dueño actual
        case cola do
          [] ->
            # Si la cola está vacía, vuelve a :libre y olvida al dueño
            loop(id, :libre, nil, [])

          [{sig_pid, sig_id} | resto] ->
            # Si hay alguien en la cola:
            # 1. Se extrae al filósofo del frente
            # 2. Se le envía {:conceder, id}
            # 3. Pasa a ser el nuevo dueño, manteniéndose en :ocupado
            send(sig_pid, {:conceder, id})
            loop(id, :ocupado, {sig_pid, sig_id}, resto)
        end

      {:liberar, _otro_pid, _id_filosofo} ->
        # Si el mensaje de liberación no proviene del dueño actual,
        # no se altera el estado ni la cola. Sigue esperando.
        loop(id, :ocupado, dueno, cola)
    end
  end

  # Cláusula de compatibilidad en caso de que el dueño sea un PID directo
  def loop(id, :ocupado, dueno_pid, cola) when is_pid(dueno_pid) do
    loop(id, :ocupado, {dueno_pid, nil}, cola)
  end
end