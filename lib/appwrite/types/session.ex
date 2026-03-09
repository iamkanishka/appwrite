defmodule Appwrite.Types.Session do
  @moduledoc """
  Represents an authenticated user session in Appwrite.

  ## Fields

    - `id` (`String.t()`): Session ID.
    - `created_at` (`String.t()`): Session creation date in ISO 8601 format.
    - `updated_at` (`String.t()`): Session update date in ISO 8601 format.
    - `user_id` (`String.t()`): ID of the user this session belongs to.
    - `expire` (`String.t()`): Session expiration date in ISO 8601 format.
    - `provider` (`String.t()`): Authentication provider name (e.g. `"email"`, `"google"`, `"anonymous"`).
    - `provider_uid` (`String.t()`): User ID returned by the OAuth2 provider.
    - `provider_access_token` (`String.t()`): OAuth2 provider access token.
    - `provider_access_token_expiry` (`String.t()`): OAuth2 access token expiry date in ISO 8601 format.
    - `provider_refresh_token` (`String.t()`): OAuth2 provider refresh token.
    - `ip` (`String.t()`): IP address from which the session was created.
    - `os_code` (`String.t()`): Operating system code name. See [os.json](https://github.com/appwrite/appwrite/blob/master/docs/lists/os.json).
    - `os_name` (`String.t()`): Operating system name.
    - `os_version` (`String.t()`): Operating system version.
    - `client_type` (`String.t()`): Client type (e.g. `"browser"`, `"mobile"`).
    - `client_code` (`String.t()`): Client code name. See [clients.json](https://github.com/appwrite/appwrite/blob/master/docs/lists/clients.json).
    - `client_name` (`String.t()`): Client name (e.g. `"Chrome"`, `"Firefox"`).
    - `client_version` (`String.t()`): Client version string.
    - `client_engine` (`String.t()`): Rendering engine name.
    - `client_engine_version` (`String.t()`): Rendering engine version.
    - `device_name` (`String.t()`): Device name.
    - `device_brand` (`String.t()`): Device brand name.
    - `device_model` (`String.t()`): Device model name.
    - `country_code` (`String.t()`): Two-character ISO 3166-1 alpha country code.
    - `country_name` (`String.t()`): Country name.
    - `current` (`boolean()`): Whether this is the session used to make the current request.
    - `factors` (`[String.t()]`): List of active MFA factor types for this session.
    - `secret` (`String.t()`): Session secret (populated only at session creation time).
    - `mfa_updated_at` (`String.t()`): Date MFA was last updated for this session in ISO 8601 format.
  """

  @derive Jason.Encoder

  @type t :: %__MODULE__{
          id: String.t(),
          created_at: String.t(),
          updated_at: String.t(),
          user_id: String.t(),
          expire: String.t(),
          provider: String.t(),
          provider_uid: String.t(),
          provider_access_token: String.t(),
          provider_access_token_expiry: String.t(),
          provider_refresh_token: String.t(),
          ip: String.t(),
          os_code: String.t(),
          os_name: String.t(),
          os_version: String.t(),
          client_type: String.t(),
          client_code: String.t(),
          client_name: String.t(),
          client_version: String.t(),
          client_engine: String.t(),
          client_engine_version: String.t(),
          device_name: String.t(),
          device_brand: String.t(),
          device_model: String.t(),
          country_code: String.t(),
          country_name: String.t(),
          current: boolean(),
          factors: [String.t()],
          secret: String.t(),
          mfa_updated_at: String.t()
        }

  defstruct [
    :id,
    :created_at,
    :updated_at,
    :user_id,
    :expire,
    :provider,
    :provider_uid,
    :provider_access_token,
    :provider_access_token_expiry,
    :provider_refresh_token,
    :ip,
    :os_code,
    :os_name,
    :os_version,
    :client_type,
    :client_code,
    :client_name,
    :client_version,
    :client_engine,
    :client_engine_version,
    :device_name,
    :device_brand,
    :device_model,
    :country_code,
    :country_name,
    :current,
    :factors,
    :secret,
    :mfa_updated_at
  ]
end
