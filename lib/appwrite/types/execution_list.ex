defmodule Appwrite.Types.ExecutionList do
  @moduledoc """
  Paginated list of `Appwrite.Types.Execution` records.

  ## Fields

  - `total` (`non_neg_integer()`) — total executions matching the query.
  - `executions` (`[Appwrite.Types.Execution.t()]`) — current page of results.
  """

  @derive Jason.Encoder

  @type t :: %__MODULE__{
          total: non_neg_integer(),
          executions: [Appwrite.Types.Execution.t()]
        }

  defstruct [:total, :executions]
end
