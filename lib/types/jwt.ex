defmodule Appwrite.Types.Jwt do
  @moduledoc """
  Represents a JWT token.

  ## Fields

    - `jwt` (`String.t`): JWT encoded string.
  """

  @type t :: %__MODULE__{
          jwt: String.t()
        }

  defstruct [:jwt]
end
