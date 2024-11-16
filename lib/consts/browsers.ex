defmodule Browser do
  @moduledoc """
  Provides constants and validation functions for different browser types.

  This module defines the allowed browser types and provides helper functions
  to validate them, ensuring only recognized browser types are used within the application.
  """

  @avant_browser "aa"
  @android_webview_beta "an"
  @google_chrome "ch"
  @google_chrome_ios "ci"
  @google_chrome_mobile "cm"
  @chromium "cr"
  @mozilla_firefox "ff"
  @safari "sf"
  @mobile_safari "mf"
  @microsoft_edge "ps"
  @microsoft_edge_ios "oi"
  @opera_mini "om"
  @opera "op"
  @opera_next "on"

  @all_browsers [
    @avant_browser,
    @android_webview_beta,
    @google_chrome,
    @google_chrome_ios,
    @google_chrome_mobile,
    @chromium,
    @mozilla_firefox,
    @safari,
    @mobile_safari,
    @microsoft_edge,
    @microsoft_edge_ios,
    @opera_mini,
    @opera,
    @opera_next
  ]

  @doc """
  Guard clause to check if a given browser type is valid.

  ## Examples

      iex> Browser.valid_browser("ch")
      true

      iex> Browser.valid_browser("unknown")
      false
  """
  @spec valid_browser(String.t()) :: boolean()
  defguard valid_browser(browser) when browser in @all_browsers

  @doc """
  Validates the given `browser` type and returns `{:ok, browser}` if it is valid,
  or `{:error, "Invalid browser type"}` otherwise.

  ## Examples

      iex> Browser.validate_browser("ch")
      {:ok, "ch"}

      iex> Browser.validate_browser("unknown")
      {:error, "Invalid browser type"}
  """
  @spec validate_browser(String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def validate_browser(browser) when valid_browser(browser), do: {:ok, browser}
  def validate_browser(_browser), do: {:error, "Invalid browser type"}

  @doc """
  Returns `true` if the given `browser` type is valid, otherwise `false`.

  ## Examples

      iex> Browser.is_valid_browser?("ff")
      true

      iex> Browser.is_valid_browser?("unknown")
      false
  """
  @spec is_valid_browser?(String.t()) :: boolean()
  def is_valid_browser?(browser), do: browser in @all_browsers

  @doc """
  Validates the given `browser` type and returns it if it is valid. Raises an
  `ArgumentError` if the `browser` type is invalid.

  ## Examples

      iex> Browser.validate_browser!("sf")
      "sf"

      iex> Browser.validate_browser!("unknown")
      ** (ArgumentError) Invalid browser type: "unknown"
  """
  @spec validate_browser!(String.t()) :: String.t()
  def validate_browser!(browser) do
    if browser in @all_browsers do
      browser
    else
      raise ArgumentError, "Invalid browser type: #{inspect(browser)}"
    end
  end
end
