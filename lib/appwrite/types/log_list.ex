defmodule Appwrite.Types.LogList do
  @moduledoc """
  Represents a list of logs.

  ## Fields

    - `total` (`non_neg_integer()`): Total number of logs that matched the query.
    - `logs` (`[Appwrite.Types.Log.t()]`): List of logs.
  """

  @derive Jason.Encoder

  @type t :: %__MODULE__{
          total: non_neg_integer(),
          logs: [Appwrite.Types.Log.t()]
        }

  defstruct [:total, :logs]
end
