defmodule Appwrite.Types.LocaleCode do
  @moduledoc """
  Represents a locale code and its display name.

  ## Fields

    - `code` (`String.t()`): Locale code in ISO 639-1 format.
    - `name` (`String.t()`): Locale display name.
  """

  @derive Jason.Encoder

  @type t :: %__MODULE__{
          code: String.t(),
          name: String.t()
        }

  defstruct [:code, :name]
end
