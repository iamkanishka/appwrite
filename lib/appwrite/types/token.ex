defmodule Appwrite.Types.Token do
  @moduledoc """
  Represents a verification or magic-link token in Appwrite.

  Tokens are short-lived, single-use values generated during email
  verification, phone verification, and passwordless (magic URL / OTP)
  authentication flows.

  ## Fields

    - `id` (`String.t()`): Token ID.
    - `created_at` (`String.t()`): Token creation date in ISO 8601 format.
    - `user_id` (`String.t()`): ID of the user this token belongs to.
    - `secret` (`String.t()`): Token secret value used to complete the verification or sign-in flow.
    - `expire` (`String.t()`): Token expiration date in ISO 8601 format.
    - `phrase` (`String.t()`): Security phrase shown to the user to confirm they initiated the request.
  """

  @derive Jason.Encoder

  @type t :: %__MODULE__{
          id: String.t(),
          created_at: String.t(),
          user_id: String.t(),
          secret: String.t(),
          expire: String.t(),
          phrase: String.t()
        }

  defstruct [
    :id,
    :created_at,
    :user_id,
    :secret,
    :expire,
    :phrase
  ]
end
