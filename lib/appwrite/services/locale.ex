defmodule Appwrite.Services.Locale do
  @moduledoc """
  The Locale service allows you to customize your app based on your users' location.

  Using this service, you can get your users' location, IP address, list of countries
  and continents names, phone codes, currencies, and more.

  The locale service supports multiple locales, allowing you to fetch country and
  continent information in your app's language.
  """

  use Appwrite.Services.Base

  alias Appwrite.Types.ContinentList
  alias Appwrite.Types.CountryList
  alias Appwrite.Types.CurrencyList
  alias Appwrite.Types.LanguageList
  alias Appwrite.Types.Locale
  alias Appwrite.Types.LocaleCodeList
  alias Appwrite.Types.PhoneList

  @doc "Get the current user's locale based on request IP."
  @spec get() :: {:ok, Locale.t()} | {:error, AppwriteException.t()}
  def get, do: locale_call("/v1/locale")

  @doc "List all locale codes classified by ISO 639-1."
  @spec list_codes() :: {:ok, LocaleCodeList.t()} | {:error, AppwriteException.t()}
  def list_codes, do: locale_call("/v1/locale/codes")

  @doc "List all continents."
  @spec list_continents() :: {:ok, ContinentList.t()} | {:error, AppwriteException.t()}
  def list_continents, do: locale_call("/v1/locale/continents")

  @doc "List all countries."
  @spec list_countries() :: {:ok, CountryList.t()} | {:error, AppwriteException.t()}
  def list_countries, do: locale_call("/v1/locale/countries")

  @doc "List all countries in the European Union."
  @spec list_countries_eu() :: {:ok, CountryList.t()} | {:error, AppwriteException.t()}
  def list_countries_eu, do: locale_call("/v1/locale/countries/eu")

  @doc "List all countries with their phone dial codes."
  @spec list_countries_phones() :: {:ok, PhoneList.t()} | {:error, AppwriteException.t()}
  def list_countries_phones, do: locale_call("/v1/locale/countries/phones")

  @doc "List all currencies."
  @spec list_currencies() :: {:ok, CurrencyList.t()} | {:error, AppwriteException.t()}
  def list_currencies, do: locale_call("/v1/locale/currencies")

  @doc "List all languages classified by ISO 639-1."
  @spec list_languages() :: {:ok, LanguageList.t()} | {:error, AppwriteException.t()}
  def list_languages, do: locale_call("/v1/locale/languages")

  # ---------------------------------------------------------------------------
  # Private helpers
  # ---------------------------------------------------------------------------

  # All locale endpoints are GET with no parameters, so a single private helper
  # eliminates the repetition of headers/payload across all 8 functions.
  @spec locale_call(String.t()) :: {:ok, map()} | {:error, any()}
  defp locale_call(path), do: json_call("get", path, %{})
end
