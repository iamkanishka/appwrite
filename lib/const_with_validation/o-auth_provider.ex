defmodule OAuthProvider do
  @moduledoc """
  Provides constants and validation functions for OAuth providers.

  This module defines various OAuth providers such as `Amazon`, `Apple`, `GitHub`, `Google`, and more.
  Helper functions are included to validate these provider values, ensuring only recognized OAuth providers are used.
  """


  @amazon "amazon"
  @apple "apple"
  @auth0 "auth0"
  @authentik "authentik"
  @autodesk "autodesk"
  @bitbucket "bitbucket"
  @bitly "bitly"
  @box "box"
  @dailymotion "dailymotion"
  @discord "discord"
  @disqus "disqus"
  @dropbox "dropbox"
  @etsy "etsy"
  @facebook "facebook"
  @github "github"
  @gitlab "gitlab"
  @google "google"
  @linkedin "linkedin"
  @microsoft "microsoft"
  @notion "notion"
  @oidc "oidc"
  @okta "okta"
  @paypal "paypal"
  @paypal_sandbox "paypalSandbox"
  @podio "podio"
  @salesforce "salesforce"
  @slack "slack"
  @spotify "spotify"
  @stripe "stripe"
  @tradeshift "tradeshift"
  @tradeshift_box "tradeshiftBox"
  @twitch "twitch"
  @wordpress "wordpress"
  @yahoo "yahoo"
  @yammer "yammer"
  @yandex "yandex"
  @zoho "zoho"
  @zoom "zoom"
  @mock "mock"

  @all_providers [
    @amazon,
    @apple,
    @auth0,
    @authentik,
    @autodesk,
    @bitbucket,
    @bitly,
    @box,
    @dailymotion,
    @discord,
    @disqus,
    @dropbox,
    @etsy,
    @facebook,
    @github,
    @gitlab,
    @google,
    @linkedin,
    @microsoft,
    @notion,
    @oidc,
    @okta,
    @paypal,
    @paypal_sandbox,
    @podio,
    @salesforce,
    @slack,
    @spotify,
    @stripe,
    @tradeshift,
    @tradeshift_box,
    @twitch,
    @wordpress,
    @yahoo,
    @yammer,
    @yandex,
    @zoho,
    @zoom,
    @mock
  ]



  @doc """
  Guard clause to check if a given `provider` is a valid  image gravity code.

  ## Examples

      iex> OAuthProvider.valid_provider("google")
      true

      iex> OAuthProvider.valid_provider("xxx")
      false
  """
  @spec valid_provider(String.t()) :: boolean()
  defguard valid_provider(provider) when provider in @all_providers




  @doc """
  Returns true if the given `provider` is a valid OAuth provider.

  ## Examples

      iex> OAuthProvider.is_valid_provider?("google")
      true

      iex> OAuthProvider.is_valid_provider?("example")
      false
  """
  @spec is_valid_provider?(String.t()) :: boolean()
  def is_valid_provider?(provider), do: provider in @all_providers

  @doc """
  Validates the given `provider` and returns `{:ok, provider}` if it is valid,
  or `{:error, "Invalid OAuth provider"}` otherwise.

  ## Examples

      iex> OAuthProvider.validate_provider("github")
      {:ok, "github"}

      iex> OAuthProvider.validate_provider("example")
      {:error, "Invalid OAuth provider"}
  """
  @spec valid_provider(String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def validate_provider(provider) when provider in @all_providers, do: {:ok, provider}
  def validate_provider(_provider), do: {:error, "Invalid OAuth provider"}

  @doc """
  Returns the given `provider` if it is valid. Raises an `ArgumentError`
  if the `provider` is invalid.

  ## Examples

      iex> OAuthProvider.validate_provider!("google")
      "google"

      iex> OAuthProvider.validate_provider!("example")
      ** (ArgumentError) Invalid OAuth provider: "example"
  """
  @spec validate_provider!(String.t()) :: String.t()
  def validate_provider!(provider) do
    if provider in @all_providers do
      provider
    else
      raise ArgumentError, "Invalid OAuth provider: #{inspect(provider)}"
    end
  end
end
