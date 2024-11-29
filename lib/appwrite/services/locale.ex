defmodule Appwrite.Services.Locale do
  @moduledoc """
  The Locale service allows you to customize your app based on your users' location.
  Using this service, you can get your users' location, IP address, list of countries and
  continents names, phone codes, currencies, and more.

  The user service supports multiple locales.
  This feature allows you to fetch countries and continents information in your app language.
  """

  alias Appwrite.Utils.Client
  alias Appwrite.Exceptions.AppwriteException

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
  Get user locale.

  Retrieves the current user's location based on their IP. Returns an object containing
  country code, country name, continent name, continent code, IP address, and suggested currency.

  ## Examples

      iex> Appwrite.Locale.get()
      {:ok, %Appwrite.Types.Locale{}}

  ## Params
    - `client` (required): The Appwrite client instance.

  ## Returns
    - `{:ok, %Appwrite.Types.Locale{}}` on success.
    - `{:error, %Appwrite.Exceptions.AppwriteException{}}` on failure.
  """
  @spec get() :: {:ok, Locale.t()} | {:error, AppwriteException.t()}
  def get() do
    api_path = "/v1/locale"
    payload = %{}
    api_header = %{"content-type" => "application/json"}

    Task.async(fn ->
      try do
        locale = Client.call("get", api_path, api_header, payload)
        {:ok, locale}
      rescue
        error -> {:error, error}
      end
    end)
    |> Task.await()
  end

  @doc """
  List locale codes.

  Fetches all locale codes classified by ISO 639-1.

  ## Examples

      iex> Appwrite.Locale.list_codes()
      {:ok, %Appwrite.Types.LocaleCodeList{}}

  ## Params

  ## Returns
    - `{:ok, %Appwrite.Types.LocaleCodeList{}}` on success.
    - `{:error, %Appwrite.Exceptions.AppwriteException{}}` on failure.
  """
  @spec list_codes() :: {:ok, LocaleCodeList.t()} | {:error, AppwriteException.t()}
  def list_codes() do
    api_path = "/v1/locale/codes"
    payload = %{}
    api_header = %{"content-type" => "application/json"}

    Task.async(fn ->
      try do
        locale_codes = Client.call("get", api_path, api_header, payload)
        {:ok, locale_codes}
      rescue
        error -> {:error, error}
      end
    end)
    |> Task.await()
  end

  @doc """
  List continents.

  Fetches a list of all continents.

  ## Examples

      iex> Appwrite.Locale.list_continents()
      {:ok, %Appwrite.Types.ContinentList{}}

  ## Params

  ## Returns
    - `{:ok, %Appwrite.Types.ContinentList{}}` on success.
    - `{:error, %Appwrite.Exceptions.AppwriteException{}}` on failure.
  """
  @spec list_continents() :: {:ok, ContinentList.t()} | {:error, AppwriteException.t()}
  def list_continents() do
    api_path = "/v1/locale/continents"
    payload = %{}
    api_header = %{"content-type" => "application/json"}

    Task.async(fn ->
      try do
        continent_list = Client.call("get", api_path, api_header, payload)
        {:ok, continent_list}
      rescue
        error -> {:error, error}
      end
    end)
    |> Task.await()
  end

  @doc """
  List countries.

  Fetches a list of all countries.

  ## Examples

      iex> Appwrite.Locale.list_countries()
      {:ok, %Appwrite.Types.CountryList{}}

  ## Params
    - `client` (required): The Appwrite client instance.

  ## Returns
    - `{:ok, %Appwrite.Types.CountryList{}}` on success.
    - `{:error, %Appwrite.Exceptions.AppwriteException{}}` on failure.
  """
  @spec list_countries() :: {:ok, CountryList.t()} | {:error, AppwriteException.t()}
  def list_countries() do
    api_path = "/v1/locale/countries"
    payload = %{}
    api_header = %{"content-type" => "application/json"}

    Task.async(fn ->
      try do
        country_list = Client.call("get", api_path, api_header, payload)
        {:ok, country_list}
      rescue
        error -> {:error, error}
      end
    end)
    |> Task.await()
  end

  @doc """
  List EU countries.

  Fetches a list of all countries in the European Union.

  ## Examples

      iex> Appwrite.Locale.list_countries_eu()
      {:ok, %Appwrite.Types.CountryList{}}

  ## Params

  ## Returns
    - `{:ok, %Appwrite.Types.CountryList{}}` on success.
    - `{:error, %Appwrite.Exceptions.AppwriteException{}}` on failure.
  """
  @spec list_countries_eu() :: {:ok, CountryList.t()} | {:error, AppwriteException.t()}
  def list_countries_eu() do
    api_path = "/v1/locale/countries/eu"
    payload = %{}
    api_header = %{"content-type" => "application/json"}

    Task.async(fn ->
      try do
        country_list = Client.call("get", api_path, api_header, payload)
        {:ok, country_list}
      rescue
        error -> {:error, error}
      end
    end)
    |> Task.await()
  end

  @doc """
  List phone codes.

  Fetches a list of all countries' phone codes.

  ## Examples

      iex> Appwrite.Locale.list_countries_phones()
      {:ok, %Appwrite.Types.PhoneList{}}

  ## Params

  ## Returns
    - `{:ok, %Appwrite.Types.PhoneList{}}` on success.
    - `{:error, %Appwrite.Exceptions.AppwriteException{}}` on failure.
  """
  @spec list_countries_phones() ::
          {:ok, PhoneList.t()} | {:error, AppwriteException.t()}
  def list_countries_phones() do
    api_path = "/v1/locale/countries/phones"
    payload = %{}
    api_header = %{"content-type" => "application/json"}

    Task.async(fn ->
      try do
        country_list = Client.call("get", api_path, api_header, payload)
        {:ok, country_list}
      rescue
        error -> {:error, error}
      end
    end)
    |> Task.await()
  end

  @doc """
  List currencies.

  Fetches a list of all currencies.

  ## Examples

      iex> Appwrite.Locale.list_currencies()
      {:ok, %Appwrite.Types.CurrencyList{}}

  ## Params

  ## Returns
    - `{:ok, %Appwrite.Types.CurrencyList{}}` on success.
    - `{:error, %Appwrite.Exceptions.AppwriteException{}}` on failure.
  """
  @spec list_currencies() :: {:ok, CurrencyList.t()} | {:error, AppwriteException.t()}
  def list_currencies() do
    api_path = "/v1/locale/currencies"
    payload = %{}
    api_header = %{"content-type" => "application/json"}

    Task.async(fn ->
      try do
        country_list = Client.call("get", api_path, api_header, payload)
        {:ok, country_list}
      rescue
        error -> {:error, error}
      end
    end)
    |> Task.await()
  end

  @doc """
  List languages.

  Fetches a list of all languages classified by ISO 639-1.

  ## Examples

      iex> Appwrite.Locale.list_languages()
      {:ok, %Appwrite.Types.LanguageList{}}

  ## Params

  ## Returns
    - `{:ok, %Appwrite.Types.LanguageList{}}` on success.
    - `{:error, %Appwrite.Exceptions.AppwriteException{}}` on failure.
  """
  @spec list_languages() :: {:ok, LanguageList.t()} | {:error, AppwriteException.t()}
  def list_languages() do

    api_path = "/v1/locale/languages"
    payload = %{}
    api_header = %{"content-type" => "application/json"}

    Task.async(fn ->
      try do
        country_list = Client.call("get", api_path, api_header, payload)
        {:ok, country_list}
      rescue
        error -> {:error, error}
      end
    end)
    |> Task.await()

  end
end
