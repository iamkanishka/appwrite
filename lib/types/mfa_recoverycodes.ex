defmodule Appwrite.Types.MfaRecoveryCodes do
  @moduledoc """
  Represents MFA recovery codes.

  ## Fields

    - `recovery_codes` (`[String.t()]`): List of recovery codes.
  """

  @type t :: %__MODULE__{
          recovery_codes: [String.t()]
        }

  defstruct [:recovery_codes]
end
