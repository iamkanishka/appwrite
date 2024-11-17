defmodule Appwrite.Types.CountryList do
  @moduledoc """
  Represents a list of countries.

  ## Fields

    - `total` (`integer`): Total number of countries that matched the query.
    - `countries` (`[Appwrite.Types.Country.t]`): List of countries.
  """

  @type t :: %__MODULE__{
          total: integer(),
          countries: [Appwrite.Types.Country.t()]
        }

  defstruct [:total, :countries]
end
