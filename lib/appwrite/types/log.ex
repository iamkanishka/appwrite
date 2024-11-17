defmodule Appwrite.Types.Log do
  @moduledoc """
  Represents a log entry in the Appwrite system.

  ## Fields

    - `event` (`String.t`): Event name.
    - `user_id` (`String.t`): User ID.
    - `user_email` (`String.t`): User Email.
    - `user_name` (`String.t`): User Name.
    - `mode` (`String.t`): API mode when event triggered.
    - `ip` (`String.t`): IP session in use when the session was created.
    - `time` (`String.t`): Log creation date in ISO 8601 format.
    - `os_code` (`String.t`): Operating system code name. View [available options](https://github.com/appwrite/appwrite/blob/master/docs/lists/os.json).
    - `os_name` (`String.t`): Operating system name.
    - `os_version` (`String.t`): Operating system version.
    - `client_type` (`String.t`): Client type.
    - `client_code` (`String.t`): Client code name. View [available options](https://github.com/appwrite/appwrite/blob/master/docs/lists/clients.json).
    - `client_name` (`String.t`): Client name.
    - `client_version` (`String.t`): Client version.
    - `client_engine` (`String.t`): Client engine name.
    - `client_engine_version` (`String.t`): Client engine version.
    - `device_name` (`String.t`): Device name.
    - `device_brand` (`String.t`): Device brand name.
    - `device_model` (`String.t`): Device model name.
    - `country_code` (`String.t`): Country two-character ISO 3166-1 alpha code.
    - `country_name` (`String.t`): Country name.
  """

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

  defstruct [
    :event,
    :user_id,
    :user_email,
    :user_name,
    :mode,
    :ip,
    :time,
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
    :country_name
  ]
end
