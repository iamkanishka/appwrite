defmodule Appwrite.Types.MfaRecoveryCodes do
  @moduledoc """
  Represents a set of MFA recovery codes.

  ## Fields

    - `recovery_codes` (`[String.t()]`): List of one-time recovery codes.
  """

  @derive Jason.Encoder

  @type t :: %__MODULE__{
          recovery_codes: [String.t()]
        }

  defstruct [:recovery_codes]
end
