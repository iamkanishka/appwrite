defmodule Appwrite.Types.ContinentList do
  @moduledoc """
  Represents a list of continents.

  ## Fields

    - `total` (`integer`): Total number of continents that matched the query.
    - `continents` (`[Appwrite.Types.Continent.t]`): List of continents.
  """

  @type t :: %__MODULE__{
          total: integer(),
          continents: [Appwrite.Types.Continent.t()]
        }

  defstruct [:total, :continents]
end
