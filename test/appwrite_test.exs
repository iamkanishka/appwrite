defmodule AppwriteTest do
  use ExUnit.Case
  doctest Appwrite

  test "greets the world" do
    assert Appwrite.hello() == :world
  end
end
