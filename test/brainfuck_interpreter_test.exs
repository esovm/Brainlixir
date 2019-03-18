defmodule BrainfuckInterpreterTest do
  use ExUnit.Case
  doctest BrainfuckInterpreter

  test "greets the world" do
    assert BrainfuckInterpreter.hello() == :world
  end
end
