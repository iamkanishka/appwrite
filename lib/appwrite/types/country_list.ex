defmodule Appwrite.Types.CountryList do
  @moduledoc """
  Paginated list of `Appwrite.Types.Country` records.

  ## Fields

  - `total` (`non_neg_integer()`) — total number of countries matching the
    query.
  - `countries` (`[Appwrite.Types.Country.t()]`) — page of results.
  """

  @derive Jason.Encoder

  @type t :: %__MODULE__{
          total: non_neg_integer(),
          countries: [Appwrite.Types.Country.t()]
        }

  defstruct [:total, :countries]
end
