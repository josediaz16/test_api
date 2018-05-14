defmodule RabbitmqServiceTest do
  use ExUnit.Case
  doctest RabbitmqService

  test "greets the world" do
    assert RabbitmqService.hello() == :world
  end
end
