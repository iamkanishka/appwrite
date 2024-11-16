defmodule Appwrite.Types.AlgoMd5 do
  @moduledoc """
  Represents the MD5 hashing algorithm.

  ## Fields

    - `type` (`String.t`): Algorithm type.
  """

  @type t :: %__MODULE__{
          type: String.t()
        }

  defstruct [:type]
end
