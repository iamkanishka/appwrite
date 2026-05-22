defmodule Appwrite.Types.Log do
  @moduledoc """
  Represents a user activity log entry in the Appwrite system.

  ## Fields

    - `event` (`String.t()`): Event name.
    - `user_id` (`String.t()`): User ID.
    - `user_email` (`String.t()`): User email address.
    - `user_name` (`String.t()`): User name.
    - `mode` (`String.t()`): API mode when the event was triggered.
    - `ip` (`String.t()`): IP address in use when the event was triggered.
    - `time` (`String.t()`): Log creation date in ISO 8601 format.
    - `os_code` (`String.t()`): Operating system code name (e.g. `"windows"`, `"mac"`).
    - `os_name` (`String.t()`): Operating system name.
    - `os_version` (`String.t()`): Operating system version.
    - `client_type` (`String.t()`): Client type.
    - `client_code` (`String.t()`): Client code name (e.g. `"chrome"`, `"firefox"`).
    - `client_name` (`String.t()`): Client name.
    - `client_version` (`String.t()`): Client version.
    - `client_engine` (`String.t()`): Client engine name.
    - `client_engine_version` (`String.t()`): Client engine version.
    - `device_name` (`String.t()`): Device name.
    - `device_brand` (`String.t()`): Device brand name.
    - `device_model` (`String.t()`): Device model name.
    - `country_code` (`String.t()`): Two-character ISO 3166-1 alpha country code.
    - `country_name` (`String.t()`): Country name.
  """

  @derive Jason.Encoder

  @type t :: %__MODULE__{
          event: String.t(),
          user_id: String.t(),
          user_email: String.t(),
          user_name: String.t(),
          mode: String.t(),
          ip: String.t(),
          time: String.t(),
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
          country_name: String.t()
        }

  defstruct event: nil,
            user_id: nil,
            user_email: nil,
            user_name: nil,
            mode: nil,
            ip: nil,
            time: nil,
            os_code: nil,
            os_name: nil,
            os_version: nil,
            client_type: nil,
            client_code: nil,
            client_name: nil,
            client_version: nil,
            client_engine: nil,
            client_engine_version: nil,
            device_name: nil,
            device_brand: nil,
            device_model: nil,
            country_code: nil,
            country_name: nil
end
