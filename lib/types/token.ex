defmodule Appwrite.Types.Token do
  @moduledoc """
  Represents a token in the Appwrite system.

  ## Fields

    - `id` (`String.t`): Token ID.
    - `created_at` (`String.t`): Creation date in ISO 8601 format.
    - Other fields describe the secret, expiration, and security phrase.
  """

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
