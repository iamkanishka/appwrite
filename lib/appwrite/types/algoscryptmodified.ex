defmodule Appwrite.Types.AlgoScryptModified do
  @moduledoc """
  Parameters for the modified Scrypt algorithm used by Firebase.

  This variant is provided to support password migration from Firebase
  Authentication and includes the Firebase-specific key material.

  ## Fields

  - `type` (`String.t()`) — always `"scryptMod"`.
  - `salt` (`String.t()`) — base64-encoded salt.
  - `salt_separator` (`String.t()`) — base64-encoded salt separator.
  - `signer_key` (`String.t()`) — base64-encoded signer key.
  """

  @derive Jason.Encoder

  @type t :: %__MODULE__{
          type: String.t(),
          salt: String.t(),
          salt_separator: String.t(),
          signer_key: String.t()
        }

  defstruct [:type, :salt, :salt_separator, :signer_key]
end
