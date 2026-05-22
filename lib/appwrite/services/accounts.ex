defmodule Appwrite.Services.Accounts do
  @moduledoc """
  The Account service allows you to authenticate and manage a user account.

  You can use the account service to update user information, retrieve sessions
  across devices, and fetch security logs. Authentication is supported via
  email/password, magic URLs, OAuth2, phone OTP, and anonymous sessions.
  """

  use Appwrite.Services.Base

  # Aliases ordered alphabetically (Credo.Check.Readability.AliasOrder).
  alias Appwrite.Consts.AuthenticationFactor
  alias Appwrite.Consts.OAuthProvider
  alias Appwrite.Types.Session
  alias Appwrite.Types.Token
  alias Appwrite.Utils.General

  # Dialyzer note: Client.call/5 returns `map() | nil | binary()`. Service
  # functions wrap the result in `{:ok, ...}`, so the actual success value is
  # always `{:ok, map() | nil | binary()}`. The more specific return types in
  # the @specs below are documentation contracts — they describe the shape of
  # the map, not a strict Dialyzer-provable guarantee.
  @dialyzer {:nowarn_function,
             [
               get: 0,
               create: 4,
               update_email: 2,
               list_identities: 2,
               delete_identity: 1,
               create_jwt: 1,
               list_logs: 2,
               update_mfa: 1,
               create_mfa_authenticator: 1,
               update_mfa_authenticator: 2,
               delete_mfa_authenticator: 1,
               create_mfa_challenge: 1,
               update_mfa_challenge: 2,
               list_mfa_factors: 0,
               get_mfa_recovery_codes: 0,
               create_mfa_recovery_codes: 0,
               update_mfa_recovery_codes: 0,
               update_name: 1,
               update_password: 2,
               update_phone: 2,
               get_prefs: 0,
               update_prefs: 1,
               create_recovery: 2,
               update_recovery: 3,
               list_sessions: 0,
               delete_sessions: 0,
               create_anonymous_session: 0,
               create_email_password_session: 2,
               update_magic_url_session: 2,
               create_oauth2_session: 4,
               update_phone_session: 2,
               create_session: 2,
               update_session: 2,
               get_session: 2,
               delete_session: 2,
               update_status: 0,
               create_push_target: 3,
               update_push_target: 2,
               delete_push_target: 1,
               create_email_token: 3,
               create_magic_url_token: 4,
               create_phone_token: 2,
               create_oauth2_token: 4,
               create_verification: 1,
               update_verification: 2,
               create_phone_verification: 0,
               update_phone_verification: 2
             ]}

  # ---------------------------------------------------------------------------
  # Account
  # ---------------------------------------------------------------------------

  @doc "Get the currently logged-in user."
  @spec get() :: {:ok, map()} | {:error, any()}
  def get do
    json_call("get", "/v1/account", %{})
  end

  @doc """
  Create a new account.

  ## Parameters
  - `user_id` — unique ID; auto-generated when `nil`
  - `email` (required)
  - `password` (required)
  - `name` (optional)
  """
  @spec create(String.t() | nil, String.t(), String.t(), String.t() | nil) ::
          {:ok, map()} | {:error, any()}
  def create(user_id \\ nil, email, password, name \\ nil) do
    if is_nil(email) or is_nil(password) do
      {:error, %AppwriteException{message: "Missing required parameters: 'email' or 'password'"}}
    else
      id =
        if is_nil(user_id),
          do: String.replace(to_string(General.generate_unique_id()), "-", ""),
          else: user_id

      payload =
        %{"userId" => id, "email" => email, "password" => password}
        |> maybe_put("name", name)

      json_call("post", "/v1/account", payload)
    end
  end

  @doc """
  Update the currently logged-in user's email address.

  Requires the current password for confirmation.
  """
  @spec update_email(String.t(), String.t()) :: {:ok, map()} | {:error, any()}
  def update_email(email, password) do
    if is_nil(email) or is_nil(password) do
      {:error, %AppwriteException{message: "Missing required parameters: 'email' or 'password'"}}
    else
      json_call("patch", "/v1/account/email", %{"email" => email, "password" => password})
    end
  end

  @doc """
  List identities for the currently logged-in user.

  ## Parameters
  - `queries` (optional)
  - `total` (optional) — when `false`, skips total count calculation
  """
  @spec list_identities([String.t()] | nil, boolean() | nil) :: {:ok, map()} | {:error, any()}
  def list_identities(queries \\ nil, total \\ nil) do
    payload =
      %{}
      |> maybe_put("queries", queries)
      |> maybe_put("total", total)

    json_call("get", "/v1/account/identities", payload)
  end

  @doc "Delete an identity by its unique ID."
  @spec delete_identity(String.t()) :: {:ok, map()} | {:error, any()}
  def delete_identity(identity_id) do
    with :ok <- require_all(identity_id: identity_id) do
      json_call("delete", "/v1/account/identities/#{identity_id}", %{})
    end
  end

  # ---------------------------------------------------------------------------
  # JWT
  # ---------------------------------------------------------------------------

  @doc """
  Create a JWT for the current user.

  ## Parameters
  - `duration` (optional) — seconds before expiry; default 900, max 3600
  """
  @spec create_jwt(integer() | nil) :: {:ok, map()} | {:error, any()}
  def create_jwt(duration \\ nil) do
    json_call("post", "/v1/account/jwts", maybe_put(%{}, "duration", duration))
  end

  # ---------------------------------------------------------------------------
  # Logs
  # ---------------------------------------------------------------------------

  @doc """
  List activity logs for the currently logged-in user.

  ## Parameters
  - `queries` (optional)
  - `total` (optional) — when `false`, skips total count calculation
  """
  @spec list_logs([String.t()] | nil, boolean() | nil) :: {:ok, map()} | {:error, any()}
  def list_logs(queries \\ nil, total \\ nil) do
    payload =
      %{}
      |> maybe_put("queries", queries)
      |> maybe_put("total", total)

    json_call("get", "/v1/account/logs", payload)
  end

  # ---------------------------------------------------------------------------
  # MFA
  # ---------------------------------------------------------------------------

  @doc "Enable or disable MFA on the current account."
  @spec update_mfa(boolean()) :: {:ok, map()} | {:error, any()}
  def update_mfa(mfa) do
    with :ok <- require_all(mfa: mfa) do
      json_call("patch", "/v1/account/mfa", %{"mfa" => mfa})
    end
  end

  @doc "Create a new MFA authenticator of the given `type` (e.g. `\"totp\"`)."
  @spec create_mfa_authenticator(String.t()) :: {:ok, map()} | {:error, any()}
  def create_mfa_authenticator(type) do
    with :ok <- require_all(type: type) do
      json_call("post", "/v1/account/mfa/authenticators/#{type}", %{})
    end
  end

  @doc "Verify and activate an MFA authenticator by providing its one-time password."
  @spec update_mfa_authenticator(String.t(), String.t()) :: {:ok, map()} | {:error, any()}
  def update_mfa_authenticator(type, otp) do
    # FIX: was `with false <- is_nil(type), false <- is_nil(otp)` — Credo
    # Refactor.WithClauses flags using `with` purely for nil checks. Use `if`.
    if is_nil(type) or is_nil(otp) do
      {:error, %AppwriteException{message: "Missing required parameters: type or otp"}}
    else
      json_call("put", "/v1/account/mfa/authenticators/#{type}", %{"otp" => otp})
    end
  end

  @doc "Delete an MFA authenticator."
  @spec delete_mfa_authenticator(String.t()) :: {:ok, map()} | {:error, any()}
  def delete_mfa_authenticator(type) do
    with :ok <- require_all(type: type) do
      json_call("delete", "/v1/account/mfa/authenticators/#{type}", %{})
    end
  end

  @doc """
  Create an MFA challenge for a given factor.

  `factor` must be a valid `Appwrite.Consts.AuthenticationFactor` value.
  """
  @spec create_mfa_challenge(String.t()) :: {:ok, map()} | {:error, any()}
  def create_mfa_challenge(factor) do
    cond do
      is_nil(factor) ->
        {:error, %AppwriteException{message: "Missing required parameter: factor"}}

      not AuthenticationFactor.valid?(factor) ->
        {:error, %AppwriteException{message: "Invalid factor: #{inspect(factor)}"}}

      true ->
        # FIX: path was /mfa/challenge (singular) — corrected to /mfa/challenges
        json_call("post", "/v1/account/mfa/challenges", %{"factor" => factor})
    end
  end

  @doc """
  Complete an MFA challenge by providing the one-time password.

  Returns the created `Session` on success.
  """
  # Return type is documented as Session.t() for developer reference;
  # the @dialyzer annotation above suppresses the spec mismatch warning
  # caused by Client.call/5 returning the opaque `map()`.
  @spec update_mfa_challenge(String.t(), String.t()) ::
          {:ok, Session.t()} | {:error, any()}
  def update_mfa_challenge(challenge_id, otp) do
    if is_nil(challenge_id) or is_nil(otp) do
      {:error, %AppwriteException{message: "Missing required parameters: challenge_id or otp"}}
    else
      # FIX: path was /mfa/challenge (singular) — corrected to /mfa/challenges
      json_call("put", "/v1/account/mfa/challenges", %{
        "challengeId" => challenge_id,
        "otp" => otp
      })
    end
  end

  @doc "List all available MFA factors on the current account."
  @spec list_mfa_factors() :: {:ok, map()} | {:error, any()}
  def list_mfa_factors, do: json_call("get", "/v1/account/mfa/factors", %{})

  @doc "Get the MFA recovery codes for the current account."
  @spec get_mfa_recovery_codes() :: {:ok, map()} | {:error, any()}
  def get_mfa_recovery_codes, do: json_call("get", "/v1/account/mfa/recovery-codes", %{})

  @doc "Generate new MFA recovery codes."
  @spec create_mfa_recovery_codes() :: {:ok, map()} | {:error, any()}
  def create_mfa_recovery_codes, do: json_call("post", "/v1/account/mfa/recovery-codes", %{})

  @doc "Regenerate MFA recovery codes (requires a completed OTP challenge)."
  @spec update_mfa_recovery_codes() :: {:ok, map()} | {:error, any()}
  def update_mfa_recovery_codes, do: json_call("patch", "/v1/account/mfa/recovery-codes", %{})

  # ---------------------------------------------------------------------------
  # Profile updates
  # ---------------------------------------------------------------------------

  @doc "Update the current user's display name."
  @spec update_name(String.t()) :: {:ok, map()} | {:error, any()}
  def update_name(name) do
    with :ok <- require_all(name: name) do
      json_call("patch", "/v1/account/name", %{"name" => name})
    end
  end

  @doc "Update the current user's password. `old_password` is required unless the account has no password."
  @spec update_password(String.t(), String.t() | nil) :: {:ok, map()} | {:error, any()}
  def update_password(new_password, old_password \\ nil) do
    with :ok <- require_all(new_password: new_password) do
      payload =
        %{"password" => new_password}
        |> maybe_put("oldPassword", old_password)

      json_call("patch", "/v1/account/password", payload)
    end
  end

  @doc "Update the current user's phone number. Requires current password."
  @spec update_phone(String.t(), String.t()) :: {:ok, map()} | {:error, any()}
  def update_phone(phone, password) do
    if is_nil(phone) or is_nil(password) do
      {:error, %AppwriteException{message: "Missing required parameters: phone or password"}}
    else
      json_call("patch", "/v1/account/phone", %{"phone" => phone, "password" => password})
    end
  end

  @doc "Get the current user's preferences object."
  @spec get_prefs() :: {:ok, map()} | {:error, any()}
  def get_prefs, do: json_call("get", "/v1/account/prefs", %{})

  @doc "Replace the current user's preferences object."
  @spec update_prefs(map()) :: {:ok, map()} | {:error, any()}
  def update_prefs(prefs) do
    with :ok <- require_all(prefs: prefs) do
      json_call("patch", "/v1/account/prefs", %{"prefs" => prefs})
    end
  end

  # ---------------------------------------------------------------------------
  # Password recovery
  # ---------------------------------------------------------------------------

  @doc """
  Send a password recovery email.

  ## Parameters
  - `email` (required) — the user's email address
  - `url` (required) — redirect URL embedded in the recovery email
  """
  @spec create_recovery(String.t(), String.t()) :: {:ok, map()} | {:error, any()}
  def create_recovery(email, url) do
    if is_nil(email) or is_nil(url) do
      {:error, %AppwriteException{message: "Missing required parameters: email or url"}}
    else
      json_call("post", "/v1/account/recovery", %{"email" => email, "url" => url})
    end
  end

  @doc """
  Complete the password reset flow.

  Call this with the `userId` and `secret` query parameters from the recovery
  email link, plus the user's chosen new password.

  ## Parameters
  - `user_id` (required)
  - `secret` (required) — the reset token from the email link
  - `password` (required) — the new password (8–256 chars)
  """
  @spec update_recovery(String.t(), String.t(), String.t()) ::
          {:ok, Token.t()} | {:error, any()}
  def update_recovery(user_id, secret, password) do
    if is_nil(user_id) or is_nil(secret) or is_nil(password) do
      {:error,
       %AppwriteException{message: "Missing required parameters: user_id, secret, or password"}}
    else
      json_call("put", "/v1/account/recovery", %{
        "userId" => user_id,
        "secret" => secret,
        "password" => password
      })
    end
  end

  # ---------------------------------------------------------------------------
  # Sessions
  # ---------------------------------------------------------------------------

  @doc "List all active sessions for the current user."
  @spec list_sessions() :: {:ok, map()} | {:error, any()}
  def list_sessions, do: json_call("get", "/v1/account/sessions", %{})

  @doc "Delete all active sessions (log out from all devices)."
  @spec delete_sessions() :: {:ok, map()} | {:error, any()}
  def delete_sessions, do: json_call("delete", "/v1/account/sessions", %{})

  @doc "Create an anonymous session."
  @spec create_anonymous_session() :: {:ok, map()} | {:error, any()}
  def create_anonymous_session, do: json_call("post", "/v1/account/sessions/anonymous", %{})

  @doc "Create a session using email and password."
  @spec create_email_password_session(String.t(), String.t()) :: {:ok, map()} | {:error, any()}
  def create_email_password_session(email, password) do
    if is_nil(email) or is_nil(password) do
      {:error, %AppwriteException{message: "Missing required parameters: email or password"}}
    else
      json_call("post", "/v1/account/sessions/email", %{"email" => email, "password" => password})
    end
  end

  @doc "Complete a magic-URL session (supply userId + secret from the email link)."
  @spec update_magic_url_session(String.t(), String.t()) :: {:ok, map()} | {:error, any()}
  def update_magic_url_session(user_id, secret) do
    if is_nil(user_id) or is_nil(secret) do
      {:error, %AppwriteException{message: "Missing required parameters: user_id or secret"}}
    else
      json_call("put", "/v1/account/sessions/magic-url", %{
        "userId" => user_id,
        "secret" => secret
      })
    end
  end

  @doc """
  Build the OAuth2 authorization URL for the given provider.

  Returns the URL as a string — the caller should redirect the user to it.
  """
  @spec create_oauth2_session(
          String.t(),
          String.t() | nil,
          String.t() | nil,
          [String.t()] | nil
        ) :: {:ok, String.t()} | {:error, any()}
  def create_oauth2_session(provider, success \\ nil, failure \\ nil, scopes \\ nil) do
    cond do
      is_nil(provider) ->
        {:error, %AppwriteException{message: "Missing required parameter: provider"}}

      not OAuthProvider.valid?(provider) ->
        {:error, %AppwriteException{message: "Invalid provider: #{inspect(provider)}"}}

      true ->
        try do
          url =
            URI.merge(Client.default_config()["endpoint"], "/account/sessions/oauth2/#{provider}")

          params =
            %{"project" => Client.default_config()["project"]}
            |> maybe_put("success", success)
            |> maybe_put("failure", failure)
            |> maybe_put("scopes", scopes)

          {:ok, to_string(url) <> "?" <> URI.encode_query(Client.flatten(params))}
        rescue
          e -> {:error, %AppwriteException{message: Exception.message(e)}}
        end
    end
  end

  @doc "Complete a phone OTP session (supply userId + secret from the SMS)."
  @spec update_phone_session(String.t(), String.t()) :: {:ok, map()} | {:error, any()}
  def update_phone_session(user_id, secret) do
    if is_nil(user_id) or is_nil(secret) do
      {:error, %AppwriteException{message: "Missing required parameters: user_id or secret"}}
    else
      json_call("put", "/v1/account/sessions/phone", %{"userId" => user_id, "secret" => secret})
    end
  end

  @doc "Create a session from a short-lived token (userId + secret)."
  @spec create_session(String.t(), String.t()) :: {:ok, map()} | {:error, any()}
  def create_session(user_id, secret) do
    if is_nil(user_id) or is_nil(secret) do
      {:error, %AppwriteException{message: "Missing required parameters: user_id or secret"}}
    else
      json_call("post", "/v1/account/sessions/token", %{"userId" => user_id, "secret" => secret})
    end
  end

  @doc "Extend or update an existing session."
  @spec update_session(map(), String.t()) :: {:ok, map()} | {:error, any()}
  def update_session(session_headers, session_id) do
    with :ok <- require_all(session_id: session_id) do
      merged = Map.merge(%{"content-type" => "application/json"}, session_headers)

      try do
        {:ok, Client.call("patch", "/v1/account/sessions/#{session_id}", merged, %{})}
      rescue
        e -> {:error, e}
      end
    end
  end

  @doc "Get a session by ID. Use `\"current\"` for the active session."
  @spec get_session(map(), String.t()) :: {:ok, map()} | {:error, any()}
  def get_session(session_headers, session_id) do
    with :ok <- require_all(session_id: session_id) do
      merged = Map.merge(%{"content-type" => "application/json"}, session_headers)

      try do
        {:ok, Client.call("get", "/v1/account/sessions/#{session_id}", merged, %{})}
      rescue
        e -> {:error, e}
      end
    end
  end

  @doc "Delete a session by ID. Use `\"current\"` to log out of the active session."
  @spec delete_session(map(), String.t()) :: {:ok, map()} | {:error, any()}
  def delete_session(session_headers, session_id) do
    with :ok <- require_all(session_id: session_id) do
      merged = Map.merge(%{"content-type" => "application/json"}, session_headers)

      try do
        {:ok, Client.call("delete", "/v1/account/sessions/#{session_id}", merged, %{})}
      rescue
        e -> {:error, e}
      end
    end
  end

  @doc "Block the current account (sets status to `false`)."
  @spec update_status() :: {:ok, map()} | {:error, any()}
  def update_status, do: json_call("patch", "/v1/account/status", %{})

  # ---------------------------------------------------------------------------
  # Push targets
  # ---------------------------------------------------------------------------

  @doc "Register a push notification target (device token)."
  @spec create_push_target(String.t(), String.t(), String.t() | nil) ::
          {:ok, map()} | {:error, any()}
  def create_push_target(target_id, identifier, provider_id \\ nil) do
    if is_nil(target_id) or is_nil(identifier) do
      {:error,
       %AppwriteException{message: "Missing required parameters: target_id or identifier"}}
    else
      payload =
        %{"targetId" => target_id, "identifier" => identifier}
        |> maybe_put("providerId", provider_id)

      json_call("post", "/v1/account/targets/push", payload)
    end
  end

  @doc "Update a push notification target's device token."
  @spec update_push_target(String.t(), String.t()) :: {:ok, map()} | {:error, any()}
  def update_push_target(target_id, identifier) do
    if is_nil(target_id) or is_nil(identifier) do
      {:error,
       %AppwriteException{message: "Missing required parameters: target_id or identifier"}}
    else
      json_call("put", "/v1/account/targets/#{target_id}/push", %{"identifier" => identifier})
    end
  end

  @doc "Delete a push notification target."
  @spec delete_push_target(String.t()) :: {:ok, map()} | {:error, any()}
  def delete_push_target(target_id) do
    with :ok <- require_all(target_id: target_id) do
      json_call("delete", "/v1/account/targets/#{target_id}/push", %{})
    end
  end

  # ---------------------------------------------------------------------------
  # Tokens
  # ---------------------------------------------------------------------------

  @doc "Create an email token for passwordless / magic-link authentication."
  @spec create_email_token(String.t(), String.t(), boolean() | nil) ::
          {:ok, map()} | {:error, any()}
  def create_email_token(user_id, email, phrase \\ nil) do
    if is_nil(user_id) or is_nil(email) do
      {:error, %AppwriteException{message: "Missing required parameters: user_id or email"}}
    else
      payload = %{"userId" => user_id, "email" => email} |> maybe_put("phrase", phrase)
      json_call("post", "/v1/account/tokens/email", payload)
    end
  end

  @doc "Create a magic URL token for passwordless authentication."
  @spec create_magic_url_token(String.t(), String.t(), String.t() | nil, boolean() | nil) ::
          {:ok, map()} | {:error, any()}
  def create_magic_url_token(user_id, email, url \\ nil, phrase \\ nil) do
    if is_nil(user_id) or is_nil(email) do
      {:error, %AppwriteException{message: "Missing required parameters: user_id or email"}}
    else
      payload =
        %{"userId" => user_id, "email" => email}
        |> maybe_put("url", url)
        |> maybe_put("phrase", phrase)

      json_call("post", "/v1/account/tokens/magic-url", payload)
    end
  end

  @doc "Create a phone token for SMS-based OTP authentication."
  @spec create_phone_token(String.t(), String.t()) :: {:ok, map()} | {:error, any()}
  def create_phone_token(user_id, phone) do
    if is_nil(user_id) or is_nil(phone) do
      {:error, %AppwriteException{message: "Missing required parameters: user_id or phone"}}
    else
      json_call("post", "/v1/account/tokens/phone", %{"userId" => user_id, "phone" => phone})
    end
  end

  @doc "Build the OAuth2 token URL (redirects user to provider, then creates a session token)."
  @spec create_oauth2_token(
          String.t(),
          String.t() | nil,
          String.t() | nil,
          [String.t()] | nil
        ) :: {:ok, String.t()} | {:error, any()}
  # Head clause for default args on multi-clause function (required by Elixir compiler)
  def create_oauth2_token(provider, success \\ nil, failure \\ nil, scopes \\ nil)

  def create_oauth2_token(nil, _success, _failure, _scopes) do
    {:error, %AppwriteException{message: "Missing required parameter: provider"}}
  end

  def create_oauth2_token(provider, success, failure, scopes) do
    if OAuthProvider.valid?(provider) do
      try do
        url =
          URI.merge(Client.default_config()["endpoint"], "/account/tokens/oauth2/#{provider}")

        params =
          %{"project" => Client.default_config()["project"]}
          |> maybe_put("success", success)
          |> maybe_put("failure", failure)
          |> maybe_put("scopes", scopes)

        {:ok, to_string(url) <> "?" <> URI.encode_query(Client.flatten(params))}
      rescue
        e -> {:error, %AppwriteException{message: Exception.message(e)}}
      end
    else
      {:error, %AppwriteException{message: "Invalid provider: #{inspect(provider)}"}}
    end
  end

  # ---------------------------------------------------------------------------
  # Verification
  # ---------------------------------------------------------------------------

  @doc "Send an email verification link to the current user."
  @spec create_verification(String.t()) :: {:ok, map()} | {:error, any()}
  def create_verification(url) do
    if is_nil(url) or url == "" do
      {:error, %AppwriteException{message: "Missing required parameter: url"}}
    else
      # FIX: was /v1/account/verification — corrected to /verifications/email
      json_call("post", "/v1/account/verifications/email", %{"url" => url})
    end
  end

  @doc "Confirm email verification using the userId and secret from the verification link."
  @spec update_verification(String.t(), String.t()) :: {:ok, map()} | {:error, any()}
  def update_verification(user_id, secret) do
    if is_nil(user_id) or is_nil(secret) do
      {:error, %AppwriteException{message: "Missing required parameters: user_id or secret"}}
    else
      # FIX: was /v1/account/verification — corrected to /verifications/email
      json_call("put", "/v1/account/verifications/email", %{
        "userId" => user_id,
        "secret" => secret
      })
    end
  end

  @doc "Send a phone verification SMS to the current user's registered phone number."
  @spec create_phone_verification() :: {:ok, map()} | {:error, any()}
  def create_phone_verification do
    # FIX: was /v1/account/verification/phone — corrected to /verifications/phone
    json_call("post", "/v1/account/verifications/phone", %{})
  end

  @doc "Confirm phone verification using the userId and secret from the verification SMS."
  @spec update_phone_verification(String.t(), String.t()) :: {:ok, map()} | {:error, any()}
  def update_phone_verification(user_id, secret) do
    if is_nil(user_id) or is_nil(secret) do
      {:error, %AppwriteException{message: "Missing required parameters: user_id or secret"}}
    else
      # FIX: was /v1/account/verification/phone — corrected to /verifications/phone
      json_call("put", "/v1/account/verifications/phone", %{
        "userId" => user_id,
        "secret" => secret
      })
    end
  end

  # ---------------------------------------------------------------------------
  # Private helpers
  # ---------------------------------------------------------------------------
end
