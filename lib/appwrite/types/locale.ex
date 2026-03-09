defmodule Appwrite.Types.Locale do
  @moduledoc """
  Represents locale information for a user based on their IP address.

  ## Fields

    - `ip` (`String.t()`): User IP address.
    - `country_code` (`String.t()`): Two-character ISO 3166-1 alpha country code.
    - `country` (`String.t()`): Country name.
    - `continent_code` (`String.t()`): Two-character continent code.
    - `continent` (`String.t()`): Continent name.
    - `eu` (`boolean()`): Whether the country is part of the European Union.
    - `currency` (`String.t()`): ISO 4217 currency code for the country.
  """

  @derive Jason.Encoder

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
