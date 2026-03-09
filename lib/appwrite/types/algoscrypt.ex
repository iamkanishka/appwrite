defmodule Appwrite.Types.AlgoScrypt do
  @moduledoc """
  Parameters for the standard Scrypt password hashing algorithm.

  ## Fields

  - `type` (`String.t()`) — always `"scrypt"`.
  - `cpu_cost` (`non_neg_integer()`) — CPU/memory cost parameter `N`
    (must be a power of 2).
  - `memory_cost` (`non_neg_integer()`) — block size parameter `r`.
  - `parallel` (`non_neg_integer()`) — parallelisation parameter `p`.
  - `length` (`non_neg_integer()`) — desired key length in bytes.
  """

  @derive Jason.Encoder

  @type t :: %__MODULE__{
          type: String.t(),
          cpu_cost: non_neg_integer(),
          memory_cost: non_neg_integer(),
          parallel: non_neg_integer(),
          length: non_neg_integer()
        }

  defstruct [:type, :cpu_cost, :memory_cost, :parallel, :length]
end
