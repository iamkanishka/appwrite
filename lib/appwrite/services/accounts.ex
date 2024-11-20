defmodule Appwrite.Services.Accounts do
  @moduledoc """
  The Account service allows you to authenticate and manage a user account.
  You can use the account service to update user information,
  retrieve the user sessions across different devices,
  and fetch the user security logs with his or her recent activity.
  You can authenticate the user account by using multiple sign-in methods available.
  Once the user is authenticated, a new session object will be created to allow the user to access his or her private data and settings.

  Status: In Testing
  """

  alias Appwrite.Consts.AuthenticationFactor
  alias Appwrite.Helpers.Client
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
    User,
    Preferences,
    Token,
    Session,
    SessionList
  }

  @doc """
  Get the currently logged-in user.

  ## Returns
  - `{:ok, User.t()}` on success
  - `{:error, reason}` on failure
  """
  @spec get(Client.t()) :: {:ok, User.t()} | {:error, any()}
  def get(client) do
    api_path = "/account"
    uri = URI.merge(client.config.endpoint, api_path)

    try do
      Client.call(client, "get", uri, %{"content-type" => "application/json"}, %{})
    rescue
      error -> {:error, error}
    end
  end

  @doc """
  Create a new account.

  ## Parameters
  - `client`: The Appwrite client.
  - `user_id`: The unique ID for the new user.
  - `email`: The email address of the user.
  - `password`: The user's password.
  - `name`: (Optional) The user's name.

  ## Returns
  - `{:ok, User.t()}` on success
  - `{:error, reason}` on failure
  """
  @spec create(String.t(), String.t(), String.t(), String.t() | nil) ::
          {:ok, User.t()} | {:error, any()}
  def create(client, user_id, email, password, name \\ nil) do
    if is_nil(user_id) or is_nil(email) or is_nil(password) do
      {:error, %AppwriteException{message: "Missing required parameters"}}
    else
      api_path = "/account"
      uri = URI.merge(client.config.endpoint, api_path)

      payload = %{
        userId: user_id,
        email: email,
        password: password,
        name: name
      }

      try do
        Client.call(client, "post", uri, %{"content-type" => "application/json"}, payload)
      rescue
        error -> {:error, error}
      end
    end
  end

  @doc """
  Update the email address of the currently logged-in user.

  ## Parameters
  - `client`: The Appwrite client.
  - `email`: The new email address.
  - `password`: The user's password.

  ## Returns
  - `{:ok, User.t()}` on success
  - `{:error, reason}` on failure
  """
  @spec update_email(Client.t(), String.t(), String.t()) :: {:ok, User.t()} | {:error, any()}
  def update_email(client, email, password) do
    if is_nil(email) or is_nil(password) do
      {:error, %AppwriteException{message: "Missing required parameters"}}
    else
      api_path = "/account/email"
      uri = URI.merge(client.config.endpoint, api_path)

      payload = %{
        email: email,
        password: password
      }

      try do
        Client.call(client, "patch", uri, %{"content-type" => "application/json"}, payload)
      rescue
        error -> {:error, error}
      end
    end
  end

  @doc """
  List identities for the currently logged-in user.

  ## Parameters
  - `client`: The Appwrite client.
  - `queries`: (Optional) A list of query strings.

  ## Returns
  - `{:ok, IdentityList.t()}` on success
  - `{:error, reason}` on failure
  """
  @spec list_identities(Client.t(), list(String.t()) | nil) ::
          {:ok, IdentityList.t()} | {:error, any()}
  def list_identities(client, queries \\ nil) do
    api_path = "/account/identities"
    uri = URI.merge(client.config.endpoint, api_path)

    payload = %{
      queries: queries
    }

    try do
      Client.call(client, "get", uri, %{"content-type" => "application/json"}, payload)
    rescue
      error -> {:error, error}
    end
  end

  @doc """
  Delete an identity by its unique ID.

  ## Parameters
  - `client`: The Appwrite client.
  - `identity_id`: The ID of the identity to delete.

  ## Returns
  - `{:ok, map()}` on success
  - `{:error, reason}` on failure
  """
  @spec delete_identity(Client.t(), String.t()) :: {:ok, map()} | {:error, any()}
  def delete_identity(client, identity_id) do
    if is_nil(identity_id) do
      {:error, %AppwriteException{message: "Missing required parameter: identity_id"}}
    else
      api_path = "/account/identities/#{identity_id}"
      uri = URI.merge(client.config.endpoint, api_path)

      try do
        Client.call(client, "delete", uri, %{"content-type" => "application/json"}, %{})
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
  @spec create_jwt(Client.t()) :: {:ok, Jwt.t()} | {:error, any()}
  def create_jwt(client) do
    api_path = "/account/jwts"
    uri = URI.merge(client.config.endpoint, api_path)

    try do
      Client.call(client, "post", uri, %{"content-type" => "application/json"}, %{})
    rescue
      error -> {:error, error}
    end
  end

  @doc """
  List logs for the currently logged-in user.

  ## Parameters
  - `client`: The Appwrite client.
  - `queries`: (Optional) A list of query strings.

  ## Returns
  - `{:ok, LogList.t()}` on success
  - `{:error, reason}` on failure
  """
  @spec list_logs(Client.t(), list(String.t()) | nil) :: {:ok, LogList.t()} | {:error, any()}
  def list_logs(client, queries \\ nil) do
    api_path = "/account/logs"
    uri = URI.merge(client.config.endpoint, api_path)
    payload = if queries, do: %{queries: queries}, else: %{}

    try do
      Client.call(client, "get", uri, %{"content-type" => "application/json"}, payload)
    rescue
      error -> {:error, error}
    end
  end

  @doc """
  Update MFA status for the account.

  ## Parameters
  - `client`: The Appwrite client.
  - `mfa`: Boolean to enable or disable MFA.

  ## Returns
  - `{:ok, User.t()}` on success
  - `{:error, reason}` on failure
  """
  @spec update_mfa(Client.t(), boolean()) :: {:ok, User.t()} | {:error, any()}
  def update_mfa(client, mfa) do
    if is_nil(mfa) do
      {:error, %AppwriteException{message: "Missing required parameter: mfa"}}
    else
      api_path = "/account/mfa"
      uri = URI.merge(client.config.endpoint, api_path)
      payload = %{mfa: mfa}

      try do
        Client.call(client, "patch", uri, %{"content-type" => "application/json"}, payload)
      rescue
        error -> {:error, error}
      end
    end
  end

  @doc """
  Create a new MFA authenticator.

  ## Parameters
  - `client`: The Appwrite client.
  - `type`: The type of authenticator.

  ## Returns
  - `{:ok, MfaType.t()}` on success
  - `{:error, reason}` on failure
  """
  @spec create_mfa_authenticator(Client.t(), String.t()) :: {:ok, MfaType.t()} | {:error, any()}
  def create_mfa_authenticator(client, type) do
    if is_nil(type) do
      {:error, %AppwriteException{message: "Missing required parameter: type"}}
    else
      api_path = "/account/mfa/authenticators/#{type}"
      uri = URI.merge(client.config.endpoint, api_path)
      payload = %{}

      try do
        Client.call(client, "post", uri, %{"content-type" => "application/json"}, payload)
      rescue
        error -> {:error, error}
      end
    end
  end

  @doc """
  Verify an MFA authenticator.

  ## Parameters
  - `client`: The Appwrite client.
  - `type`: The type of authenticator.
  - `otp`: The one-time password to verify.

  ## Returns
  - `{:ok, User.t()}` on success
  - `{:error, reason}` on failure
  """
  @spec update_mfa_authenticator(Client.t(), String.t(), String.t()) ::
          {:ok, User.t()} | {:error, any()}
  def update_mfa_authenticator(client, type, otp) do
    with false <- is_nil(type),
         false <- is_nil(otp) do
      api_path = "/account/mfa/authenticators/#{type}"
      uri = URI.merge(client.config.endpoint, api_path)
      payload = %{otp: otp}

      try do
        Client.call(client, "put", uri, %{"content-type" => "application/json"}, payload)
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
  - `client`: The Appwrite client.
  - `type`: The type of authenticator to delete.

  ## Returns
  - `{:ok, map()}` on success
  - `{:error, reason}` on failure
  """
  @spec delete_mfa_authenticator(Client.t(), String.t()) :: {:ok, map()} | {:error, any()}
  def delete_mfa_authenticator(client, type) do
    if is_nil(type) do
      {:error, %AppwriteException{message: "Missing required parameter: type"}}
    else
      api_path = "/account/mfa/authenticators/#{type}"
      uri = URI.merge(client.config.endpoint, api_path)
      payload = %{}

      try do
        Client.call(client, "delete", uri, %{"content-type" => "application/json"}, payload)
      rescue
        error -> {:error, error}
      end
    end
  end

  @doc """
  Create an MFA challenge.

  ## Parameters
  - `client`: The Appwrite client.
  - `factor`: The MFA factor to challenge.

  ## Returns
  - `{:ok, MfaChallenge.t()}` on success
  - `{:error, reason}` on failure
  """
  @spec create_mfa_challenge(Client.t(), AuthenticationFactor) ::
          {:ok, MfaChallenge.t()} | {:error, any()}
  def create_mfa_challenge(client, factor) do
    if is_nil(factor) do
      {:error, %AppwriteException{message: "Missing required parameter: factor"}}
    else
      api_path = "/account/mfa/challenge"
      uri = URI.merge(client.config.endpoint, api_path)
      payload = %{factor: factor}

      try do
        Client.call(client, "post", uri, %{"content-type" => "application/json"}, payload)
      rescue
        error -> {:error, error}
      end
    end
  end

  # Please convert to elixir with specs, docs use with, try catch and use the types and constants if needed, and please add nil check for paramters

  @doc """
  Complete the MFA challenge by providing the one-time password (OTP).
  To begin the MFA flow, use `create_mfa_challenge/1`.

  ## Parameters
    - `client` (required): The Appwrite client instance.
    - `challenge_id` (required): The ID of the challenge.
    - `otp` (required): The one-time password.

  ## Returns
    - `:ok` on success.
    - `{:error, reason}` on failure.

  ## Examples

      iex> update_mfa_challenge(client, "challenge123", "123456")
      :ok

  """
  @spec update_mfa_challenge(Client.t(), String.t(), String.t()) :: :ok | {:error, any()}
  def update_mfa_challenge(client, challenge_id, otp) do
    with :ok <- validate_params(challenge_id: challenge_id, otp: otp),
         uri <- URI.merge(client.config.endpoint, "/account/mfa/challenge") do
      try do
        payload = %{"challengeId" => challenge_id, "otp" => otp}
        Client.call(client, "put", uri, payload)
      rescue
        exception -> {:error, exception}
      end
    else
      {:error, reason} -> {:error, reason}
    end
  end

  @doc """
  List the factors available on the account to be used for MFA challenge.

  ## Returns
    - `%MfaFactors{}` on success.
    - `{:error, reason}` on failure.
  """
  @spec list_mfa_factors(Client.t()) :: MfaFactors.t() | {:error, any()}
  def list_mfa_factors(client) do
    try do
      uri = URI.merge(client.config.endpoint, "/account/mfa/factors")
      Client.call(client, "get", uri, %{})
    rescue
      exception -> {:error, exception}
    end
  end

  @doc """
  Get recovery codes that can be used as a backup for the MFA flow.

  ## Returns
    - `%MfaRecoveryCodes{}` on success.
    - `{:error, reason}` on failure.
  """
  Mfa

  @spec get_mfa_recovery_codes(Client.t()) :: MfaRecoveryCodes.t() | {:error, any()}
  def get_mfa_recovery_codes(client) do
    try do
      uri = URI.merge(client.config.endpoint, "/account/mfa/recovery-codes")
      Client.call(client, "get", uri, %{})
    rescue
      exception -> {:error, exception}
    end
  end

  @doc """
  Generate recovery codes for MFA.

  ## Returns
    - `%MfaRecoveryCodes{}` on success.
    - `{:error, reason}` on failure.
  """
  @spec create_mfa_recovery_codes(Client.t()) :: MfaRecoveryCodes.t() | {:error, any()}
  def create_mfa_recovery_codes(client) do
    try do
      uri = URI.merge(client.config.endpoint, "/account/mfa/recovery-codes")
      Client.call(client, :post, uri, %{})
    rescue
      exception -> {:error, exception}
    end
  end

  @doc """
  Regenerate recovery codes for MFA. An OTP challenge is required.

  ## Returns
    - `%MfaRecoveryCodes{}` on success.
    - `{:error, reason}` on failure.
  """
  @spec update_mfa_recovery_codes(Client.t()) :: MfaRecoveryCodes.t() | {:error, any()}
  def update_mfa_recovery_codes(client) do
    try do
      uri = URI.merge(client.config.endpoint, "/account/mfa/recovery-codes")
      Client.call(client, "patch", uri, %{})
    rescue
      exception -> {:error, exception}
    end
  end

  @doc """
  Update the currently logged-in user's name.

  ## Parameters
    - `client` (required): The Appwrite client instance.
    - `name` (required): The new name of the user.

  ## Returns
    - `%User{}` on success.
    - `{:error, reason}` on failure.
  """
  @spec update_name(Client.t(), String.t()) :: {:ok, User.t()} | {:error, any()}
  def update_name(client, name) do
    with :ok <- validate_params(name: name),
         uri <- URI.merge(client.config.endpoint, "/account/name") do
      try do
        payload = %{"name" => name}
        {:ok, Client.call(client, "patch", uri, payload)}
      rescue
        exception -> {:error, exception}
      end
    end
  end

  @doc """
  Update the currently logged-in user's password.

  ## Parameters
    - `client` (required): The Appwrite client instance.
    - `password` (required): The new password for the user.
    - `old_password` (optional): The user's current password.

  ## Returns
    - `%User{}` on success.
    - `{:error, reason}` on failure.
  """
  @spec update_password(Client.t(), String.t(), String.t() | nil) ::
          {:ok, User.t()} | {:error, any()}
  def update_password(client, password, old_password \\ nil) do
    with :ok <- validate_params(password: password),
         uri <- URI.merge(client.config.endpoint, "/account/password") do
      try do
        payload =
          %{"password" => password, "oldPassword" => old_password}
          |> Enum.reject(fn {_k, v} -> is_nil(v) end)

        {:ok, Client.call(client, "patch", uri, payload)}
      rescue
        exception -> {:error, exception}
      end
    end
  end

  @doc """
  Update the currently logged-in user's phone number.

  ## Parameters
    - `client` (required): The Appwrite client instance.
    - `phone` (required): The new phone number.
    - `password` (required): The user's password.

  ## Returns
    - `%User{}` on success.
    - `{:error, reason}` on failure.
  """
  @spec update_phone(Client.t(), String.t(), String.t()) :: {:ok, User.t()} | {:error, any()}
  def update_phone(client, phone, password) do
    with :ok <- validate_params(phone: phone, password: password),
         uri <- URI.merge(client.config.endpoint, "/account/phone") do
      try do
        payload = %{"phone" => phone, "password" => password}
        {:ok, Client.call(client, "patch", uri, payload)}
      rescue
        exception -> {:error, exception}
      end
    end
  end

  @doc """
  Get the preferences of the currently logged-in user.

  ## Returns
    - `%Preferences{}` on success.
    - `{:error, reason}` on failure.
  """
  @spec get_prefs(Client.t()) :: {:ok, Preferences.t()} | {:error, any()}
  def get_prefs(client) do
    try do
      uri = URI.merge(client.config.endpoint, "/account/prefs")
      {:ok, Client.call(client, "get", uri, %{})}
    rescue
      exception -> {:error, exception}
    end
  end

  @doc """
  Update the preferences of the currently logged-in user.

  ## Parameters
    - `client` (required): The Appwrite client instance.
    - `prefs` (required): A map of user preferences.

  ## Returns
    - `%User{}` on success.
    - `{:error, reason}` on failure.
  """
  @spec update_prefs(Client.t(), map()) :: {:ok, User.t()} | {:error, any()}
  def update_prefs(client, prefs) do
    with :ok <- validate_params(prefs: prefs),
         uri <- URI.merge(client.config.endpoint, "/account/prefs") do
      try do
        payload = %{"prefs" => prefs}
        {:ok, Client.call(client, "patch", uri, payload)}
      rescue
        exception -> {:error, exception}
      end
    end
  end

  @doc """
  Create a password recovery request for the user.

  ## Parameters
    - `client` (required): The Appwrite client instance.
    - `email` (required): The user's email address.
    - `url` (required): The URL to redirect the user to after password reset.

  ## Returns
    - `%Token{}` on success.
    - `{:error, reason}` on failure.
  """
  @spec create_recovery(Client.t(), String.t(), String.t()) :: {:ok, Token.t()} | {:error, any()}
  def create_recovery(client, email, url) do
    with :ok <- validate_params(email: email, url: url),
         uri <- URI.merge(client.config.endpoint, "/account/recovery") do
      try do
        payload = %{"email" => email, "url" => url}
        {:ok, Client.call(client, "post", uri, payload)}
      rescue
        exception -> {:error, exception}
      end
    end
  end

  @doc """
  List all active sessions for the currently logged-in user.

  ## Returns
    - `%SessionList{}` on success.
    - `{:error, reason}` on failure.
  """
  @spec list_sessions(Client.t()) :: {:ok, SessionList.t()} | {:error, any()}
  def list_sessions(client) do
    try do
      uri = URI.merge(client.config.endpoint, "/account/sessions")
      {:ok, Client.call(client, "get", uri, %{})}
    rescue
      exception -> {:error, exception}
    end
  end

  @doc """
  Delete all active sessions for the currently logged-in user.

  ## Returns
    - `:ok` on success.
    - `{:error, reason}` on failure.
  """
  @spec delete_sessions(Client.t()) :: :ok | {:error, any()}
  def delete_sessions(client) do
    try do
      uri = URI.merge(client.config.endpoint, "/account/sessions")
      Client.call(client, "delete", uri, %{})
    rescue
      exception -> {:error, exception}
    end
  end

  @doc """
  Creates an anonymous session.

  Registers an anonymous account in your project and creates a new session for the user.

  ## Returns
  - `{:ok, %Session{}}` on success
  - `{:error, reason}` on failure
  """
  @spec create_anonymous_session(Client.t()) :: {:ok, Session.t()} | {:error, any()}
  def create_anonymous_session(%Client{} = client) do
    try do
      api_path = "/account/sessions/anonymous"
      uri = URI.merge(client.config.endpoint, api_path)
      payload = %{}

      with {:ok, response} <- Client.call(client, :post, uri, payload) do
        {:ok, Session.new(response.body)}
      else
        {:error, reason} -> {:error, reason}
      end
    rescue
      e in RuntimeError -> {:error, e.message}
    end
  end

  @doc """
  Creates an email-password session.

  Allows the user to log in with an email and password combination.

  ## Parameters
  - `client`: The Appwrite client.
  - `email`: The user's email (required).
  - `password`: The user's password (required).

  ## Returns
  - `{:ok, %Session{}}` on success
  - `{:error, reason}` on failure
  """
  @spec create_email_password_session(Client.t(), String.t() | nil, String.t() | nil) ::
          {:ok, Session.t()} | {:error, any()}
  def create_email_password_session(%Client{} = client, email, password) do
    if is_nil(email) or is_nil(password) do
      {:error, "Missing required parameters: 'email' or 'password'"}
    else
      try do
        api_path = "/account/sessions/email"
        uri = URI.merge(client.config.endpoint, api_path)
        payload = %{email: email, password: password}

        with {:ok, response} <- Client.call(client, :post, uri, payload) do
          {:ok, Session.new(response.body)}
        else
          {:error, reason} -> {:error, reason}
        end
      rescue
        e in RuntimeError -> {:error, e.message}
      end
    end
  end

  @doc """
  Update magic URL session.

  Creates a session using the user ID and secret from a token-based authentication flow.

  ## Parameters
  - `client`: The Appwrite client.
  - `user_id`: The user ID.
  - `secret`: The secret token.

  ## Returns
  - `{:ok, %Session{}}` on success
  - `{:error, reason}` on failure
  """
  @spec update_magic_url_session(Client.t(), String.t(), String.t()) ::
          {:ok, Session.t()} | {:error, any()}
  def update_magic_url_session(%Client{} = client, user_id, secret) do
    if is_nil(user_id) or is_nil(secret) do
      {:error, "Missing required parameters: 'user_id' or 'secret'"}
    else
      try do
        api_path = "/account/sessions/magic-url"
        uri = URI.merge(client.config.endpoint, api_path)
        payload = %{userId: user_id, secret: secret}

        with {:ok, response} <- Client.call(client, :put, uri, payload) do
          {:ok, Session.new(response.body)}
        else
          {:error, reason} -> {:error, reason}
        end
      rescue
        e in RuntimeError -> {:error, e.message}
      end
    end
  end

  @doc """
  Create an OAuth2 session.

  Logs the user in with an OAuth2 provider.

  ## Parameters
  - `client`: The Appwrite client.
  - `provider`: The OAuth2 provider.
  - `success`: URL to redirect on success.
  - `failure`: URL to redirect on failure.
  - `scopes`: List of requested OAuth2 scopes.

  ## Returns
  - `{:ok, String.t()}` containing the OAuth2 URL on success
  - `{:error, reason}` on failure
  """
  @spec create_oauth2_session(
          Client.t(),
          String.t(),
          String.t() | nil,
          String.t() | nil,
          [String.t()] | nil
        ) ::
          {:ok, String.t()} | {:error, any()}
  def create_oauth2_session(
        %Client{} = client,
        provider,
        success \\ nil,
        failure \\ nil,
        scopes \\ nil
      ) do
    if is_nil(provider) do
      {:error, "Missing required parameter: 'provider'"}
    else
      try do
        api_path = "/account/sessions/oauth2/#{provider}"
        uri = URI.merge(client.config.endpoint, api_path)
        payload = %{project: client.config.project}

        payload =
          Enum.reduce(
            [{"success", success}, {"failure", failure}, {"scopes", scopes}],
            payload,
            fn
              {key, value}, acc when not is_nil(value) -> Map.put(acc, key, value)
              _, acc -> acc
            end
          )

        uri = URI.update_query(uri, payload)

        if is_pid(self()) and Process.info(self(), :registered_name) == {:registered_name, :shell} do
          {:ok, uri.to_string()}
        else
          {:error, "Browser redirection is not supported"}
        end
      rescue
        e in RuntimeError -> {:error, e.message}
      end
    end
  end

  @doc """
  Update phone session.

  Creates a session using the user ID and secret from a phone-based authentication flow.

  ## Parameters
  - `client`: The Appwrite client.
  - `user_id`: The user ID.
  - `secret`: The secret token.

  ## Returns
  - `{:ok, %Session{}}` on success
  - `{:error, reason}` on failure
  """
  @spec update_phone_session(Client.t(), String.t(), String.t()) ::
          {:ok, Session.t()} | {:error, any()}
  def update_phone_session(%Client{} = client, user_id, secret) do
    if is_nil(user_id) or is_nil(secret) do
      {:error, "Missing required parameters: 'user_id' or 'secret'"}
    else
      try do
        api_path = "/account/sessions/phone"
        uri = URI.merge(client.config.endpoint, api_path)
        payload = %{userId: user_id, secret: secret}

        with {:ok, response} <- Client.call(client, :put, uri, payload) do
          {:ok, Session.new(response.body)}
        else
          {:error, reason} -> {:error, reason}
        end
      rescue
        e in RuntimeError -> {:error, e.message}
      end
    end
  end

  @doc """
  Create session.

  Creates a session using the user ID and secret from a token-based authentication flow.

  ## Parameters
  - `client`: The Appwrite client.
  - `user_id`: The user ID.
  - `secret`: The secret token.

  ## Returns
  - `{:ok, %Session{}}` on success
  - `{:error, reason}` on failure
  """
  @spec create_session(Client.t(), String.t(), String.t()) :: {:ok, Session.t()} | {:error, any()}
  def create_session(%Client{} = client, user_id, secret) do
    if is_nil(user_id) or is_nil(secret) do
      {:error, "Missing required parameters: 'user_id' or 'secret'"}
    else
      try do
        api_path = "/account/sessions/token"
        uri = URI.merge(client.config.endpoint, api_path)
        payload = %{userId: user_id, secret: secret}

        with {:ok, response} <- Client.call(client, :post, uri, payload) do
          {:ok, Session.new(response.body)}
        else
          {:error, reason} -> {:error, reason}
        end
      rescue
        e in RuntimeError -> {:error, e.message}
      end
    end
  end

  @doc """
  Updates a session to extend its length.

  This is useful when the session expiry is short. If the session was created using an OAuth provider, this endpoint refreshes the access token from the provider.

  ## Parameters
  - `client`: The Appwrite client.
  - `session_id`: The ID of the session to update.

  ## Returns
  - `{:ok, %Session{}}` on success
  - `{:error, reason}` on failure
  """
  @spec update_session(Client.t(), String.t()) :: {:ok, Session.t()} | {:error, any()}
  def update_session(%Client{} = client, session_id) do
    if is_nil(session_id) do
      {:error, "Missing required parameter: 'session_id'"}
    else
      try do
        api_path = "/account/sessions/#{session_id}"
        uri = URI.merge(client.config.endpoint, api_path)
        payload = %{}

        with {:ok, response} <- Client.call(client, :patch, uri, payload) do
          {:ok, Session.new(response.body)}
        else
          {:error, reason} -> {:error, reason}
        end
      rescue
        e in RuntimeError -> {:error, e.message}
      end
    end
  end

  @doc """
  Retrieves a session by session ID.

  ## Parameters
  - `client`: The Appwrite client.
  - `session_id`: The session ID (use "current" for the current session).

  ## Returns
  - `{:ok, %Session{}}` on success
  - `{:error, reason}` on failure
  """
  @spec get_session(Client.t(), String.t() | nil) :: {:ok, Session.t()} | {:error, any()}
  def get_session(%Client{} = client, session_id) do
    if is_nil(session_id) do
      {:error, "Missing required parameter: 'session_id'"}
    else
      try do
        api_path = "/account/sessions/#{session_id}"
        uri = URI.merge(client.config.endpoint, api_path)
        payload = %{}

        with {:ok, response} <- Client.call(client, :get, uri, payload) do
          {:ok, Session.new(response.body)}
        else
          {:error, reason} -> {:error, reason}
        end
      rescue
        e in RuntimeError -> {:error, e.message}
      end
    end
  end

  @doc """
  Deletes a session by session ID.

  ## Parameters
  - `client`: The Appwrite client.
  - `session_id`: The session ID (use "current" for the current session).

  ## Returns
  - `{:ok, %{}}` on success
  - `{:error, reason}` on failure
  """
  @spec delete_session(Client.t(), String.t() | nil) :: {:ok, map()} | {:error, any()}
  def delete_session(%Client{} = client, session_id) do
    if is_nil(session_id) do
      {:error, "Missing required parameter: 'session_id'"}
    else
      try do
        api_path = "/account/sessions/#{session_id}"
        uri = URI.merge(client.config.endpoint, api_path)
        payload = %{}

        with {:ok, response} <- Client.call(client, :delete, uri, payload) do
          {:ok, response.body}
        else
          {:error, reason} -> {:error, reason}
        end
      rescue
        e in RuntimeError -> {:error, e.message}
      end
    end
  end

  @doc """
  Updates the status of the currently logged-in user.

  Blocks the user account permanently. The user record is not deleted, but the account is blocked from access.

  ## Returns
    - `{:ok, user}` on success.
    - `{:error, %Appwrite.Exception{}}` on failure.
  """
  @spec update_status(Client.t()) :: {:ok, map()} | {:error, Exception.t()}
  def update_status( client) do
    with api_path <- "/account/status",
         uri <- URI.merge(client.config.endpoint, api_path),
         headers <- %{"content-type" => "application/json"},
         {:ok, response} <- Client.call(client, :patch, uri, headers, %{}) do
      {:ok, response}
    else
      {:error, error} -> {:error, Exception.from_error(error)}
    end
  rescue
    error -> {:error, Exception.from_exception(error)}
  end

  @doc """
  Creates a push target.

  ## Parameters
    - `target_id` (required): Target identifier.
    - `identifier` (required): Unique identifier for the push target.
    - `provider_id`: Optional provider ID.

  ## Returns
    - `{:ok, target}` on success.
    - `{:error, %Appwrite.Exception{}}` on failure.
  """
  @spec create_push_target(Client.t(), String.t(), String.t(), String.t() | nil) ::
          {:ok, map()} | {:error, Exception.t()}
  def create_push_target(%Client{} = client, target_id, identifier, provider_id \\ nil) do
    with false <- is_nil(target_id) or is_nil(identifier),
         api_path <- "/account/targets/push",
         uri <- URI.merge(client.config.endpoint, api_path),
         headers <- %{"content-type" => "application/json"},
         payload <-
           %{
             "targetId" => target_id,
             "identifier" => identifier,
             "providerId" => provider_id
           }
           |> Enum.reject(fn {_k, v} -> is_nil(v) end),
         {:ok, response} <- Client.call(client, :post, uri, headers, payload) do
      {:ok, response}
    else
      true -> {:error, Exception.new("Missing required parameters: 'targetId' or 'identifier'")}
      {:error, error} -> {:error, Exception.from_error(error)}
    end
  rescue
    error -> {:error, Exception.from_exception(error)}
  end

  @doc """
  Updates a push target.

  ## Parameters
    - `target_id` (required): Target identifier.
    - `identifier` (required): Unique identifier for the push target.

  ## Returns
    - `{:ok, target}` on success.
    - `{:error, %Appwrite.Exception{}}` on failure.
  """
  @spec update_push_target(Client.t(), String.t(), String.t()) ::
          {:ok, map()} | {:error, Exception.t()}
  def update_push_target(%Client{} = client, target_id, identifier) do
    with false <- is_nil(target_id) or is_nil(identifier),
         api_path <- "/account/targets/#{target_id}/push",
         uri <- URI.merge(client.config.endpoint, api_path),
         headers <- %{"content-type" => "application/json"},
         payload <- %{"identifier" => identifier},
         {:ok, response} <- Client.call(client, :put, uri, headers, payload) do
      {:ok, response}
    else
      true -> {:error, Exception.new("Missing required parameters: 'targetId' or 'identifier'")}
      {:error, error} -> {:error, Exception.from_error(error)}
    end
  rescue
    error -> {:error, Exception.from_exception(error)}
  end

  @doc """
  Deletes a push target.

  ## Parameters
    - `target_id` (required): Target identifier.

  ## Returns
    - `{:ok, %{}}` on success.
    - `{:error, %Appwrite.Exception{}}` on failure.
  """
  @spec delete_push_target(Client.t(), String.t()) :: {:ok, map()} | {:error, Exception.t()}
  def delete_push_target(%Client{} = client, target_id) do
    with false <- is_nil(target_id),
         api_path <- "/account/targets/#{target_id}/push",
         uri <- URI.merge(client.config.endpoint, api_path),
         headers <- %{"content-type" => "application/json"},
         {:ok, response} <- Client.call(client, :delete, uri, headers, %{}) do
      {:ok, response}
    else
      true -> {:error, Exception.new("Missing required parameter: 'targetId'")}
      {:error, error} -> {:error, Exception.from_error(error)}
    end
  rescue
    error -> {:error, Exception.from_exception(error)}
  end

  @doc """
  Creates an email token for user authentication.

  Sends the user an email with a secret key for creating a session.

  ## Parameters
    - `user_id` (required): The user ID.
    - `email` (required): The email address.
    - `phrase`: Optional phrase for authentication.

  ## Returns
    - `{:ok, token}` on success.
    - `{:error, %Appwrite.Exception{}}` on failure.
  """
  @spec create_email_token(Client.t(), String.t(), String.t(), boolean() | nil) ::
          {:ok, map()} | {:error, Exception.t()}
  def create_email_token(%Client{} = client, user_id, email, phrase \\ nil) do
    with false <- is_nil(user_id) or is_nil(email),
         api_path <- "/account/tokens/email",
         uri <- URI.merge(client.config.endpoint, api_path),
         headers <- %{"content-type" => "application/json"},
         payload <-
           %{"userId" => user_id, "email" => email, "phrase" => phrase}
           |> Enum.reject(fn {_k, v} -> is_nil(v) end),
         {:ok, response} <- Client.call(client, :post, uri, headers, payload) do
      {:ok, response}
    else
      true -> {:error, Exception.new("Missing required parameters: 'userId' or 'email'")}
      {:error, error} -> {:error, Exception.from_error(error)}
    end
  rescue
    error -> {:error, Exception.from_exception(error)}
  end

  @doc """
  Creates a magic URL token for user authentication.

  Sends the user an email with a magic link for logging in.

  ## Parameters
  - `user_id` (required): The user ID.
  - `email` (required): The email address.
  - `url`: Optional redirect URL.
  - `phrase`: Optional phrase for authentication.

  ## Returns
  - `{:ok, token}` on success.
  - `{:error, %Appwrite.Exception{}}` on failure.
  """
  @spec create_magic_url_token(
          Client.t(),
          String.t(),
          String.t(),
          String.t() | nil,
          boolean() | nil
        ) ::
          {:ok, map()} | {:error, Exception.t()}
  def create_magic_url_token(%Client{} = client, user_id, email, url \\ nil, phrase \\ nil) do
    with false <- is_nil(user_id) or is_nil(email),
         api_path <- "/account/tokens/magic-url",
         uri <- URI.merge(client.config.endpoint, api_path),
         headers <- %{"content-type" => "application/json"},
         payload <-
           %{"userId" => user_id, "email" => email, "url" => url, "phrase" => phrase}
           |> Enum.reject(fn {_k, v} -> is_nil(v) end),
         {:ok, response} <- Client.call(client, :post, uri, headers, payload) do
      {:ok, response}
    else
      true -> {:error, Exception.new("Missing required parameters: 'userId' or 'email'")}
      {:error, error} -> {:error, Exception.from_error(error)}
    end
  rescue
    error -> {:error, Exception.from_exception(error)}
  end

  @doc """
  Creates a phone token for user authentication.

  Sends the user an SMS with a secret key for creating a session.

  ## Parameters
  - `user_id` (required): The user ID.
  - `phone` (required): The phone number.

  ## Returns
  - `{:ok, token}` on success.
  - `{:error, %Appwrite.Exception{}}` on failure.
  """
  @spec create_phone_token(Client.t(), String.t(), String.t()) ::
          {:ok, map()} | {:error, Exception.t()}
  def create_phone_token(%Client{} = client, user_id, phone) do
    with false <- is_nil(user_id) or is_nil(phone),
         api_path <- "/account/tokens/phone",
         uri <- URI.merge(client.config.endpoint, api_path),
         headers <- %{"content-type" => "application/json"},
         payload <- %{"userId" => user_id, "phone" => phone},
         {:ok, response} <- Client.call(client, :post, uri, headers, payload) do
      {:ok, response}
    else
      true -> {:error, Exception.new("Missing required parameters: 'userId' or 'phone'")}
      {:error, error} -> {:error, Exception.from_error(error)}
    end
  rescue
    error -> {:error, Exception.from_exception(error)}
  end




    @doc """
  Create OAuth2 token.

  Allow the user to login to their account using the OAuth2 provider of their choice. Each OAuth2 provider should be enabled from the Appwrite console first. Use the `success` and `failure` arguments to provide redirect URLs back to your app when login is completed.

  If authentication succeeds, `userId` and `secret` of a token will be appended to the success URL as query parameters. These can be used to create a new session using the `create_session/3` function.

  A user is limited to 10 active sessions at a time by default. [Learn more about session limits](https://appwrite.io/docs/authentication-security#limits).

  ## Parameters
    - `client`: Appwrite client.
    - `provider`: OAuth2 provider (required).
    - `success`: Success redirect URL (optional).
    - `failure`: Failure redirect URL (optional).
    - `scopes`: OAuth2 scopes (optional).

  ## Returns
    - `{:ok, url}`: Redirect URL.
    - `{:error, Exception.t()}`: Error details.
  """
  @spec create_oauth2_token(Client.t(), String.t(),String.t() , [String.t()]) :: String.t()
  def create_oauth2_token(client, provider, success \\ nil, failure \\ nil, scopes \\ nil)
      when is_binary(provider) and
             (is_nil(success) or is_binary(success)) and
             (is_nil(failure) or is_binary(failure)) and
             (is_nil(scopes) or is_list(scopes)) do
    if provider == "" do
      {:error, %AppwriteException{message: "Missing required parameter: 'provider'"}}
    else
      try do
        api_path = "/account/tokens/oauth2/#{provider}"
        uri = URI.merge(client.config.endpoint, api_path)

        payload =
          %{
            "success" => success,
            "failure" => failure,
            "scopes" => scopes
          }
          |> Enum.reject(fn {_key, value} -> is_nil(value) end)

        headers = %{
          "content-type" => "application/json"
        }

        {:ok, Client.call(client, :get, uri, headers, payload)}
      rescue
        exception ->
          {:error, %AppwriteException{message: exception.message}}
      end
    end
  end

  @doc """
  Create email verification.

  Use this endpoint to send a verification message to your user's email address to confirm ownership. Learn more about how to complete the verification process by verifying both the `userId` and `secret` parameters.

  ## Parameters
    - `client`: Appwrite client.
    - `url`: The redirect URL (required).

  ## Returns
    - `{:ok, map()}`: Verification token.
    - `{:error, Exception.t()}`: Error details.
  """
  @spec create_verification(Client.t(), String.t()) :: {:ok, Token.t()} | {:error, any()}
  def create_verification(client, url) when is_binary(url) do
    if url == "" do
      {:error, %AppwriteException{message: "Missing required parameter: 'url'"}}
    else
      try do
        api_path = "/account/verification"
        uri = URI.merge(client.config.endpoint, api_path)

        payload = %{"url" => url}
        headers = %{"content-type" => "application/json"}

        Client.call(client, :post, uri, headers, payload)
      rescue
        exception ->
          {:error, %AppwriteException{message: exception.message}}
      end
    end
  end

  @doc """
  Update email verification.

  Use this endpoint to complete the user email verification process.

  ## Parameters
    - `client`: Appwrite client.
    - `user_id`: The user's ID (required).
    - `secret`: The secret key (required).

  ## Returns
    - `{:ok, map()}`: Verification token.
    - `{:error, Exception.t()}`: Error details.
  """
  @spec update_verification(Client.t(), String.t(),String.t() ) :: {:ok, Token.t()} | {:error, any()}
  def update_verification(client, user_id, secret)
      when is_binary(user_id) and is_binary(secret) do
    if user_id == "" or secret == "" do
      {:error, %AppwriteException{message: "Missing required parameters: 'user_id' or 'secret'"}}
    else
      try do
        api_path = "/account/verification"
        uri = URI.merge(client.config.endpoint, api_path)

        payload = %{"userId" => user_id, "secret" => secret}
        headers = %{"content-type" => "application/json"}

        Client.call(client, :put, uri, headers, payload)
      rescue
        exception ->
          {:error, %AppwriteException{message: exception.message}}
      end
    end
  end

  @doc """
  Create phone verification.

  Use this endpoint to send a verification SMS to the currently logged-in user.

  ## Parameters
    - `client`: Appwrite client.

  ## Returns
    - `{:ok, map()}`: Verification token.
    - `{:error, Exception.t()}`: Error details.
  """
  @spec create_phone_verification(Client.t()) ::{:ok, Token.t()} | {:error, any()}
  def create_phone_verification(client) do
    try do
      api_path = "/account/verification/phone"
      uri = URI.merge(client.config.endpoint, api_path)

      headers = %{"content-type" => "application/json"}

      Client.call(client, :post, uri, headers, %{})
    rescue
      exception ->
        {:error, %AppwriteException{message: exception.message}}
    end
  end

  @doc """
  Update phone verification.

  Use this endpoint to complete the user phone verification process.

  ## Parameters
    - `client`: Appwrite client.
    - `user_id`: The user's ID (required).
    - `secret`: The secret key (required).

  ## Returns
    - `{:ok, map()}`: Verification token.
    - `{:error, Exception.t()}`: Error details.
  """
  @spec update_phone_verification(Client.t(), String.t(), String.t()) :: {:ok, Token.t()} | {:error, any()}
  def update_phone_verification(client, user_id, secret)
      when is_binary(user_id) and is_binary(secret) do
    if user_id == "" or secret == "" do
      {:error, %AppwriteException{message: "Missing required parameters: 'user_id' or 'secret'"}}
    else
      try do
        api_path = "/account/verification/phone"
        uri = URI.merge(client.config.endpoint, api_path)

        payload = %{"userId" => user_id, "secret" => secret}
        headers = %{"content-type" => "application/json"}

        Client.call(client, :put, uri, headers, payload)
      rescue
        exception ->
          {:error, %AppwriteException{message: exception.message}}
      end
    end
  end





























  # Helper function to validate parameters
  defp validate_params(params) do
    case Enum.find(params, fn {_, value} -> is_nil(value) end) do
      nil -> :ok
      {key, _} -> {:error, "Missing required parameter: #{key}"}
    end
  end

  # Helper function to update query

  @doc """
  Updates the query parameters of a given URI.

  This function takes a URI and a map of parameters, merging the new parameters
  with any existing ones in the URI. If the URI already has a query string, the
  new parameters will override any existing ones with the same keys.

  ## Parameters

  - `uri`: A `%URI{}` struct or a string representing the URI to be updated.
  - `params`: A map containing the query parameters to add or update in the URI.

  ## Returns

  - An updated `%URI{}` struct with the modified query parameters.

  ## Examples

  Update a URI with new query parameters:

  ```elixir
  uri = URI.parse("https://api.example.com/resource?key1=value1")
  params = %{"key2" => "value2", "key1" => "newvalue1"}

  updated_uri = update_query(uri, params)
  URI.to_string(updated_uri)
  # Output: "https://api.example.com/resource?key1=newvalue1&key2=value2"

  """

  defp update_query(uri, params) do
    uri
    |> URI.parse()
    |> Map.update!(:query, fn query ->
      existing_params = URI.decode_query(query || "")
      updated_params = Map.merge(existing_params, params)
      URI.encode_query(updated_params)
    end)
  end
end
