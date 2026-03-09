defmodule Appwrite.Types.CurrencyList do
  @moduledoc """
  Paginated list of `Appwrite.Types.Currency` records.

  ## Fields

  - `total` (`non_neg_integer()`) — total number of currencies matching the
    query.
  - `currencies` (`[Appwrite.Types.Currency.t()]`) — page of results.
  """

  @derive Jason.Encoder

  @type t :: %__MODULE__{
          total: non_neg_integer(),
          currencies: [Appwrite.Types.Currency.t()]
        }

  defstruct [:total, :currencies]
end
