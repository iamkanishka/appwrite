defmodule Appwrite.Types.AlgoSha do
  @moduledoc """
  Represents the SHA hashing algorithm.

  ## Fields

    - `type` (`String.t`): Algorithm type.
  """

  @type t :: %__MODULE__{
          type: String.t()
        }

  defstruct [:type]
end
