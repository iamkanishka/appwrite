defmodule Appwrite.Consts.ExecutionMethod do
  @moduledoc """
  HTTP methods accepted by the Appwrite Functions execution endpoint.

  | Method    | Value       |
  |-----------|-------------|
  | GET       | `"GET"`     |
  | POST      | `"POST"`    |
  | PUT       | `"PUT"`     |
  | PATCH     | `"PATCH"`   |
  | DELETE    | `"DELETE"`  |
  | OPTIONS   | `"OPTIONS"` |
  """

  use Appwrite.Consts.Behaviour,
    values: ~w(GET POST PUT PATCH DELETE OPTIONS),
    name: "execution method"
end
