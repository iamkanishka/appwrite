defmodule Appwrite.Types.MfaType do
  @moduledoc """
  Represents an MFA type with its secret and URI.

  ## Fields

    - `secret` (`String.t`): Secret token used for TOTP factor.
    - `uri` (`String.t`): URI for authenticator apps.
  """

  @type t :: %__MODULE__{
          secret: String.t(),
          uri: String.t()
        }

  defstruct [:secret, :uri]
end
