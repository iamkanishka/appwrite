defmodule Appwrite.Types.AlgoScryptModified do
  @moduledoc """
  Represents the modified Scrypt hashing algorithm.

  ## Fields

    - `type` (`String.t`): Algorithm type.
    - `salt` (`String.t`): Salt used to compute hash.
    - `salt_separator` (`String.t`): Separator used to compute hash.
    - `signer_key` (`String.t`): Key used to compute hash.
  """

  @type t :: %__MODULE__{
          type: String.t(),
          salt: String.t(),
          salt_separator: String.t(),
          signer_key: String.t()
        }

  defstruct [:type, :salt, :salt_separator, :signer_key]
end
