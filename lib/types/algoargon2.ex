defmodule Appwrite.Types.AlgoArgon2 do
  @moduledoc """
  Represents the Argon2 hashing algorithm.

  ## Fields

    - `type` (`String.t`): Algorithm type.
    - `memory_cost` (`non_neg_integer`): Memory used to compute hash.
    - `time_cost` (`non_neg_integer`): Amount of time consumed to compute hash.
    - `threads` (`non_neg_integer`): Number of threads used to compute hash.
  """

  @type t :: %__MODULE__{
          type: String.t(),
          memory_cost: non_neg_integer(),
          time_cost: non_neg_integer(),
          threads: non_neg_integer()
        }

  defstruct [:type, :memory_cost, :time_cost, :threads]
end
