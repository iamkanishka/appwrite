defmodule Appwrite.Types.Phone do
  @moduledoc """
  Represents a phone dialling code associated with a country.

  ## Fields

    - `code` (`String.t()`): Phone dialling code (e.g. `"+1"`).
    - `country_code` (`String.t()`): Two-character ISO 3166-1 alpha country code.
    - `country_name` (`String.t()`): Country name.
  """

  @derive Jason.Encoder

  @type t :: %__MODULE__{
          code: String.t(),
          country_code: String.t(),
          country_name: String.t()
        }

  defstruct [:code, :country_code, :country_name]
end
