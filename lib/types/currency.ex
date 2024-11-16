defmodule Appwrite.Types.Currency do
  @moduledoc """
  Represents a currency with details like symbol, name, and code.

  ## Fields

    - `symbol` (`String.t`): Currency symbol.
    - `name` (`String.t`): Currency name.
    - `symbol_native` (`String.t`): Native currency symbol.
    - `decimal_digits` (`integer`): Number of decimal digits.
    - `rounding` (`float`): Currency digit rounding.
    - `code` (`String.t`): ISO 4217 currency code.
    - `name_plural` (`String.t`): Plural name of the currency.
  """

  @type t :: %__MODULE__{
          symbol: String.t(),
          name: String.t(),
          symbol_native: String.t(),
          decimal_digits: integer(),
          rounding: float(),
          code: String.t(),
          name_plural: String.t()
        }

  defstruct [:symbol, :name, :symbol_native, :decimal_digits, :rounding, :code, :name_plural]
end
