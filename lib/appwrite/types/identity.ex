defmodule Appwrite.Types.Identity do
  @moduledoc """
  Represents an OAuth2 identity linked to an Appwrite user account.

  ## Fields

    - `id` (`String.t()`): Identity ID.
    - `created_at` (`String.t()`): Creation date in ISO 8601 format.
    - `updated_at` (`String.t()`): Update date in ISO 8601 format.
    - `user_id` (`String.t()`): ID of the user this identity belongs to.
    - `provider` (`String.t()`): OAuth2 provider name (e.g. `"google"`, `"github"`).
    - `provider_uid` (`String.t()`): Unique user ID from the OAuth2 provider.
    - `provider_email` (`String.t()`): Email address returned by the OAuth2 provider.
    - `provider_access_token` (`String.t()`): Access token from the OAuth2 provider.
    - `provider_access_token_expiry` (`String.t()`): Access token expiry date in ISO 8601 format.
    - `provider_refresh_token` (`String.t()`): Refresh token from the OAuth2 provider.
  """

  @derive Jason.Encoder

  @type t :: %__MODULE__{
          id: String.t(),
          created_at: String.t(),
          updated_at: String.t(),
          user_id: String.t(),
          provider: String.t(),
          provider_uid: String.t(),
          provider_email: String.t(),
          provider_access_token: String.t(),
          provider_access_token_expiry: String.t(),
          provider_refresh_token: String.t()
        }

  defstruct [
    :id,
    :created_at,
    :updated_at,
    :user_id,
    :provider,
    :provider_uid,
    :provider_email,
    :provider_access_token,
    :provider_access_token_expiry,
    :provider_refresh_token
  ]
end
