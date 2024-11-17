defmodule Appwrite.Types.LogList do
  @moduledoc """
  Represents a list of logs.

  ## Fields

    - `total` (`integer`): Total number of logs that matched the query.
    - `logs` (`[Appwrite.Types.Log.t]`): List of logs.
  """

  @type t :: %__MODULE__{
          total: integer(),
          logs: [Appwrite.Types.Log.t()]
        }

  defstruct [:total, :logs]
end
