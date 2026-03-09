defmodule Appwrite.Consts.OAuthProvider do
  @moduledoc """
  OAuth2 provider identifiers supported by Appwrite.

  Pass any value from `values/0` to the OAuth2 session and token endpoints.
  """

  use Appwrite.Consts.Behaviour,
    values: ~w(
      amazon apple auth0 authentik autodesk
      bitbucket bitly box
      dailymotion discord disqus dropbox
      etsy facebook github gitlab google
      linkedin microsoft notion oidc okta
      paypal paypalSandbox podio salesforce slack spotify stripe
      tradeshift tradeshiftBox twitch
      wordpress yahoo yammer yandex zoho zoom
      mock
    ),
    name: "OAuth provider"
end
