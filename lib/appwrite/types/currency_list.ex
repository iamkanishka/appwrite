defmodule Appwrite.Types.CurrencyList do
  @moduledoc """
  Represents a list of currencies.

  ## Fields

    - `total` (`integer`): Total number of currencies that matched the query.
    - `currencies` (`[Appwrite.Types.Currency.t]`): List of currencies.
  """

  @type t :: %__MODULE__{
          total: integer(),
          currencies: [Appwrite.Types.Currency.t()]
        }

  defstruct [:total, :currencies]
end
