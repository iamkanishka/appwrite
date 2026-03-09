defmodule Appwrite.Types.TeamList do
  @moduledoc """
  Represents a list of teams.

  ## Fields

    - `total` (`non_neg_integer()`): Total number of teams that matched the query.
    - `teams` (`[Appwrite.Types.Team.t()]`): List of teams.
  """

  @derive Jason.Encoder

  @type t :: %__MODULE__{
          total: non_neg_integer(),
          teams: [Appwrite.Types.Team.t()]
        }

  defstruct [:total, :teams]
end
