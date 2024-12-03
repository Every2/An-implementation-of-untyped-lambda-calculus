defmodule LambdaCalculusTest do
  use ExUnit.Case
  doctest LambdaCalculus

  test "greets the world" do
    assert LambdaCalculus.hello() == :world
  end
end
