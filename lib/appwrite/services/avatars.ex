defmodule Appwrite.Services.Avatars do
  @moduledoc """
  The Avatars service aims to help you complete everyday tasks related to your app image, icons, and avatars.

  The Avatars service allows you to fetch country flags, browser icons, payment method logos,
  remote website favicons, generate QR codes, and manipulate remote image URLs.

  All endpoints in this service allow you to resize, crop, and change the output image
  quality for maximum performance and visibility in your app.
  """

  alias Appwrite.Exceptions.AppwriteException
  alias Appwrite.Utils.Client

  @doc """
  Get a browser icon URL.

  ## Parameters
  - `code` (`String.t()`): The browser code (e.g. `"chrome"`, `"firefox"`).
  - `width` (`non_neg_integer() | nil`): Desired icon width in pixels.
  - `height` (`non_neg_integer() | nil`): Desired icon height in pixels.
  - `quality` (`0..100 | nil`): Image quality percentage.

  ## Returns
  - `{:ok, String.t()}` containing the icon URL on success.
  - `{:error, AppwriteException.t()}` if `code` is missing.
  """
  @spec get_browser(String.t(), non_neg_integer() | nil, non_neg_integer() | nil, 0..100 | nil) ::
          {:ok, String.t()} | {:error, AppwriteException.t()}
  def get_browser(code, width \\ nil, height \\ nil, quality \\ nil) do
    if is_nil(code) do
      {:error, %AppwriteException{message: "Missing required parameter: code"}}
    else
      api_path = "/v1/avatars/browsers/#{code}"

      payload =
        %{
          "quality" => quality,
          "width" => width,
          "height" => height,
          "project" => Client.default_config()["project"]
        }
        |> Enum.reject(fn {_, v} -> is_nil(v) end)
        |> Map.new()

      url = URI.merge(Client.default_config()["endpoint"], api_path)
      query_string = URI.encode_query(Client.flatten(payload))
      {:ok, to_string(url) <> "?" <> query_string}
    end
  end

  @doc """
  Get a credit card provider icon URL.

  ## Parameters
  - `code` (`String.t()`): The credit card code (e.g. `"amex"`, `"visa"`).
  - `width` (`non_neg_integer() | nil`): Desired icon width in pixels.
  - `height` (`non_neg_integer() | nil`): Desired icon height in pixels.
  - `quality` (`0..100 | nil`): Image quality percentage.

  ## Returns
  - `{:ok, String.t()}` containing the icon URL on success.
  - `{:error, AppwriteException.t()}` if `code` is missing.
  """
  @spec get_credit_card(
          String.t(),
          non_neg_integer() | nil,
          non_neg_integer() | nil,
          0..100 | nil
        ) :: {:ok, String.t()} | {:error, AppwriteException.t()}
  def get_credit_card(code, width \\ nil, height \\ nil, quality \\ nil) do
    if is_nil(code) do
      {:error, %AppwriteException{message: "Missing required parameter: code"}}
    else
      api_path = "/v1/avatars/credit-cards/#{code}"

      payload =
        %{
          "quality" => quality,
          "width" => width,
          "height" => height,
          "project" => Client.default_config()["project"]
        }
        |> Enum.reject(fn {_, v} -> is_nil(v) end)
        |> Map.new()

      url = URI.merge(Client.default_config()["endpoint"], api_path)
      query_string = URI.encode_query(Client.flatten(payload))
      {:ok, to_string(url) <> "?" <> query_string}
    end
  end

  @doc """
  Get the favicon URL of a remote website.

  ## Parameters
  - `url` (`String.t()`): The URL of the remote website.

  ## Returns
  - `{:ok, String.t()}` containing the favicon fetch URL on success.
  - `{:error, AppwriteException.t()}` if `url` is missing.
  """
  @spec get_favicon(String.t()) :: {:ok, String.t()} | {:error, AppwriteException.t()}
  def get_favicon(url) do
    if is_nil(url) or url == "" do
      {:error, %AppwriteException{message: "Missing required parameter: url"}}
    else
      api_path = "/v1/avatars/favicon"

      payload = %{
        "url" => url,
        "project" => Client.default_config()["project"]
      }

      endpoint_url = URI.merge(Client.default_config()["endpoint"], api_path)
      query_string = URI.encode_query(Client.flatten(payload))
      {:ok, to_string(endpoint_url) <> "?" <> query_string}
    end
  end

  @doc """
  Get a country flag icon URL.

  ## Parameters
  - `code` (`String.t()`): ISO 3166-1 alpha-2 country code (e.g. `"us"`, `"gb"`).
  - `width` (`non_neg_integer() | nil`): Desired icon width in pixels.
  - `height` (`non_neg_integer() | nil`): Desired icon height in pixels.
  - `quality` (`0..100 | nil`): Image quality percentage.

  ## Returns
  - `{:ok, String.t()}` containing the flag URL on success.
  - `{:error, AppwriteException.t()}` if `code` is missing.
  """
  @spec get_flag(
          String.t(),
          non_neg_integer() | nil,
          non_neg_integer() | nil,
          0..100 | nil
        ) :: {:ok, String.t()} | {:error, AppwriteException.t()}
  def get_flag(code, width \\ nil, height \\ nil, quality \\ nil) do
    if is_nil(code) or code == "" do
      {:error, %AppwriteException{message: "Missing required parameter: code"}}
    else
      api_path = "/v1/avatars/flags/#{code}"

      payload =
        %{
          "quality" => quality,
          "width" => width,
          "height" => height,
          "project" => Client.default_config()["project"]
        }
        |> Enum.reject(fn {_, v} -> is_nil(v) end)
        |> Map.new()

      url = URI.merge(Client.default_config()["endpoint"], api_path)
      query_string = URI.encode_query(Client.flatten(payload))
      {:ok, to_string(url) <> "?" <> query_string}
    end
  end

  @doc """
  Get a remote image URL (cropped/resized).

  ## Parameters
  - `url` (`String.t()`): The URL of the remote image.
  - `width` (`non_neg_integer() | nil`): Crop width in pixels.
  - `height` (`non_neg_integer() | nil`): Crop height in pixels.

  ## Returns
  - `{:ok, String.t()}` containing the image fetch URL on success.
  - `{:error, AppwriteException.t()}` if `url` is missing.
  """
  @spec get_image(String.t(), non_neg_integer() | nil, non_neg_integer() | nil) ::
          {:ok, String.t()} | {:error, AppwriteException.t()}
  def get_image(url, width \\ nil, height \\ nil) do
    if is_nil(url) or url == "" do
      {:error, %AppwriteException{message: "Missing required parameter: url"}}
    else
      api_path = "/v1/avatars/image"

      payload =
        %{
          "url" => url,
          "width" => width,
          "height" => height,
          "project" => Client.default_config()["project"]
        }
        |> Enum.reject(fn {_, v} -> is_nil(v) end)
        |> Map.new()

      endpoint_url = URI.merge(Client.default_config()["endpoint"], api_path)
      query_string = URI.encode_query(Client.flatten(payload))
      {:ok, to_string(endpoint_url) <> "?" <> query_string}
    end
  end

  @doc """
  Generate a user initials avatar URL.

  ## Parameters
  - `name` (`String.t() | nil`): The user's name or initials.
  - `width` (`non_neg_integer() | nil`): Avatar width in pixels.
  - `height` (`non_neg_integer() | nil`): Avatar height in pixels.
  - `background` (`String.t() | nil`): Hex color for the background (without `#`).

  ## Returns
  - `{:ok, String.t()}` containing the avatar URL.
  """
  @spec get_initials(
          String.t() | nil,
          non_neg_integer() | nil,
          non_neg_integer() | nil,
          String.t() | nil
        ) :: {:ok, String.t()}
  def get_initials(name \\ nil, width \\ nil, height \\ nil, background \\ nil) do
    api_path = "/v1/avatars/initials"

    payload =
      %{
        "name" => name,
        "background" => background,
        "width" => width,
        "height" => height,
        "project" => Client.default_config()["project"]
      }
      |> Enum.reject(fn {_, v} -> is_nil(v) end)
      |> Map.new()

    url = URI.merge(Client.default_config()["endpoint"], api_path)
    query_string = URI.encode_query(Client.flatten(payload))
    {:ok, to_string(url) <> "?" <> query_string}
  end

  @doc """
  Generate a QR code image URL.

  ## Parameters
  - `text` (`String.t()`): The text or URL to encode in the QR code.
  - `size` (`non_neg_integer() | nil`): QR code size in pixels.
  - `margin` (`non_neg_integer() | nil`): Margin (quiet zone) size around the QR code.
  - `download` (`boolean() | nil`): When `true`, returns a downloadable response.

  ## Returns
  - `{:ok, String.t()}` containing the QR code URL on success.
  - `{:error, AppwriteException.t()}` if `text` is missing.
  """
  @spec get_qr(
          String.t(),
          non_neg_integer() | nil,
          non_neg_integer() | nil,
          boolean() | nil
        ) :: {:ok, String.t()} | {:error, AppwriteException.t()}
  def get_qr(text, size \\ nil, margin \\ nil, download \\ nil) do
    if is_nil(text) or text == "" do
      {:error, %AppwriteException{message: "Missing required parameter: text"}}
    else
      api_path = "/v1/avatars/qr"

      payload =
        %{
          "text" => text,
          "size" => size,
          "margin" => margin,
          "download" => download,
          "project" => Client.default_config()["project"]
        }
        |> Enum.reject(fn {_, v} -> is_nil(v) end)
        |> Map.new()

      url = URI.merge(Client.default_config()["endpoint"], api_path)
      query_string = URI.encode_query(Client.flatten(payload))
      {:ok, to_string(url) <> "?" <> query_string}
    end
  end
end
