defmodule Appwrite.Types.Session do
  @moduledoc """
  Represents a user session in the Appwrite system.

  ## Fields

    - `id` (`String.t`): Session ID.
    - `created_at` (`String.t`): Session creation date in ISO 8601 format.
    - `updated_at` (`String.t`): Session update date in ISO 8601 format.
    - `user_id` (`String.t`): User ID.
    - `expire` (`String.t`): Session expiration date in ISO 8601 format.
    - `provider` (`String.t`): Session provider.
    - `provider_uid` (`String.t`): Session provider user ID.
    - `provider_access_token` (`String.t`): Provider access token.
    - `provider_access_token_expiry` (`String.t`): Access token expiry date.
    - `provider_refresh_token` (`String.t`): Refresh token.
    - `ip` (`String.t`): IP address of session creation.
    - Additional fields describe the operating system, client, device, and geographic location details.
  """

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
