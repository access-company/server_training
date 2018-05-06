defmodule MyappTest do
  use ExUnit.Case
  doctest Myapp

  test "greets the world" do
    assert Myapp.hello() == :world
  end
end
