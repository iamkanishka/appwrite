defmodule Appwrite.Types.ContinentList do
  @moduledoc """
  Paginated list of `Appwrite.Types.Continent` records.

  ## Fields

  - `total` (`non_neg_integer()`) — total number of continents matching the
    query (useful when a cursor or offset is applied).
  - `continents` (`[Appwrite.Types.Continent.t()]`) — page of results.
  """

  @derive Jason.Encoder

  @type t :: %__MODULE__{
          total: non_neg_integer(),
          continents: [Appwrite.Types.Continent.t()]
        }

  defstruct [:total, :continents]
end
