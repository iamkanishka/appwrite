defmodule Appwrite.Types.Locale do
  @moduledoc """
  Represents locale information for a user.

  ## Fields

    - `ip` (`String.t`): User IP address.
    - Other fields describe geographic and currency details.
  """

  @type t :: %__MODULE__{
          ip: String.t(),
          country_code: String.t(),
          country: String.t(),
          continent_code: String.t(),
          continent: String.t(),
          eu: boolean(),
          currency: String.t()
        }

  defstruct [
    :ip,
    :country_code,
    :country,
    :continent_code,
    :continent,
    :eu,
    :currency
  ]
end
