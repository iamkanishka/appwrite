defmodule Appwrite.Types.Country do
  @moduledoc """
  Represents a country with name and ISO code.

  ## Fields

    - `name` (`String.t`): Country name.
    - `code` (`String.t`): Two-character ISO 3166-1 alpha code.
  """

  @type t :: %__MODULE__{
          name: String.t(),
          code: String.t()
        }

  defstruct [:name, :code]
end
