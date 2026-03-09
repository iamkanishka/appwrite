defmodule Appwrite.Types.AlgoArgon2 do
  @moduledoc """
  Parameters for the Argon2id password hashing algorithm.

  Argon2id is the recommended algorithm for new Appwrite projects. The
  three tuning knobs control the memory-hardness, time-hardness, and
  parallelism of the hash function.

  ## Fields

  - `type` (`String.t()`) — always `"argon2"`.
  - `memory_cost` (`non_neg_integer()`) — memory consumed in kibibytes.
  - `time_cost` (`non_neg_integer()`) — number of iterations.
  - `threads` (`non_neg_integer()`) — degree of parallelism.
  """

  @derive Jason.Encoder

  @type t :: %__MODULE__{
          type: String.t(),
          memory_cost: non_neg_integer(),
          time_cost: non_neg_integer(),
          threads: non_neg_integer()
        }

  defstruct [:type, :memory_cost, :time_cost, :threads]
end
