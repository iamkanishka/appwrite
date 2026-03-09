defmodule Appwrite.Services.Accounts do
  @moduledoc """
  The Account service allows you to authenticate and manage a user account.
  You can use the account service to update user information,
  retrieve the user sessions across different devices,
  and fetch the user security logs with their recent activity.
  You can authenticate the user account by using multiple sign-in methods available.
  Once the user is authenticated, a new session object will be created to allow the user to access their private data and settings.
  """

  alias Appwrite.Utils.General
  alias Appwrite.Utils.Client
  alias Appwrite.Exceptions.AppwriteException

  alias Appwrite.Types.{
    User,
    IdentityList,
    Jwt,
    LogList,
    MfaType,
    MfaChallenge,
    MfaRecoveryCodes,
    MfaFactors,
    Preference,
    Token,
    Session,
    SessionList,
    Target
  }

  @doc """
  Get the currently logged-in user.

  ## Returns
  - `{:ok, User.t()}` on success
  - `{:error, reason}` on failure
  """
  @spec get() :: {:ok, User.t()} | {:error, any()}
  def get() do
    api_path = "/v1/account"
    payload = %{}
    api_header = %{"content-type" => "application/json"}

    try do
      user = Client.call("get", api_path, api_header, payload)
      {:ok, user}
    rescue
      error -> {:error, error}
    end
  end

  @doc """
  Create a new account.

  ## Parameters
  - `user_id`: The unique ID for the new user. Auto-generated if `nil`.
  - `email`: The email address of the user.
  - `password`: The user's password.
  - `name`: (Optional) The user's name.

  ## Returns
  - `{:ok, User.t()}` on success
  - `{:error, reason}` on failure
  """
  @spec create(String.t() | nil, String.t(), String.t(), String.t() | nil) ::
          {:ok, User.t()} | {:error, any()}
  def create(user_id \\ nil, email, password, name \\ nil) do
    if is_nil(email) or is_nil(password) do
      {:error, %AppwriteException{message: "Missing required parameters 'email' or 'password'"}}
    else
      api_path = "/v1/account"

      cust_or_autogen_user_id =
        if user_id == nil,
          do: String.replace(to_string(General.generate_unique_id()), "-", ""),
          else: user_id

      payload = %{
        "userId" => cust_or_autogen_user_id,
        "email" => email,
        "password" => password,
        "name" => name
      }

      api_header = %{"content-type" => "application/json"}

      try do
        user = Client.call("post", api_path, api_header, payload)
        {:ok, user}
      rescue
        error -> {:error, error}
      end
    end
  end

  @doc """
  Update the currently logged-in user's email address.

  After changing the email, the user's confirmation status is reset.
  A new confirmation email is not sent automatically — use `create_verification/1` to resend.
  Requires the user's current password for security.

  This endpoint can also be used to convert an anonymous account to a normal one
  by providing an email address and a new password.

  > #### Note {: .info}
  > Set the session token in the request header before calling this function.

  ## Parameters
  - `email`: The new email address.
  - `password`: The user's current password.

  ## Returns
  - `{:ok, User.t()}` on success
  - `{:error, reason}` on failure
  """
  @spec update_email(String.t(), String.t()) :: {:ok, User.t()} | {:error, any()}
  def update_email(email, password) do
    if is_nil(email) or is_nil(password) do
      {:error, %AppwriteException{message: "Missing required parameters"}}
    else
      api_path = "/v1/account/email"

      payload = %{
        "email" => email,
        "password" => password
      }

      api_header = %{"content-type" => "application/json"}

      try do
        user = Client.call("patch", api_path, api_header, payload)
        {:ok, user}
      rescue
        error -> {:error, error}
      end
    end
  end

  @doc """
  List identities for the currently logged-in user.

  ## Parameters
  - `queries`: (Optional) A list of query strings.

  ## Returns
  - `{:ok, IdentityList.t()}` on success
  - `{:error, reason}` on failure
  """
  @spec list_identities([String.t()] | nil) ::
          {:ok, IdentityList.t()} | {:error, any()}
  def list_identities(queries \\ nil) do
    api_path = "/v1/account/identities"

    payload = %{
      "queries" => queries
    }

    api_header = %{"content-type" => "application/json"}

    try do
      identity_list = Client.call("get", api_path, api_header, payload)
      {:ok, identity_list}
    rescue
      error -> {:error, error}
    end
  end

  @doc """
  Delete an identity by its unique ID.

  ## Parameters
  - `identity_id`: The ID of the identity to delete.

  ## Returns
  - `{:ok, map()}` on success
  - `{:error, reason}` on failure
  """
  @spec delete_identity(String.t()) :: {:ok, map()} | {:error, any()}
  def delete_identity(identity_id) do
    if is_nil(identity_id) do
      {:error, %AppwriteException{message: "Missing required parameter: identity_id"}}
    else
      api_path = "/v1/account/identities/#{identity_id}"
      api_header = %{"content-type" => "application/json"}
      payload = %{}

      try do
        deleted_identity = Client.call("delete", api_path, api_header, payload)
        {:ok, deleted_identity}
      rescue
        error -> {:error, error}
      end
    end
  end

  @doc """
  Create a JWT for the current user.

  ## Returns
  - `{:ok, Jwt.t()}` on success
  - `{:error, reason}` on failure
  """
  @spec create_jwt() :: {:ok, Jwt.t()} | {:error, any()}
  def create_jwt() do
    # NOTE: leading slash is required — "v1/..." was a bug
    api_path = "/v1/account/jwts"
    api_header = %{"content-type" => "application/json"}
    payload = %{}

    try do
      jwt = Client.call("post", api_path, api_header, payload)
      {:ok, jwt}
    rescue
      error -> {:error, error}
    end
  end

  @doc """
  List logs for the currently logged-in user.

  ## Parameters
  - `queries`: (Optional) A list of query strings.

  ## Returns
  - `{:ok, LogList.t()}` on success
  - `{:error, reason}` on failure
  """
  @spec list_logs([String.t()] | nil) :: {:ok, LogList.t()} | {:error, any()}
  def list_logs(queries \\ nil) do
    # NOTE: leading slash was missing in original — fixed
    api_path = "/v1/account/logs"
    payload = if queries, do: %{"queries" => queries}, else: %{}
    api_header = %{"content-type" => "application/json"}

    try do
      logs = Client.call("get", api_path, api_header, payload)
      {:ok, logs}
    rescue
      error -> {:error, error}
    end
  end

  @doc """
  Update MFA status for the account.

  ## Parameters
  - `mfa`: Boolean to enable (`true`) or disable (`false`) MFA.

  ## Returns
  - `{:ok, User.t()}` on success
  - `{:error, reason}` on failure
  """
  @spec update_mfa(boolean()) :: {:ok, User.t()} | {:error, any()}
  def update_mfa(mfa) do
    if is_nil(mfa) do
      {:error, %AppwriteException{message: "Missing required parameter: mfa"}}
    else
      api_path = "/v1/account/mfa"
      payload = %{"mfa" => mfa}
      api_header = %{"content-type" => "application/json"}

      try do
        user = Client.call("patch", api_path, api_header, payload)
        {:ok, user}
      rescue
        error -> {:error, error}
      end
    end
  end

  @doc """
  Create a new MFA authenticator.

  ## Parameters
  - `type`: The type of authenticator (e.g. `"totp"`).

  ## Returns
  - `{:ok, MfaType.t()}` on success
  - `{:error, reason}` on failure
  """
  @spec create_mfa_authenticator(String.t()) :: {:ok, MfaType.t()} | {:error, any()}
  def create_mfa_authenticator(type) do
    if is_nil(type) do
      {:error, %AppwriteException{message: "Missing required parameter: type"}}
    else
      api_path = "/v1/account/mfa/authenticators/#{type}"
      api_header = %{"content-type" => "application/json"}
      payload = %{}

      try do
        mfa_type = Client.call("post", api_path, api_header, payload)
        {:ok, mfa_type}
      rescue
        error -> {:error, error}
      end
    end
  end

  @doc """
  Verify and enable an MFA authenticator.

  ## Parameters
  - `type`: The type of authenticator.
  - `otp`: The one-time password to verify.

  ## Returns
  - `{:ok, User.t()}` on success
  - `{:error, reason}` on failure
  """
  @spec update_mfa_authenticator(String.t(), String.t()) ::
          {:ok, User.t()} | {:error, any()}
  def update_mfa_authenticator(type, otp) do
    with false <- is_nil(type),
         false <- is_nil(otp) do
      api_path = "/v1/account/mfa/authenticators/#{type}"
      api_header = %{"content-type" => "application/json"}
      payload = %{"otp" => otp}

      try do
        user = Client.call("put", api_path, api_header, payload)
        {:ok, user}
      rescue
        error -> {:error, error}
      end
    else
      true -> {:error, %AppwriteException{message: "Missing required parameters: type or otp"}}
    end
  end

  @doc """
  Delete an MFA authenticator.

  ## Parameters
  - `type`: The type of authenticator to delete.

  ## Returns
  - `{:ok, map()}` on success
  - `{:error, reason}` on failure
  """
  @spec delete_mfa_authenticator(String.t()) :: {:ok, map()} | {:error, any()}
  def delete_mfa_authenticator(type) do
    if is_nil(type) do
      {:error, %AppwriteException{message: "Missing required parameter: type"}}
    else
      api_path = "/v1/account/mfa/authenticators/#{type}"
      api_header = %{"content-type" => "application/json"}
      payload = %{}

      try do
        deleted_mfa_authenticator = Client.call("delete", api_path, api_header, payload)
        {:ok, deleted_mfa_authenticator}
      rescue
        error -> {:error, error}
      end
    end
  end

  @doc """
  Create an MFA challenge.

  ## Parameters
  - `factor`: The MFA factor to challenge. Must be a valid `AuthenticationFactor` value.

  ## Returns
  - `{:ok, MfaChallenge.t()}` on success
  - `{:error, reason}` on failure
  """
  @spec create_mfa_challenge(String.t()) ::
          {:ok, MfaChallenge.t()} | {:error, any()}
  def create_mfa_challenge(factor) do
    cond do
      is_nil(factor) ->
        {:error, %AppwriteException{message: "Missing required parameter: factor"}}

      not Appwrite.Consts.AuthenticationFactor.valid?(factor) ->
        {:error,
         %AppwriteException{
           message:
             "Invalid factor: #{inspect(factor)}. Must be one of: #{Enum.join(Appwrite.Consts.AuthenticationFactor.values(), ", ")}"
         }}

      true ->
        api_path = "/v1/account/mfa/challenge"
        api_header = %{"content-type" => "application/json"}
        payload = %{"factor" => factor}

        try do
          mfa_challenge = Client.call("post", api_path, api_header, payload)
          {:ok, mfa_challenge}
        rescue
          error -> {:error, error}
        end
    end
  end

  @doc """
  Complete an MFA challenge by providing the one-time password (OTP).

  To begin the MFA flow, use `create_mfa_challenge/1`.

  ## Parameters
  - `challenge_id` (required): The ID of the challenge.
  - `otp` (required): The one-time password.

  ## Returns
  - `{:ok, map()}` on success
  - `{:error, reason}` on failure
  """
  @spec update_mfa_challenge(String.t(), String.t()) :: {:ok, map()} | {:error, any()}
  def update_mfa_challenge(challenge_id, otp) do
    with :ok <- validate_params(challenge_id: challenge_id, otp: otp) do
      api_path = "/v1/account/mfa/challenge"
      api_header = %{"content-type" => "application/json"}
      payload = %{"challengeId" => challenge_id, "otp" => otp}

      try do
        updated_mfa_challenge = Client.call("put", api_path, api_header, payload)
        {:ok, updated_mfa_challenge}
      rescue
        error -> {:error, error}
      end
    else
      {:error, reason} -> {:error, reason}
    end
  end

  @doc """
  List the MFA factors available on the account.

  ## Returns
  - `{:ok, MfaFactors.t()}` on success
  - `{:error, reason}` on failure
  """
  @spec list_mfa_factors() :: {:ok, MfaFactors.t()} | {:error, any()}
  def list_mfa_factors() do
    api_path = "/v1/account/mfa/factors"
    api_header = %{"content-type" => "application/json"}
    payload = %{}

    try do
      mfa_factors = Client.call("get", api_path, api_header, payload)
      {:ok, mfa_factors}
    rescue
      error -> {:error, error}
    end
  end

  @doc """
  Get recovery codes that can be used as a backup for the MFA flow.

  ## Returns
  - `{:ok, MfaRecoveryCodes.t()}` on success
  - `{:error, reason}` on failure
  """
  @spec get_mfa_recovery_codes() :: {:ok, MfaRecoveryCodes.t()} | {:error, any()}
  def get_mfa_recovery_codes() do
    api_path = "/v1/account/mfa/recovery-codes"
    api_header = %{"content-type" => "application/json"}
    payload = %{}

    try do
      mfa_recovery_codes = Client.call("get", api_path, api_header, payload)
      {:ok, mfa_recovery_codes}
    rescue
      error -> {:error, error}
    end
  end

  @doc """
  Generate recovery codes for MFA.

  ## Returns
  - `{:ok, MfaRecoveryCodes.t()}` on success
  - `{:error, reason}` on failure
  """
  @spec create_mfa_recovery_codes() :: {:ok, MfaRecoveryCodes.t()} | {:error, any()}
  def create_mfa_recovery_codes() do
    api_path = "/v1/account/mfa/recovery-codes"
    api_header = %{"content-type" => "application/json"}
    payload = %{}

    try do
      mfa_recovery_codes = Client.call("post", api_path, api_header, payload)
      {:ok, mfa_recovery_codes}
    rescue
      error -> {:error, error}
    end
  end

  @doc """
  Regenerate recovery codes for MFA. Requires a completed OTP challenge.

  ## Returns
  - `{:ok, MfaRecoveryCodes.t()}` on success
  - `{:error, reason}` on failure
  """
  @spec update_mfa_recovery_codes() :: {:ok, MfaRecoveryCodes.t()} | {:error, any()}
  def update_mfa_recovery_codes() do
    api_path = "/v1/account/mfa/recovery-codes"
    api_header = %{"content-type" => "application/json"}
    payload = %{}

    try do
      mfa_recovery_codes = Client.call("patch", api_path, api_header, payload)
      {:ok, mfa_recovery_codes}
    rescue
      error -> {:error, error}
    end
  end

  @doc """
  Update the currently logged-in user's name.

  ## Parameters
  - `name` (required): The new name of the user.

  ## Returns
  - `{:ok, User.t()}` on success
  - `{:error, reason}` on failure
  """
  @spec update_name(String.t()) :: {:ok, User.t()} | {:error, any()}
  def update_name(name) do
    if is_nil(name) do
      {:error, %AppwriteException{message: "Missing required parameter: name"}}
    else
      api_path = "/v1/account/name"
      payload = %{"name" => name}
      api_header = %{"content-type" => "application/json"}

      try do
        user = Client.call("patch", api_path, api_header, payload)
        {:ok, user}
      rescue
        error -> {:error, error}
      end
    end
  end

  @doc """
  Update the currently logged-in user's password.

  ## Parameters
  - `new_password` (required): The new password for the user.
  - `old_password` (optional): The user's current password. Required when the user has an existing password.

  ## Returns
  - `{:ok, User.t()}` on success
  - `{:error, reason}` on failure
  """
  @spec update_password(String.t(), String.t() | nil) ::
          {:ok, User.t()} | {:error, any()}
  def update_password(new_password, old_password \\ nil) do
    if is_nil(new_password) do
      {:error, %AppwriteException{message: "Missing required parameter: new_password"}}
    else
      api_path = "/v1/account/password"

      payload =
        %{"password" => new_password, "oldPassword" => old_password}
        |> Enum.reject(fn {_k, v} -> is_nil(v) end)
        |> Map.new()

      api_header = %{"content-type" => "application/json"}

      try do
        user = Client.call("patch", api_path, api_header, payload)
        {:ok, user}
      rescue
        error -> {:error, error}
      end
    end
  end

  @doc """
  Update the currently logged-in user's phone number.

  ## Parameters
  - `phone` (required): The new phone number in E.164 format.
  - `password` (required): The user's current password.

  ## Returns
  - `{:ok, User.t()}` on success
  - `{:error, reason}` on failure
  """
  @spec update_phone(String.t(), String.t()) :: {:ok, User.t()} | {:error, any()}
  def update_phone(phone, password) do
    with :ok <- validate_params(phone: phone, password: password) do
      api_path = "/v1/account/phone"

      payload = %{
        "phone" => phone,
        "password" => password
      }

      api_header = %{"content-type" => "application/json"}

      try do
        user = Client.call("patch", api_path, api_header, payload)
        {:ok, user}
      rescue
        error -> {:error, error}
      end
    end
  end

  @doc """
  Get the preferences of the currently logged-in user.

  ## Returns
  - `{:ok, Preference.t()}` on success
  - `{:error, reason}` on failure
  """
  @spec get_prefs() :: {:ok, Preference.t()} | {:error, any()}
  def get_prefs() do
    api_path = "/v1/account/prefs"
    payload = %{}
    api_header = %{"content-type" => "application/json"}

    try do
      preference = Client.call("get", api_path, api_header, payload)
      {:ok, preference}
    rescue
      error -> {:error, error}
    end
  end

  @doc """
  Update the preferences of the currently logged-in user.

  The object you pass is stored as-is and replaces any previous preferences.

  ## Parameters
  - `prefs` (required): A string-keyed map of user preferences.

  ## Returns
  - `{:ok, User.t()}` on success
  - `{:error, reason}` on failure
  """
  @spec update_prefs(Preference.t()) :: {:ok, User.t()} | {:error, any()}
  def update_prefs(prefs) do
    if is_nil(prefs) do
      {:error, %AppwriteException{message: "Missing required parameter: prefs"}}
    else
      api_path = "/v1/account/prefs"
      api_header = %{"content-type" => "application/json"}
      payload = %{"prefs" => prefs}

      try do
        updated_prefs = Client.call("patch", api_path, api_header, payload)
        {:ok, updated_prefs}
      rescue
        error -> {:error, error}
      end
    end
  end

  @doc """
  Create a password recovery request for the user.

  ## Parameters
  - `email` (required): The user's email address.
  - `url` (required): The URL to redirect the user to after the password reset.

  ## Returns
  - `{:ok, Token.t()}` on success
  - `{:error, reason}` on failure
  """
  @spec create_recovery(String.t(), String.t()) :: {:ok, Token.t()} | {:error, any()}
  def create_recovery(email, url) do
    with :ok <- validate_params(email: email, url: url) do
      api_path = "/v1/account/recovery"
      api_header = %{"content-type" => "application/json"}
      payload = %{"email" => email, "url" => url}

      try do
        recovery = Client.call("post", api_path, api_header, payload)
        {:ok, recovery}
      rescue
        error -> {:error, error}
      end
    end
  end

  @doc """
  List all active sessions for the currently logged-in user.

  ## Returns
  - `{:ok, SessionList.t()}` on success
  - `{:error, reason}` on failure
  """
  @spec list_sessions() :: {:ok, SessionList.t()} | {:error, any()}
  def list_sessions() do
    api_path = "/v1/account/sessions"
    api_header = %{"content-type" => "application/json"}
    payload = %{}

    try do
      session_list = Client.call("get", api_path, api_header, payload)
      {:ok, session_list}
    rescue
      error -> {:error, error}
    end
  end

  @doc """
  Delete all active sessions for the currently logged-in user.

  ## Returns
  - `{:ok, map()}` on success
  - `{:error, reason}` on failure
  """
  @spec delete_sessions() :: {:ok, map()} | {:error, any()}
  def delete_sessions() do
    api_path = "/v1/account/sessions"
    api_header = %{"content-type" => "application/json"}
    payload = %{}

    try do
      result = Client.call("delete", api_path, api_header, payload)
      {:ok, result}
    rescue
      error -> {:error, error}
    end
  end

  @doc """
  Create an anonymous session.

  Registers an anonymous account in your project and creates a new session for the user.

  ## Returns
  - `{:ok, Session.t()}` on success
  - `{:error, reason}` on failure
  """
  @spec create_anonymous_session() :: {:ok, Session.t()} | {:error, any()}
  def create_anonymous_session() do
    api_path = "/v1/account/sessions/anonymous"
    api_header = %{"content-type" => "application/json"}
    payload = %{}

    try do
      session = Client.call("post", api_path, api_header, payload)
      {:ok, session}
    rescue
      error -> {:error, error}
    end
  end

  @doc """
  Create an email-password session.

  Allows the user to log in with an email and password combination.

  ## Parameters
  - `email` (required): The user's email.
  - `password` (required): The user's password.

  ## Returns
  - `{:ok, Session.t()}` on success
  - `{:error, reason}` on failure
  """
  @spec create_email_password_session(String.t(), String.t()) ::
          {:ok, Session.t()} | {:error, any()}
  def create_email_password_session(email, password) do
    if is_nil(email) or is_nil(password) do
      {:error, %AppwriteException{message: "Missing required parameters: 'email' or 'password'"}}
    else
      api_path = "/v1/account/sessions/email"
      payload = %{"email" => email, "password" => password}
      api_header = %{"content-type" => "application/json"}

      try do
        session = Client.call("post", api_path, api_header, payload)
        {:ok, session}
      rescue
        error -> {:error, error}
      end
    end
  end

  @doc """
  Update a magic URL session (complete the magic-link authentication flow).

  Creates a session using the user ID and secret from a magic-URL token flow.

  ## Parameters
  - `user_id` (required): The user ID.
  - `secret` (required): The secret token from the magic URL.

  ## Returns
  - `{:ok, Session.t()}` on success
  - `{:error, reason}` on failure
  """
  @spec update_magic_url_session(String.t(), String.t()) ::
          {:ok, Session.t()} | {:error, any()}
  def update_magic_url_session(user_id, secret) do
    if is_nil(user_id) or is_nil(secret) do
      {:error, %AppwriteException{message: "Missing required parameters: 'user_id' or 'secret'"}}
    else
      api_path = "/v1/account/sessions/magic-url"
      payload = %{"userId" => user_id, "secret" => secret}
      api_header = %{"content-type" => "application/json"}

      try do
        session = Client.call("put", api_path, api_header, payload)
        {:ok, session}
      rescue
        error -> {:error, error}
      end
    end
  end

  @doc """
  Create an OAuth2 session.

  Logs the user in with an OAuth2 provider. Returns the OAuth2 authorization URL.
  Redirect the user to this URL to complete authentication.

  ## Parameters
  - `provider` (required): The OAuth2 provider name (e.g. `"google"`, `"github"`).
  - `success` (optional): URL to redirect on successful authentication.
  - `failure` (optional): URL to redirect on authentication failure.
  - `scopes` (optional): List of requested OAuth2 scopes.

  ## Returns
  - `{:ok, String.t()}` containing the OAuth2 authorization URL on success
  - `{:error, reason}` on failure
  """
  @spec create_oauth2_session(
          String.t(),
          String.t() | nil,
          String.t() | nil,
          [String.t()] | nil
        ) ::
          {:ok, String.t()} | {:error, any()}
  def create_oauth2_session(
        provider,
        success \\ nil,
        failure \\ nil,
        scopes \\ nil
      ) do
    cond do
      is_nil(provider) ->
        {:error, %AppwriteException{message: "Missing required parameter: 'provider'"}}

      not Appwrite.Consts.OAuthProvider.valid?(provider) ->
        {:error, %AppwriteException{message: "Invalid provider: #{inspect(provider)}"}}

      true ->
        try do
          api_path = "/account/sessions/oauth2/#{provider}"
          url = URI.merge(Client.default_config()["endpoint"], api_path)
          payload = %{"project" => Client.default_config()["project"]}

          params =
            Enum.reduce(
              [{"success", success}, {"failure", failure}, {"scopes", scopes}],
              payload,
              fn
                {key, value}, acc when not is_nil(value) -> Map.put(acc, key, value)
                _, acc -> acc
              end
            )

          query_string = URI.encode_query(Client.flatten(params))
          {:ok, to_string(url) <> "?" <> query_string}
        rescue
          e in RuntimeError -> {:error, %AppwriteException{message: e.message}}
        end
    end
  end

  @doc """
  Update phone session (complete the phone/OTP authentication flow).

  Creates a session using the user ID and secret from a phone-based authentication flow.

  ## Parameters
  - `user_id` (required): The user ID.
  - `secret` (required): The secret token from the phone token.

  ## Returns
  - `{:ok, Session.t()}` on success
  - `{:error, reason}` on failure
  """
  @spec update_phone_session(String.t(), String.t()) ::
          {:ok, Session.t()} | {:error, any()}
  def update_phone_session(user_id, secret) do
    if is_nil(user_id) or is_nil(secret) do
      {:error, %AppwriteException{message: "Missing required parameters: 'user_id' or 'secret'"}}
    else
      api_path = "/v1/account/sessions/phone"
      payload = %{"userId" => user_id, "secret" => secret}
      api_header = %{"content-type" => "application/json"}

      try do
        session = Client.call("put", api_path, api_header, payload)
        {:ok, session}
      rescue
        error -> {:error, error}
      end
    end
  end

  @doc """
  Create a session from a token.

  Creates a session using the user ID and secret from a token-based authentication flow
  (e.g. after `create_email_token/3` or `create_phone_token/2`).

  ## Parameters
  - `user_id` (required): The user ID.
  - `secret` (required): The secret token.

  ## Returns
  - `{:ok, Session.t()}` on success
  - `{:error, reason}` on failure
  """
  @spec create_session(String.t(), String.t()) :: {:ok, Session.t()} | {:error, any()}
  def create_session(user_id, secret) do
    if is_nil(user_id) or is_nil(secret) do
      {:error, %AppwriteException{message: "Missing required parameters: 'user_id' or 'secret'"}}
    else
      api_path = "/v1/account/sessions/token"
      payload = %{"userId" => user_id, "secret" => secret}
      api_header = %{"content-type" => "application/json"}

      try do
        session = Client.call("post", api_path, api_header, payload)
        {:ok, session}
      rescue
        error -> {:error, error}
      end
    end
  end

  @doc """
  Update (extend) a session.

  Refreshes the session to extend its lifetime. If the session was created using
  an OAuth provider, this also refreshes the provider access token.

  ## Parameters
  - `session_map`: Headers map, e.g. `%{"X-Appwrite-Session" => session_token}`.
  - `session_id` (required): The ID of the session to update.

  ## Returns
  - `{:ok, Session.t()}` on success
  - `{:error, reason}` on failure
  """
  @spec update_session(%{String.t() => String.t()}, String.t()) ::
          {:ok, Session.t()} | {:error, any()}
  def update_session(session_map, session_id) do
    if is_nil(session_id) do
      {:error, %AppwriteException{message: "Missing required parameter: 'session_id'"}}
    else
      api_path = "/v1/account/sessions/#{session_id}"
      payload = %{}
      api_header = %{"content-type" => "application/json"} |> Map.merge(session_map)

      try do
        session = Client.call("patch", api_path, api_header, payload)
        {:ok, session}
      rescue
        error -> {:error, error}
      end
    end
  end

  @doc """
  Get a session by its ID.

  ## Parameters
  - `session_map`: Headers map, e.g. `%{"X-Appwrite-Session" => session_token}`.
  - `session_id` (required): The session ID. Use `"current"` for the active session.

  ## Returns
  - `{:ok, Session.t()}` on success
  - `{:error, reason}` on failure
  """
  @spec get_session(%{String.t() => String.t()}, String.t()) ::
          {:ok, Session.t()} | {:error, any()}
  def get_session(session_map, session_id) do
    if is_nil(session_id) do
      {:error, %AppwriteException{message: "Missing required parameter: 'session_id'"}}
    else
      api_path = "/v1/account/sessions/#{session_id}"
      payload = %{}
      api_header = %{"content-type" => "application/json"} |> Map.merge(session_map)

      try do
        session = Client.call("get", api_path, api_header, payload)
        {:ok, session}
      rescue
        error -> {:error, error}
      end
    end
  end

  @doc """
  Delete a session by its ID.

  ## Parameters
  - `session_map`: Headers map, e.g. `%{"X-Appwrite-Session" => session_token}`.
  - `session_id` (required): The session ID. Use `"current"` for the active session.

  ## Returns
  - `{:ok, map()}` on success
  - `{:error, reason}` on failure
  """
  @spec delete_session(%{String.t() => String.t()}, String.t()) ::
          {:ok, map()} | {:error, any()}
  def delete_session(session_map, session_id) do
    if is_nil(session_id) do
      {:error, %AppwriteException{message: "Missing required parameter: 'session_id'"}}
    else
      api_path = "/v1/account/sessions/#{session_id}"
      payload = %{}
      api_header = %{"content-type" => "application/json"} |> Map.merge(session_map)

      try do
        result = Client.call("delete", api_path, api_header, payload)
        {:ok, result}
      rescue
        error -> {:error, error}
      end
    end
  end

  @doc """
  Block the currently logged-in user account.

  Sets the user's status to disabled. The user record is not deleted but the account
  is blocked from access. Returns the updated user object.

  ## Returns
  - `{:ok, User.t()}` on success
  - `{:error, AppwriteException.t()}` on failure
  """
  @spec update_status() :: {:ok, User.t()} | {:error, AppwriteException.t()}
  def update_status() do
    api_path = "/v1/account/status"
    payload = %{}
    api_header = %{"content-type" => "application/json"}

    try do
      user = Client.call("patch", api_path, api_header, payload)
      {:ok, user}
    rescue
      error -> {:error, error}
    end
  end

  @doc """
  Create a push notification target.

  ## Parameters
  - `target_id` (required): Unique target identifier.
  - `identifier` (required): The push token / device identifier.
  - `provider_id` (optional): The messaging provider ID.

  ## Returns
  - `{:ok, Target.t()}` on success
  - `{:error, reason}` on failure
  """
  @spec create_push_target(String.t(), String.t(), String.t() | nil) ::
          {:ok, Target.t()} | {:error, any()}
  def create_push_target(target_id, identifier, provider_id \\ nil) do
    if is_nil(target_id) or is_nil(identifier) do
      {:error,
       %AppwriteException{message: "Missing required parameters: 'targetId' or 'identifier'"}}
    else
      api_path = "/v1/account/targets/push"
      api_header = %{"content-type" => "application/json"}

      payload =
        %{
          "targetId" => target_id,
          "identifier" => identifier,
          "providerId" => provider_id
        }
        |> Enum.reject(fn {_k, v} -> is_nil(v) end)
        |> Map.new()

      try do
        target = Client.call("post", api_path, api_header, payload)
        {:ok, target}
      rescue
        error -> {:error, error}
      end
    end
  end

  @doc """
  Update a push notification target.

  ## Parameters
  - `target_id` (required): The target identifier.
  - `identifier` (required): The new push token / device identifier.

  ## Returns
  - `{:ok, Target.t()}` on success
  - `{:error, reason}` on failure
  """
  @spec update_push_target(String.t(), String.t()) ::
          {:ok, Target.t()} | {:error, any()}
  def update_push_target(target_id, identifier) do
    if is_nil(target_id) or is_nil(identifier) do
      {:error,
       %AppwriteException{message: "Missing required parameters: 'targetId' or 'identifier'"}}
    else
      api_path = "/v1/account/targets/#{target_id}/push"
      api_header = %{"content-type" => "application/json"}
      payload = %{"identifier" => identifier}

      try do
        target = Client.call("put", api_path, api_header, payload)
        {:ok, target}
      rescue
        error -> {:error, error}
      end
    end
  end

  @doc """
  Delete a push notification target.

  ## Parameters
  - `target_id` (required): The target identifier.

  ## Returns
  - `{:ok, map()}` on success
  - `{:error, AppwriteException.t()}` on failure
  """
  @spec delete_push_target(String.t()) :: {:ok, map()} | {:error, AppwriteException.t()}
  def delete_push_target(target_id) do
    if is_nil(target_id) do
      {:error, %AppwriteException{message: "Missing required parameter: 'targetId'"}}
    else
      api_path = "/v1/account/targets/#{target_id}/push"
      api_header = %{"content-type" => "application/json"}
      payload = %{}

      try do
        result = Client.call("delete", api_path, api_header, payload)
        {:ok, result}
      rescue
        error -> {:error, error}
      end
    end
  end

  @doc """
  Create an email token for passwordless / magic-link authentication.

  Sends the user an email with a secret key for creating a session.

  ## Parameters
  - `user_id` (required): The user ID.
  - `email` (required): The email address.
  - `phrase` (optional): When `true`, a security phrase is included in the email.

  ## Returns
  - `{:ok, Token.t()}` on success
  - `{:error, AppwriteException.t()}` on failure
  """
  @spec create_email_token(String.t(), String.t(), boolean() | nil) ::
          {:ok, Token.t()} | {:error, AppwriteException.t()}
  def create_email_token(user_id, email, phrase \\ nil) do
    if is_nil(user_id) or is_nil(email) do
      {:error, %AppwriteException{message: "Missing required parameters: 'userId' or 'email'"}}
    else
      api_path = "/v1/account/tokens/email"
      api_header = %{"content-type" => "application/json"}

      payload =
        %{"userId" => user_id, "email" => email, "phrase" => phrase}
        |> Enum.reject(fn {_k, v} -> is_nil(v) end)
        |> Map.new()

      try do
        token = Client.call("post", api_path, api_header, payload)
        {:ok, token}
      rescue
        error -> {:error, error}
      end
    end
  end

  @doc """
  Create a magic URL token for passwordless authentication.

  Sends the user an email with a magic link for logging in.

  ## Parameters
  - `user_id` (required): The user ID.
  - `email` (required): The email address.
  - `url` (optional): Redirect URL after authentication.
  - `phrase` (optional): When `true`, a security phrase is included in the email.

  ## Returns
  - `{:ok, Token.t()}` on success
  - `{:error, AppwriteException.t()}` on failure
  """
  @spec create_magic_url_token(
          String.t(),
          String.t(),
          String.t() | nil,
          boolean() | nil
        ) ::
          {:ok, Token.t()} | {:error, AppwriteException.t()}
  def create_magic_url_token(user_id, email, url \\ nil, phrase \\ nil) do
    if is_nil(user_id) or is_nil(email) do
      {:error, %AppwriteException{message: "Missing required parameters: 'userId' or 'email'"}}
    else
      api_path = "/v1/account/tokens/magic-url"
      api_header = %{"content-type" => "application/json"}

      payload =
        %{"userId" => user_id, "email" => email, "url" => url, "phrase" => phrase}
        |> Enum.reject(fn {_k, v} -> is_nil(v) end)
        |> Map.new()

      try do
        token = Client.call("post", api_path, api_header, payload)
        {:ok, token}
      rescue
        error -> {:error, error}
      end
    end
  end

  @doc """
  Create a phone token for SMS-based authentication.

  Sends the user an SMS with a secret key for creating a session.

  ## Parameters
  - `user_id` (required): The user ID.
  - `phone` (required): The phone number in E.164 format.

  ## Returns
  - `{:ok, Token.t()}` on success
  - `{:error, AppwriteException.t()}` on failure
  """
  @spec create_phone_token(String.t(), String.t()) ::
          {:ok, Token.t()} | {:error, AppwriteException.t()}
  def create_phone_token(user_id, phone) do
    if is_nil(user_id) or is_nil(phone) do
      {:error, %AppwriteException{message: "Missing required parameters: 'userId' or 'phone'"}}
    else
      api_path = "/v1/account/tokens/phone"
      api_header = %{"content-type" => "application/json"}
      payload = %{"userId" => user_id, "phone" => phone}

      try do
        token = Client.call("post", api_path, api_header, payload)
        {:ok, token}
      rescue
        error -> {:error, error}
      end
    end
  end

  @doc """
  Create an OAuth2 token URL.

  Builds an OAuth2 authorization URL. Redirect the user to this URL to begin the
  OAuth2 flow. On success, `userId` and `secret` are appended to the `success` URL
  as query parameters, which can then be used with `create_session/2`.

  ## Parameters
  - `provider` (required): OAuth2 provider name (e.g. `"google"`, `"github"`).
  - `success` (optional): Success redirect URL.
  - `failure` (optional): Failure redirect URL.
  - `scopes` (optional): List of OAuth2 scopes to request.

  ## Returns
  - `{:ok, String.t()}` containing the authorization URL on success
  - `{:error, AppwriteException.t()}` on failure
  """
  @spec create_oauth2_token(
          String.t(),
          String.t() | nil,
          String.t() | nil,
          [String.t()] | nil
        ) :: {:ok, String.t()} | {:error, AppwriteException.t()}
  def create_oauth2_token(provider, success \\ nil, failure \\ nil, scopes \\ nil)

  def create_oauth2_token(nil, _success, _failure, _scopes) do
    {:error, %AppwriteException{message: "Missing required parameter: 'provider'"}}
  end

  def create_oauth2_token(provider, success, failure, scopes) do
    if not Appwrite.Consts.OAuthProvider.valid?(provider) do
      {:error, %AppwriteException{message: "Invalid provider: #{inspect(provider)}"}}
    else
      try do
        api_path = "/account/tokens/oauth2/#{provider}"
        url = URI.merge(Client.default_config()["endpoint"], api_path)

        params =
          %{
            "project" => Client.default_config()["project"],
            "success" => success,
            "failure" => failure,
            "scopes" => scopes
          }
          |> Enum.reject(fn {_key, value} -> is_nil(value) end)
          |> Map.new()

        query_string = URI.encode_query(Client.flatten(params))
        {:ok, to_string(url) <> "?" <> query_string}
      rescue
        exception ->
          {:error, %AppwriteException{message: Exception.message(exception)}}
      end
    end
  end

  @doc """
  Create email verification.

  Sends a verification email to the currently logged-in user's email address.
  After the user verifies via the link, use `update_verification/2` to complete the flow.

  ## Parameters
  - `url` (required): The redirect URL embedded in the verification email.

  ## Returns
  - `{:ok, Token.t()}` on success
  - `{:error, reason}` on failure
  """
  @spec create_verification(String.t()) :: {:ok, Token.t()} | {:error, any()}
  def create_verification(url) do
    if is_nil(url) or url == "" do
      {:error, %AppwriteException{message: "Missing required parameter: 'url'"}}
    else
      api_path = "/v1/account/verification"
      api_header = %{"content-type" => "application/json"}
      payload = %{"url" => url}

      try do
        verification = Client.call("post", api_path, api_header, payload)
        {:ok, verification}
      rescue
        error -> {:error, error}
      end
    end
  end

  @doc """
  Update (complete) email verification.

  Completes the user email verification process using the `userId` and `secret`
  from the verification link.

  ## Parameters
  - `user_id` (required): The user's ID.
  - `secret` (required): The secret key from the verification link.

  ## Returns
  - `{:ok, Token.t()}` on success
  - `{:error, reason}` on failure
  """
  @spec update_verification(String.t(), String.t()) ::
          {:ok, Token.t()} | {:error, any()}
  def update_verification(user_id, secret) do
    with :ok <- validate_params(user_id: user_id, secret: secret) do
      api_path = "/v1/account/verification"
      api_header = %{"content-type" => "application/json"}
      payload = %{"userId" => user_id, "secret" => secret}

      try do
        verification_token = Client.call("put", api_path, api_header, payload)
        {:ok, verification_token}
      rescue
        error -> {:error, error}
      end
    end
  end

  @doc """
  Create phone verification.

  Sends a verification SMS to the currently logged-in user's phone number.
  After the user verifies, use `update_phone_verification/2` to complete the flow.

  ## Returns
  - `{:ok, Token.t()}` on success
  - `{:error, reason}` on failure
  """
  @spec create_phone_verification() :: {:ok, Token.t()} | {:error, any()}
  def create_phone_verification() do
    api_path = "/v1/account/verification/phone"
    api_header = %{"content-type" => "application/json"}
    payload = %{}

    try do
      verification_token = Client.call("post", api_path, api_header, payload)
      {:ok, verification_token}
    rescue
      error -> {:error, error}
    end
  end

  @doc """
  Update (complete) phone verification.

  Completes the user phone verification process using the `userId` and `secret`
  from the verification SMS.

  ## Parameters
  - `user_id` (required): The user's ID.
  - `secret` (required): The secret key from the verification SMS.

  ## Returns
  - `{:ok, Token.t()}` on success
  - `{:error, reason}` on failure
  """
  @spec update_phone_verification(String.t(), String.t()) ::
          {:ok, Token.t()} | {:error, any()}
  def update_phone_verification(user_id, secret) do
    with :ok <- validate_params(user_id: user_id, secret: secret) do
      api_path = "/v1/account/verification/phone"
      api_header = %{"content-type" => "application/json"}
      payload = %{"userId" => user_id, "secret" => secret}

      try do
        verification_token = Client.call("put", api_path, api_header, payload)
        {:ok, verification_token}
      rescue
        error -> {:error, error}
      end
    end
  end

  # --- Private Helpers ---

  defp validate_params(params) do
    case Enum.find(params, fn {_, value} -> is_nil(value) end) do
      nil -> :ok
      {key, _} -> {:error, %AppwriteException{message: "Missing required parameter: #{key}"}}
    end
  end
end
