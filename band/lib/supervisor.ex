defmodule Learn.Supervisor do
  use Supervisor

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args)
  end

  def init() do
    init(:lenient)
  end
  def init(:lenient) do
    IO.puts("INIT :lenient")
    init({:one_for_one, 3, 60})
  end
  def init(:angry) do
    IO.puts("INIT :angry")
    init({:rest_for_one, 2, 60})
  end
  def init(:jerk) do
    IO.puts("INIT :jerk")
    init({:one_for_all, 1, 60})
  end

  def init({strategy, max_restart, max_time}) do
    children = [
      worker(Learn.Musicians, [:bass, :bad], [id: "b_bass", restart: :permanent, shutdown: 1000]),
      worker(Learn.Musicians, [:drums, :bad], [id: "b_drums", restart: :temporary, shutdown: 1000]),
      worker(Learn.Musicians, [:keytar, :good], [id: "g_keytar", restart: :transient, shutdown: 1000])
    ]

    # supervise/2 is imported from Supervisor.Spec
    supervise(children, strategy: strategy, max_restart: max_restart, max_seconds: max_time)
  end

end
