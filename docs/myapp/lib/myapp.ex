defmodule Myapp do
  @moduledoc """
  Documentation for Myapp.
  """
  use Application

  def start(_type, _args) do
    Myapp.Supervisor.start_link()
  end

  @doc """
  Hello world.

  ## Examples

      iex> Myapp.hello()
      :world

  """
  def hello do
    :world
  end
end
