defmodule Appwrite.Types.MfaFactors do
  @moduledoc """
  Represents MFA factors available for a user.

  ## Fields

    - `totp` (`boolean`): Indicates if TOTP is available.
    - `phone` (`boolean`): Indicates if phone (SMS) is available.
    - `email` (`boolean`): Indicates if email is available.
    - `recovery_code` (`boolean`): Indicates if recovery code is available.
  """

  @type t :: %__MODULE__{
          totp: boolean(),
          phone: boolean(),
          email: boolean(),
          recovery_code: boolean()
        }

  defstruct [:totp, :phone, :email, :recovery_code]
end
