defmodule Appwrite.Types.Phone do
  @moduledoc """
  Represents a phone code associated with a country.

  ## Fields

    - `code` (`String.t`): Phone code.
    - `country_code` (`String.t`): Two-character ISO 3166-1 alpha code.
    - `country_name` (`String.t`): Country name.
  """

  @type t :: %__MODULE__{
          code: String.t(),
          country_code: String.t(),
          country_name: String.t()
        }

  defstruct [:code, :country_code, :country_name]
end
