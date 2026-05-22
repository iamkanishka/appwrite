defmodule Appwrite.Services.Avatars do
  @moduledoc """
  The Avatars service aims to help you complete everyday tasks related to
  your app image, icons, and avatars.

  """

  use Appwrite.Services.Base

  @doc """
  Get a browser icon image.

  ## Parameters
  - `code` (required) – browser code (see `Appwrite.Consts.Browser`)
  - `width` (optional) – image width in pixels (default 100)
  - `height` (optional) – image height in pixels (default 100)
  - `quality` (optional) – JPEG quality 0–100 (default 100)
  """
  @spec get_browser(String.t(), integer() | nil, integer() | nil, integer() | nil) ::
          {:ok, String.t()} | {:error, any()}
  def get_browser(code, width \\ nil, height \\ nil, quality \\ nil) do
    with :ok <- require_all(code: code) do
      build_url("/v1/avatars/browsers/#{code}", width: width, height: height, quality: quality)
    end
  end

  @doc """
  Get a credit card brand logo.

  ## Parameters
  - `code` (required) – credit card code (see `Appwrite.Consts.CreditCard`)
  - `width` (optional)
  - `height` (optional)
  - `quality` (optional)
  """
  @spec get_credit_card(String.t(), integer() | nil, integer() | nil, integer() | nil) ::
          {:ok, String.t()} | {:error, any()}
  def get_credit_card(code, width \\ nil, height \\ nil, quality \\ nil) do
    with :ok <- require_all(code: code) do
      build_url("/v1/avatars/credit-cards/#{code}",
        width: width,
        height: height,
        quality: quality
      )
    end
  end

  @doc """
  Get a favicon from a remote URL.

  ## Parameters
  - `url` (required) – the website URL whose favicon to fetch
  """
  @spec get_favicon(String.t()) :: {:ok, String.t()} | {:error, any()}
  def get_favicon(url) do
    with :ok <- require_all(url: url) do
      build_url("/v1/avatars/favicon", url: url)
    end
  end

  @doc """
  Get a country flag image.

  ## Parameters
  - `code` (required) – ISO 3166-1 two-letter country code
  - `width` (optional)
  - `height` (optional)
  - `quality` (optional)
  """
  @spec get_flag(String.t(), integer() | nil, integer() | nil, integer() | nil) ::
          {:ok, String.t()} | {:error, any()}
  def get_flag(code, width \\ nil, height \\ nil, quality \\ nil) do
    with :ok <- require_all(code: code) do
      build_url("/v1/avatars/flags/#{code}", width: width, height: height, quality: quality)
    end
  end

  @doc """
  Get an image from a remote URL, resized and cropped to fit.

  ## Parameters
  - `url` (required) – the source image URL
  - `width` (optional)
  - `height` (optional)
  """
  @spec get_image(String.t(), integer() | nil, integer() | nil) ::
          {:ok, String.t()} | {:error, any()}
  def get_image(url, width \\ nil, height \\ nil) do
    with :ok <- require_all(url: url) do
      build_url("/v1/avatars/image", url: url, width: width, height: height)
    end
  end

  @doc """
  Get a user's gravatar based on their email address.

  ## Parameters
  - `email` (required)
  - `size` (optional) – image size in pixels (1–2048, default 128)
  - `rating` (optional) – `"g"`, `"pg"`, `"r"`, or `"x"` (default `"g"`)
  - `default` (optional) – default image URL or one of the built-in defaults
  """
  @spec get_gravatar(String.t(), integer() | nil, String.t() | nil, String.t() | nil) ::
          {:ok, String.t()} | {:error, any()}
  def get_gravatar(email, size \\ nil, rating \\ nil, default \\ nil) do
    with :ok <- require_all(email: email) do
      build_url("/v1/avatars/gravatar",
        email: email,
        size: size,
        rating: rating,
        default: default
      )
    end
  end

  @doc """
  Generate initials avatar for a name.

  ## Parameters
  - `name` (optional) – full name; falls back to current user's name
  - `width` (optional)
  - `height` (optional)
  - `background` (optional) – hex color without `#`
  """
  @spec get_initials(String.t() | nil, integer() | nil, integer() | nil, String.t() | nil) ::
          {:ok, String.t()} | {:error, any()}
  def get_initials(name \\ nil, width \\ nil, height \\ nil, background \\ nil) do
    build_url("/v1/avatars/initials",
      name: name,
      width: width,
      height: height,
      background: background
    )
  end

  @doc """
  Generate a QR code image from a string.

  ## Parameters
  - `text` (required) – the text to encode
  - `size` (optional) – QR code size in pixels (1–1000, default 400)
  - `margin` (optional) – quiet-zone margin in pixels (0–10, default 1)
  - `download` (optional) – when `true`, response sets `Content-Disposition: attachment`
  """
  @spec get_qr(String.t(), integer() | nil, integer() | nil, boolean() | nil) ::
          {:ok, String.t()} | {:error, any()}
  def get_qr(text, size \\ nil, margin \\ nil, download \\ nil) do
    with :ok <- require_all(text: text) do
      build_url("/v1/avatars/qr", text: text, size: size, margin: margin, download: download)
    end
  end

  @doc """
  Take a screenshot of a webpage using a headless browser.

  This is a new endpoint added in Appwrite Cloud (not present in v0.2.1).

  ## Parameters
  - `url` (required) – the URL to screenshot
  - `opts` (optional keyword list):
    - `:viewport_width` – viewport width in pixels (default 1280)
    - `:viewport_height` – viewport height in pixels (default 800)
    - `:scale` – device pixel ratio (default 1)
    - `:theme` – `"light"` or `"dark"` (default `"light"`)
    - `:user_agent` – custom User-Agent string
    - `:fullpage` – when `true`, captures the full scrollable page (default `false`)
    - `:locale` – browser locale, e.g. `"en-US"`
    - `:timezone` – IANA timezone, e.g. `"America/New_York"`
    - `:latitude` / `:longitude` – geolocation override
    - `:accuracy` – geolocation accuracy in metres
    - `:touch` – emulate touch events (`true`/`false`)
    - `:permissions` – list of browser permissions to grant
    - `:sleep` – milliseconds to wait after page load before screenshotting
    - `:width` – output image width in pixels
    - `:height` – output image height in pixels
    - `:quality` – JPEG/WebP quality 0–100
    - `:output` – output format: `"jpeg"`, `"png"`, or `"webp"`
  """
  @spec get_screenshot(String.t(), keyword()) ::
          {:ok, String.t()} | {:error, any()}
  def get_screenshot(url, opts \\ []) do
    with :ok <- require_all(url: url) do
      build_url("/v1/avatars/screenshots",
        url: url,
        viewportWidth: opts[:viewport_width],
        viewportHeight: opts[:viewport_height],
        scale: opts[:scale],
        theme: opts[:theme],
        userAgent: opts[:user_agent],
        fullpage: opts[:fullpage],
        locale: opts[:locale],
        timezone: opts[:timezone],
        latitude: opts[:latitude],
        longitude: opts[:longitude],
        accuracy: opts[:accuracy],
        touch: opts[:touch],
        permissions: opts[:permissions],
        sleep: opts[:sleep],
        width: opts[:width],
        height: opts[:height],
        quality: opts[:quality],
        output: opts[:output]
      )
    end
  end

  # ────────────────────────────────────────────────
  # Private helpers
  # ────────────────────────────────────────────────

  defp build_url(path, params) do
    base = "#{Client.default_config()["endpoint"]}#{path}"

    query =
      %{"project" => Client.default_config()["project"]}
      |> merge_params(params)
      |> URI.encode_query()

    {:ok, "#{base}?#{query}"}
  end

  defp merge_params(base, pairs) do
    Enum.reduce(pairs, base, fn
      {_key, nil}, acc -> acc
      {key, value}, acc -> Map.put(acc, to_string(key), value)
    end)
  end

  defp require_all(params) do
    case Enum.find(params, fn {_, v} -> is_nil(v) end) do
      nil -> :ok
      {key, _} -> {:error, %AppwriteException{message: "Missing required parameter: #{key}"}}
    end
  end
end
