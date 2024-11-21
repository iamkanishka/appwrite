defmodule Appwrite.Services.Avatars do
  @moduledoc """
  The Avatars service aims to help you complete everyday tasks related to your app image, icons, and avatars.

  The Avatars service allows you to fetch country flags, browser icons, payment methods logos,
  remote websites favicons, generate QR codes, and manipulate remote images URLs.

  All endpoints in this service allow you to resize, crop, and
  change the output image quality for maximum performance and visibility in your app.

  Coming Soon
  """

  alias Appwrite.Types.Client
  alias Appwrite.Exceptions.AppwriteException
  alias Appwrite.Helpers.Service

  @doc """
  Get browser icon.

  Fetches the browser icon using the provided code and optional size and quality parameters.

  ## Parameters

    - `client` (`Client.t`): The Appwrite client instance.
    - `code` (`String.t`): The browser code.
    - `width` (`integer`): The width of the icon.
    - `height` (`integer`): The height of the icon.
    - `quality` (`integer`): The quality of the icon.

  ## Returns

    - The browser icon URL as a string.

  ## Raises

    - `AppwriteException` if any required parameter is missing.

  """
  @spec get_browser(Client.t(), String.t(), integer() | nil, integer() | nil, integer() | nil) :: String.t()
  def get_browser(client, code, width \\ nil, height \\ nil, quality \\ nil) do
    validate_params(%{client: client, code: code})

    api_path = "/avatars/browsers/#{code}"
    uri = URI.merge(client.config.endpoint, api_path)

    payload =
      %{}
      |> maybe_put("width", width)
      |> maybe_put("height", height)
      |> maybe_put("quality", quality)
      |> Map.put("project", client.config.project)
      |> Service.flatten()

    uri = build_query_params(uri, payload)
    Client.call(client, :get, uri)
  end

  @doc """
  Get credit card icon.

  Fetches the credit card provider's icon using the provided code and optional size and quality parameters.

  ## Parameters

    - `client` (`Client.t`): The Appwrite client instance.
    - `code` (`String.t`): The credit card code.
    - `width` (`integer`): The width of the icon.
    - `height` (`integer`): The height of the icon.
    - `quality` (`integer`): The quality of the icon.

  ## Returns

    - The credit card icon URL as a string.

  ## Raises

    - `AppwriteException` if any required parameter is missing.

  """
  @spec get_credit_card(Client.t(), String.t(), integer() | nil, integer() | nil, integer() | nil) :: String.t()
  def get_credit_card(client, code, width \\ nil, height \\ nil, quality \\ nil) do
    validate_params(%{client: client, code: code})

    api_path = "/avatars/credit-cards/#{code}"
    uri = URI.merge(client.config.endpoint, api_path)

    payload =
      %{}
      |> maybe_put("width", width)
      |> maybe_put("height", height)
      |> maybe_put("quality", quality)
      |> Map.put("project", client.config.project)
      |> Service.flatten()

    uri = build_query_params(uri, payload)
    Client.call(client, :get, uri)
  end

  # Helper function to validate parameters
  @spec validate_params(map()) :: :ok | no_return()
  defp validate_params(params) do
    Enum.each(params, fn {key, value} ->
      if is_nil(value) do
        raise AppwriteException, "Missing required parameter: #{inspect(key)}"
      end
    end)
  end

  # Helper function to build query params
  @spec build_query_params(URI.t(), map()) :: URI.t()
  defp build_query_params(uri, payload) do
    Enum.reduce(payload, uri, fn {key, value}, acc ->
      query = URI.decode_query(acc.query || "") |> Map.put(key, to_string(value))
      %{acc | query: URI.encode_query(query)}
    end)
  end




  @doc """
  Fetches the favicon of a given URL.

  ## Parameters
    - `url` (string): The URL of the remote website.

  ## Returns
    - `String.t`: The URI for fetching the favicon.

  ## Raises
    - `AppwriteException` if the `url` is nil.
  """
  @spec get_favicon(Client.t(), String.t()) :: String.t()
  def get_favicon(client, url) when is_binary(url) do
    api_path = "/avatars/favicon"
    payload = %{"url" => url, "project" => client.config.project}

    with {:ok, uri} <- prepare_uri(client.config.endpoint, api_path, payload) do
      Client.call(client, uri)
    else
      {:error, reason} -> raise AppwriteException, message: reason
    end
  end

  def get_favicon(_client, nil), do: raise AppwriteException, message: "Missing required parameter: 'url'"

  @doc """
  Fetches a country flag icon by its ISO 3166-1 code.

  ## Parameters
    - `client` (Client.t): The client instance.
    - `code` (string): ISO 3166-1 2-letter country code.
    - `width` (optional, integer): The width of the flag icon.
    - `height` (optional, integer): The height of the flag icon.
    - `quality` (optional, integer): The image quality percentage.

  ## Returns
    - `String.t`: The URI for fetching the country flag.

  ## Raises
    - `AppwriteException` if the `code` is nil.
  """
  @spec get_flag(Client.t(), String.t(), integer(), integer(), integer()) :: String.t()
  def get_flag(client, code, width \\ nil, height \\ nil, quality \\ nil) when is_binary(code) do
    api_path = "/avatars/flags/#{code}"
    payload =
      %{
        "width" => width,
        "height" => height,
        "quality" => quality,
        "project" => client.config.project
      }
      |> Enum.reject(fn {_, v} -> v == nil end)

    with {:ok, uri} <- prepare_uri(client.config.endpoint, api_path, payload) do
      Client.call(client, uri)
    else
      {:error, reason} -> raise AppwriteException, message: reason
    end
  end

  def get_flag(_client, nil, _width, _height, _quality),
    do: raise AppwriteException, message: "Missing required parameter: 'code'"

  @doc """
  Fetches and optionally crops a remote image by URL.

  ## Parameters
    - `client` (Client.t): The client instance.
    - `url` (string): The URL of the remote image.
    - `width` (optional, integer): The width to crop the image.
    - `height` (optional, integer): The height to crop the image.

  ## Returns
    - `String.t`: The URI for fetching the cropped image.

  ## Raises
    - `AppwriteException` if the `url` is nil.
  """
  @spec get_image(Client.t(), String.t(), integer(), integer()) :: String.t()
  def get_image(client, url, width \\ nil, height \\ nil) when is_binary(url) do
    api_path = "/avatars/image"
    payload =
      %{
        "url" => url,
        "width" => width,
        "height" => height,
        "project" => client.config.project
      }
      |> Enum.reject(fn {_, v} -> v == nil end)

    with {:ok, uri} <- prepare_uri(client.config.endpoint, api_path, payload) do
      Client.call(client, uri)
    else
      {:error, reason} -> raise AppwriteException, message: reason
    end
  end

  def get_image(_client, nil, _width, _height),
    do: raise AppwriteException, message: "Missing required parameter: 'url'"

  @doc """
  Generates a user initials avatar.

  ## Parameters
    - `client` (Client.t): The client instance.
    - `name` (optional, string): The name or initials of the user.
    - `width` (optional, integer): The width of the avatar.
    - `height` (optional, integer): The height of the avatar.
    - `background` (optional, string): The background color for the avatar.

  ## Returns
    - `String.t`: The URI for fetching the initials avatar.
  """
  @spec get_initials(Client.t(), String.t(), integer(), integer(), String.t()) :: String.t()
  def get_initials(client, name \\ nil, width \\ nil, height \\ nil, background \\ nil) do
    api_path = "/avatars/initials"
    payload =
      %{
        "name" => name,
        "width" => width,
        "height" => height,
        "background" => background,
        "project" => client.config.project
      }
      |> Enum.reject(fn {_, v} -> v == nil end)

    with {:ok, uri} <- prepare_uri(client.config.endpoint, api_path, payload) do
      Client.call(client, uri)
    else
      {:error, reason} -> raise AppwriteException, message: reason
    end
  end

  @doc """
  Generates a QR code from the given text.

  ## Parameters
    - `client` (Client.t): The client instance.
    - `text` (string): The text to encode in the QR code.
    - `size` (optional, integer): The size of the QR code.
    - `margin` (optional, integer): The margin around the QR code.
    - `download` (optional, boolean): Whether to download the QR code as an image.

  ## Returns
    - `String.t`: The URI for fetching the QR code.

  ## Raises
    - `AppwriteException` if the `text` is nil.
  """
  @spec get_qr(Client.t(), String.t(), integer(), integer(), boolean()) :: String.t()
  def get_qr(client, text, size \\ nil, margin \\ nil, download \\ nil) when is_binary(text) do
    api_path = "/avatars/qr"
    payload =
      %{
        "text" => text,
        "size" => size,
        "margin" => margin,
        "download" => download,
        "project" => client.config.project
      }
      |> Enum.reject(fn {_, v} -> v == nil end)

    with {:ok, uri} <- prepare_uri(client.config.endpoint, api_path, payload) do
      Client.call(client, uri)
    else
      {:error, reason} -> raise AppwriteException, message: reason
    end
  end

  def get_qr(_client, nil, _size, _margin, _download),
    do: raise AppwriteException, message: "Missing required parameter: 'text'"

  defp prepare_uri(endpoint, api_path, payload) do
    uri = URI.merge(endpoint, api_path)
    params = Service.flatten(payload)
    {:ok, URI.append_query(uri, URI.encode_query(params))}
  rescue
    e -> {:error, Exception.message(e)}
  end



  # Helper function to optionally add a key to a map
  @spec maybe_put(map(), String.t(), any()) :: map()
  defp maybe_put(map, key, value) when is_nil(value), do: map
  defp maybe_put(map, key, value), do: Map.put(map, key, value)



end
