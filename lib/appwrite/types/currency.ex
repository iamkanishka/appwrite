defmodule Appwrite.Types.Currency do
  @moduledoc """
  A currency record returned by `GET /v1/locale/currencies`.

  ## Fields

  - `symbol` (`String.t()`) — display symbol (e.g. `"$"`).
  - `name` (`String.t()`) — human-readable name (e.g. `"US Dollar"`).
  - `symbol_native` (`String.t()`) — native script symbol (e.g. `"$"`).
  - `decimal_digits` (`non_neg_integer()`) — standard decimal precision.
  - `rounding` (`float()`) — smallest currency unit for rounding (e.g. `0.0`
    for most currencies, `0.05` for Swiss francs).
  - `code` (`String.t()`) — ISO 4217 code (e.g. `"USD"`).
  - `name_plural` (`String.t()`) — plural name (e.g. `"US dollars"`).
  """

  @derive Jason.Encoder

  @type t :: %__MODULE__{
          symbol: String.t(),
          name: String.t(),
          symbol_native: String.t(),
          decimal_digits: non_neg_integer(),
          rounding: float(),
          code: String.t(),
          name_plural: String.t()
        }

  defstruct [:symbol, :name, :symbol_native, :decimal_digits, :rounding, :code, :name_plural]
end
