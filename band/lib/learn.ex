defmodule Learn do

  use Application
  @moduledoc """
  Documentation for Learn.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Learn.hello
      :world

  """
  def start(_type, args) do
    Learn.Supervisor.start_link(args)
  end
end
