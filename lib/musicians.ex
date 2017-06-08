defmodule Learn.Musicians do

  defstruct name: "", role:  nil, skill: :good
  @delay 400

  use GenServer

  def start_link(role, skill) do
    GenServer.start_link(__MODULE__, [role, skill], [name: role])
  end

  def init([role, skill]) do
    Process.flag(:trap_exit, true)

    time_to_play = :random.uniform(3000)
    name = pick_name()
    role_str = Atom.to_string(role)

    IO.puts("Musician #{name}, playing the #{skill} entered the room")

    {
      :ok,
      %Learn.Musicians{name: name, role: role_str, skill: skill},
      time_to_play
    }
  end

  def stop(role) do
    GenServer.call(role, :stop)
  end

  defp pick_name do
    f_names = ["Yura", "Jack", "Ivan", "Zoriana", "Oleg"]
    l_names = ["Zdyrko", "Smith", "Blane", "Dzhmil", "Bonk"]
    Enum.random(f_names) <> " " <> Enum.random(l_names)
  end

  def handle_call(:stop, _from, s) do
    {:stop, :normal, :ok, s}
  end
  def handle_call(_, _from, s) do
    {:noreply, s, @delay}
  end
  def handle_cast(_, s) do
    {:noreply, s, @delay}
  end

  def handle_info(:timeout, s = %Learn.Musicians{name: n, skill: :good}) do
    IO.puts("#{n} produced a sound")
    {:noreply, s, @delay}
  end
  def handle_info(:timeout, s = %Learn.Musicians{name: n, skill: :bad}) do
    case :random.uniform(3) do
      1 ->
        {:stop, :bad_note, s}
      _ ->
        IO.puts("#{n} produced a sound")
        {:noreply, s, @delay}
    end
  end

  def terminate(:normal, s), do: IO.puts("#{s.name} left the room")
  def terminate(:bad_note, s), do: IO.puts("#{s.name} bad note")
  def terminate(:shutdown, s), do: IO.puts("#{s.name} Manager fired everyone")
  def terminate(_reason, s), do: IO.puts("#{s.name} has been kicked out")
end
