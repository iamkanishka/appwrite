defmodule Appwrite.Types.Language do
  @moduledoc """
  Represents a language with its ISO code and native name.

  ## Fields

    - `name` (`String.t`): Language name.
    - `code` (`String.t`): ISO 639-1 two-character code.
    - `native_name` (`String.t`): Native language name.
  """

  @type t :: %__MODULE__{
          name: String.t(),
          code: String.t(),
          native_name: String.t()
        }

  defstruct [:name, :code, :native_name]
end
