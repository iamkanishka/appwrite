defmodule Appwrite.Services.Locale do
  @moduledoc """
  The Locale service allows you to customize your app based on your users' location.
  Using this service, you can get your users' location, IP address, list of countries and
  continents names, phone codes, currencies, and more.

  The user service supports multiple locales.
  This feature allows you to fetch countries and continents information in your app language.

  Status: In Testing
  """

  alias Appwrite.Helpers.Client
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

      iex> Appwrite.Locale.get(client)
      {:ok, %Appwrite.Types.Locale{}}

  ## Params
    - `client` (required): The Appwrite client instance.

  ## Returns
    - `{:ok, %Appwrite.Types.Locale{}}` on success.
    - `{:error, %Appwrite.Exceptions.AppwriteException{}}` on failure.
  """
  @spec get(Client.t()) :: {:ok, Locale.t()} | {:error, AppwriteException.t()}
  def get(client) when is_struct(client, Client) do
    with uri <- URI.merge(client.config.endpoint, "/locale"),
         headers <- %{"content-type" => "application/json"} do
      try do
        Client.call(client, :get, uri, headers, %{})
      rescue
        error ->
          {:error, AppwriteException.new(to_string(error))}
      end
    end
  end

  @doc """
  List locale codes.

  Fetches all locale codes classified by ISO 639-1.

  ## Examples

      iex> Appwrite.Locale.list_codes(client)
      {:ok, %Appwrite.Types.LocaleCodeList{}}

  ## Params
    - `client` (required): The Appwrite client instance.

  ## Returns
    - `{:ok, %Appwrite.Types.LocaleCodeList{}}` on success.
    - `{:error, %Appwrite.Exceptions.AppwriteException{}}` on failure.
  """
  @spec list_codes(Client.t()) :: {:ok, LocaleCodeList.t()} | {:error, AppwriteException.t()}
  def list_codes(client) when is_struct(client, Client) do
    with uri <- URI.merge(client.config.endpoint, "/locale/codes"),
         headers <- %{"content-type" => "application/json"} do
      try do
        Client.call(client, :get, uri, headers, %{})
      rescue
        error ->
          {:error, AppwriteException.new(to_string(error))}
      end
    end
  end

  @doc """
  List continents.

  Fetches a list of all continents.

  ## Examples

      iex> Appwrite.Locale.list_continents(client)
      {:ok, %Appwrite.Types.ContinentList{}}

  ## Params
    - `client` (required): The Appwrite client instance.

  ## Returns
    - `{:ok, %Appwrite.Types.ContinentList{}}` on success.
    - `{:error, %Appwrite.Exceptions.AppwriteException{}}` on failure.
  """
  @spec list_continents(Client.t()) :: {:ok, ContinentList.t()} | {:error, AppwriteException.t()}
  def list_continents(client) when is_struct(client, Client) do
    with uri <- URI.merge(client.config.endpoint, "/locale/continents"),
         headers <- %{"content-type" => "application/json"} do
      try do
        Client.call(client, :get, uri, headers, %{})
      rescue
        error ->
          {:error, AppwriteException.new(to_string(error))}
      end
    end
  end

  @doc """
  List countries.

  Fetches a list of all countries.

  ## Examples

      iex> Appwrite.Locale.list_countries(client)
      {:ok, %Appwrite.Types.CountryList{}}

  ## Params
    - `client` (required): The Appwrite client instance.

  ## Returns
    - `{:ok, %Appwrite.Types.CountryList{}}` on success.
    - `{:error, %Appwrite.Exceptions.AppwriteException{}}` on failure.
  """
  @spec list_countries(Client.t()) :: {:ok, CountryList.t()} | {:error, AppwriteException.t()}
  def list_countries(client) when is_struct(client, Client) do
    with uri <- URI.merge(client.config.endpoint, "/locale/countries"),
         headers <- %{"content-type" => "application/json"} do
      try do
        Client.call(client, :get, uri, headers, %{})
      rescue
        error ->
          {:error, AppwriteException.new(to_string(error))}
      end
    end
  end

  @doc """
  List EU countries.

  Fetches a list of all countries in the European Union.

  ## Examples

      iex> Appwrite.Locale.list_countries_eu(client)
      {:ok, %Appwrite.Types.CountryList{}}

  ## Params
    - `client` (required): The Appwrite client instance.

  ## Returns
    - `{:ok, %Appwrite.Types.CountryList{}}` on success.
    - `{:error, %Appwrite.Exceptions.AppwriteException{}}` on failure.
  """
  @spec list_countries_eu(Client.t()) :: {:ok, CountryList.t()} | {:error, AppwriteException.t()}
  def list_countries_eu(client) when is_struct(client, Client) do
    with uri <- URI.merge(client.config.endpoint, "/locale/countries/eu"),
         headers <- %{"content-type" => "application/json"} do
      try do
        Client.call(client, :get, uri, headers, %{})
      rescue
        error ->
          {:error, AppwriteException.new(to_string(error))}
      end
    end
  end

  @doc """
  List phone codes.

  Fetches a list of all countries' phone codes.

  ## Examples

      iex> Appwrite.Locale.list_countries_phones(client)
      {:ok, %Appwrite.Types.PhoneList{}}

  ## Params
    - `client` (required): The Appwrite client instance.

  ## Returns
    - `{:ok, %Appwrite.Types.PhoneList{}}` on success.
    - `{:error, %Appwrite.Exceptions.AppwriteException{}}` on failure.
  """
  @spec list_countries_phones(Client.t()) :: {:ok, PhoneList.t()} | {:error, AppwriteException.t()}
  def list_countries_phones(client) when is_struct(client, Client) do
    with uri <- URI.merge(client.config.endpoint, "/locale/countries/phones"),
         headers <- %{"content-type" => "application/json"} do
      try do
        Client.call(client, :get, uri, headers, %{})
      rescue
        error ->
          {:error, AppwriteException.new(to_string(error))}
      end
    end
  end

  @doc """
  List currencies.

  Fetches a list of all currencies.

  ## Examples

      iex> Appwrite.Locale.list_currencies(client)
      {:ok, %Appwrite.Types.CurrencyList{}}

  ## Params
    - `client` (required): The Appwrite client instance.

  ## Returns
    - `{:ok, %Appwrite.Types.CurrencyList{}}` on success.
    - `{:error, %Appwrite.Exceptions.AppwriteException{}}` on failure.
  """
  @spec list_currencies(Client.t()) :: {:ok, CurrencyList.t()} | {:error, AppwriteException.t()}
  def list_currencies(client) when is_struct(client, Client) do
    with uri <- URI.merge(client.config.endpoint, "/locale/currencies"),
         headers <- %{"content-type" => "application/json"} do
      try do
        Client.call(client, :get, uri, headers, %{})
      rescue
        error ->
          {:error, AppwriteException.new(to_string(error))}
      end
    end
  end

  @doc """
  List languages.

  Fetches a list of all languages classified by ISO 639-1.

  ## Examples

      iex> Appwrite.Locale.list_languages(client)
      {:ok, %Appwrite.Types.LanguageList{}}

  ## Params
    - `client` (required): The Appwrite client instance.

  ## Returns
    - `{:ok, %Appwrite.Types.LanguageList{}}` on success.
    - `{:error, %Appwrite.Exceptions.AppwriteException{}}` on failure.
  """
  @spec list_languages(Client.t()) :: {:ok, LanguageList.t()} | {:error, AppwriteException.t()}
  def list_languages(client) when is_struct(client, Client) do
    with uri <- URI.merge(client.config.endpoint, "/locale/languages"),
         headers <- %{"content-type" => "application/json"} do
      try do
        Client.call(client, :get, uri, headers, %{})
      rescue
        error ->
          {:error, AppwriteException.new(to_string(error))}
      end
    end
  end


end
