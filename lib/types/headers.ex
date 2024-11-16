defmodule Appwrite.Types.Headers do
  @moduledoc """
  Represents an HTTP header with name and value.

  ## Fields

    - `name` (`String.t`): Header name.
    - `value` (`String.t`): Header value.
  """

  @type t :: %__MODULE__{
          name: String.t(),
          value: String.t()
        }

  defstruct [:name, :value]
end
