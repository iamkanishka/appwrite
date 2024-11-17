defmodule Appwrite.Types.ExecutionList do
  @moduledoc """
  Represents a list of executions.

  ## Fields

    - `total` (`integer`): Total number of executions that matched the query.
    - `executions` (`[Appwrite.Types.Execution.t]`): List of executions.
  """

  @type t :: %__MODULE__{
          total: integer(),
          executions: [Appwrite.Types.Execution.t()]
        }

  defstruct [:total, :executions]
end
