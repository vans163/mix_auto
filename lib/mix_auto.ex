defmodule MixAuto do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(MixAuto.Worker, [])
    ]

    opts = [strategy: :one_for_one, name: MixAuto.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

defmodule MixAuto.Worker do
  use GenServer
  require Logger

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    case :os.type() do
      {:unix, :linux} ->
        Logger.info "#{__MODULE__}: Started watcher on lib/"
        :inotify_folder_watcher.start_link({["lib"], self()})

      _ ->
        Logger.error "#{__MODULE__}: Your OS is not supported, open a pull if you want support https://github.com/vans163/mix_auto/pulls"
    end

    {:ok, %{timers: %{}}}
  end

  def handle_info(:recompile, s) do
    IEx.Helpers.recompile
    {:noreply, s}
  end

  def handle_info({:recompile, filename}, s) do
    mods = IEx.Helpers.c(filename, :in_memory)
    for mod<-mods, do: IEx.Helpers.l(mod)

    {:noreply, s}
  end

  def handle_info({:inotify, :changed, filename}, s) do
    Logger.info "#{__MODULE__}: File changed #{filename}"
    case :filename.extension(filename) do
      ".ex" ->
        case :maps.get(filename, s.timers, :undefined) do
          :undefined ->
            timer = :erlang.send_after(300, self(), {:recompile, filename})
            {:noreply, %{s | timers: Map.put(s.timers, filename, timer)}}

          timer ->
            :erlang.cancel_timer(timer)
            timer = :erlang.send_after(300, self(), {:recompile, filename})
            {:noreply, %{s | timers: Map.put(s.timers, filename, timer)}}

        end
      _ -> {:noreply, s}
    end
  end

end
