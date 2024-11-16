defmodule Appwrite.Types.AlgoBcrypt do
  @moduledoc """
  Represents the Bcrypt hashing algorithm.

  ## Fields

    - `type` (`String.t`): Algorithm type.
  """

  @type t :: %__MODULE__{
          type: String.t()
        }

  defstruct [:type]
end
