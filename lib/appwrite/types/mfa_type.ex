defmodule Appwrite.Types.MfaType do
  @moduledoc """
  Represents an MFA type with its TOTP secret and provisioning URI.

  ## Fields

    - `secret` (`String.t()`): Secret token used to configure the TOTP factor.
    - `uri` (`String.t()`): `otpauth://` URI for importing into authenticator apps.
  """

  @derive Jason.Encoder

  @type t :: %__MODULE__{
          secret: String.t(),
          uri: String.t()
        }

  defstruct [:secret, :uri]
end
