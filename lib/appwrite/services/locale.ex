defmodule Appwrite.Services.Locale do
  @moduledoc """
  The Locale service allows you to customize your app based on your users' location.

  Using this service, you can get your users' location, IP address, list of countries and
  continents names, phone codes, currencies, and more.

  The locale service supports multiple locales. This feature allows you to fetch countries
  and continents information in your app's language.
  """

  alias Appwrite.Exceptions.AppwriteException
  alias Appwrite.Utils.Client

  alias Appwrite.Types.{
    Locale,
    LocaleCodeList,
    ContinentList,
    CountryList,
    PhoneList,
    CurrencyList,
    LanguageList
  }

  @doc """
  Get the current user's locale.

  Retrieves the location based on the request IP. Returns country code, country name,
  continent name, continent code, IP address, and suggested currency.

  ## Returns
  - `{:ok, Locale.t()}` on success.
  - `{:error, AppwriteException.t()}` on failure.
  """
  @spec get() :: {:ok, Locale.t()} | {:error, AppwriteException.t()}
  def get do
    api_path = "/v1/locale"
    payload = %{}
    api_header = %{"content-type" => "application/json"}

    try do
      locale = Client.call("get", api_path, api_header, payload)
      {:ok, locale}
    rescue
      error -> {:error, error}
    end
  end

  @doc """
  List all locale codes classified by ISO 639-1.

  ## Returns
  - `{:ok, LocaleCodeList.t()}` on success.
  - `{:error, AppwriteException.t()}` on failure.
  """
  @spec list_codes() :: {:ok, LocaleCodeList.t()} | {:error, AppwriteException.t()}
  def list_codes do
    api_path = "/v1/locale/codes"
    payload = %{}
    api_header = %{"content-type" => "application/json"}

    try do
      locale_codes = Client.call("get", api_path, api_header, payload)
      {:ok, locale_codes}
    rescue
      error -> {:error, error}
    end
  end

  @doc """
  List all continents.

  ## Returns
  - `{:ok, ContinentList.t()}` on success.
  - `{:error, AppwriteException.t()}` on failure.
  """
  @spec list_continents() :: {:ok, ContinentList.t()} | {:error, AppwriteException.t()}
  def list_continents do
    api_path = "/v1/locale/continents"
    payload = %{}
    api_header = %{"content-type" => "application/json"}

    try do
      continent_list = Client.call("get", api_path, api_header, payload)
      {:ok, continent_list}
    rescue
      error -> {:error, error}
    end
  end

  @doc """
  List all countries.

  ## Returns
  - `{:ok, CountryList.t()}` on success.
  - `{:error, AppwriteException.t()}` on failure.
  """
  @spec list_countries() :: {:ok, CountryList.t()} | {:error, AppwriteException.t()}
  def list_countries do
    api_path = "/v1/locale/countries"
    payload = %{}
    api_header = %{"content-type" => "application/json"}

    try do
      country_list = Client.call("get", api_path, api_header, payload)
      {:ok, country_list}
    rescue
      error -> {:error, error}
    end
  end

  @doc """
  List all countries in the European Union.

  ## Returns
  - `{:ok, CountryList.t()}` on success.
  - `{:error, AppwriteException.t()}` on failure.
  """
  @spec list_countries_eu() :: {:ok, CountryList.t()} | {:error, AppwriteException.t()}
  def list_countries_eu do
    api_path = "/v1/locale/countries/eu"
    payload = %{}
    api_header = %{"content-type" => "application/json"}

    try do
      country_list = Client.call("get", api_path, api_header, payload)
      {:ok, country_list}
    rescue
      error -> {:error, error}
    end
  end

  @doc """
  List all countries' phone dial codes.

  ## Returns
  - `{:ok, PhoneList.t()}` on success.
  - `{:error, AppwriteException.t()}` on failure.
  """
  @spec list_countries_phones() :: {:ok, PhoneList.t()} | {:error, AppwriteException.t()}
  def list_countries_phones do
    api_path = "/v1/locale/countries/phones"
    payload = %{}
    api_header = %{"content-type" => "application/json"}

    try do
      phone_list = Client.call("get", api_path, api_header, payload)
      {:ok, phone_list}
    rescue
      error -> {:error, error}
    end
  end

  @doc """
  List all currencies.

  ## Returns
  - `{:ok, CurrencyList.t()}` on success.
  - `{:error, AppwriteException.t()}` on failure.
  """
  @spec list_currencies() :: {:ok, CurrencyList.t()} | {:error, AppwriteException.t()}
  def list_currencies do
    api_path = "/v1/locale/currencies"
    payload = %{}
    api_header = %{"content-type" => "application/json"}

    try do
      currency_list = Client.call("get", api_path, api_header, payload)
      {:ok, currency_list}
    rescue
      error -> {:error, error}
    end
  end

  @doc """
  List all languages classified by ISO 639-1.

  ## Returns
  - `{:ok, LanguageList.t()}` on success.
  - `{:error, AppwriteException.t()}` on failure.
  """
  @spec list_languages() :: {:ok, LanguageList.t()} | {:error, AppwriteException.t()}
  def list_languages do
    api_path = "/v1/locale/languages"
    payload = %{}
    api_header = %{"content-type" => "application/json"}

    try do
      language_list = Client.call("get", api_path, api_header, payload)
      {:ok, language_list}
    rescue
      error -> {:error, error}
    end
  end
end
