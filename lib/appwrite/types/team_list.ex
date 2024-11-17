defmodule Appwrite.Types.TeamList do
  @moduledoc """
  Represents a list of teams.

  ## Fields

    - `total` (`integer`): Total number of teams that matched the query.
    - `teams` (`[Appwrite.Types.Team.t]`): List of teams.
  """

  @type t :: %__MODULE__{
          total: integer(),
          teams: [Appwrite.Types.Team.t()]
        }

  defstruct [:total, :teams]
end
