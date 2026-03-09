defmodule Appwrite.Types.MfaFactors do
  @moduledoc """
  Represents the MFA factors available for a user.

  ## Fields

    - `totp` (`boolean()`): Whether TOTP (authenticator app) is available.
    - `phone` (`boolean()`): Whether phone (SMS) is available.
    - `email` (`boolean()`): Whether email OTP is available.
    - `recovery_code` (`boolean()`): Whether recovery codes are available.
  """

  @derive Jason.Encoder

  @type t :: %__MODULE__{
          totp: boolean(),
          phone: boolean(),
          email: boolean(),
          recovery_code: boolean()
        }

  defstruct [:totp, :phone, :email, :recovery_code]
end
