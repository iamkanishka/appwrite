defmodule Appwrite.Types.Continent do
  @moduledoc """
  Represents a continent with name and two-letter code.

  ## Fields

    - `name` (`String.t`): Continent name.
    - `code` (`String.t`): Two-letter continent code.
  """

  @type t :: %__MODULE__{
          name: String.t(),
          code: String.t()
        }

  defstruct [:name, :code]
end
