defmodule Appwrite.Types.AlgoPhpass do
  @moduledoc """
  Represents the PHPass hashing algorithm.

  ## Fields

    - `type` (`String.t`): Algorithm type.
  """

  @type t :: %__MODULE__{
          type: String.t()
        }

  defstruct [:type]
end
