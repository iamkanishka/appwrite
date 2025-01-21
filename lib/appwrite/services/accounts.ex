defmodule Appwrite.Services.Accounts do
  @moduledoc """
  The Account service allows you to authenticate and manage a user account.
  You can use the account service to update user information,
  retrieve the user sessions across different devices,
  and fetch the user security logs with his or her recent activity.
  You can authenticate the user account by using multiple sign-in methods available.
  Once the user is authenticated, a new session object will be created to allow the user to access his or her private data and settings.
  """

  alias Appwrite.Utils.General
  alias Appwrite.Consts.OAuthProvider
  alias Appwrite.Consts.AuthenticationFactor
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
    SessionList
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

    Task.async(fn ->
      try do
        user = Client.call("get", api_path, api_header, payload)
        # need to set session afterwords

        {:ok, user}
      rescue
        error -> {:error, error}
      end
    end)
    |> Task.await()
  end

  @doc """
  Create a new account.

  ## Parameters
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
  def create(user_id \\ nil, email, password, name \\ nil) do
    if is_nil(email) or is_nil(password) do
      {:error, %AppwriteException{message: "Missing required parameters 'email' or 'password'"}}
    else
      api_path = "/v1/account"

      cust_or_autogen_user_id =
        if user_id == nil,
          do: String.replace(to_string(General.generate_uniqe_id()), "-", ""),
          else: user_id

      payload = %{
        userId: cust_or_autogen_user_id,
        email: email,
        password: password,
        name: name
      }

      api_header = %{"content-type" => "application/json"}

      Task.async(fn ->
        try do
          user = Client.call("post", api_path, api_header, payload)

          {:ok, user}
        rescue
          error -> {:error, error}
        end
      end)
      |> Task.await()
    end
  end

  @doc """
  Update currently logged in user account email address. After changing user address, the user confirmation status will get reset. A new confirmation email is not sent automatically however you can use the send confirmation email endpoint again to send the confirmation email. For security measures, user password is required to complete this request.
  This endpoint can also be used to convert an anonymous account to a normal one, by passing an email address and a new password.
  Note: Before call make sure to set the session token in the header to the session token of the user you want to update

  ## Parameters
  - `email`: The new email address.
  - `password`: The user's password.

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
        email: email,
        password: password
      }

      api_header = %{"content-type" => "application/json"}

      Task.async(fn ->
        try do
          user = Client.call("patch", api_path, api_header, payload)

          {:ok, user}
        rescue
          error -> {:error, error}
        end
      end)
      |> Task.await()
    end
  end

  # @doc """
  # List identities for the currently logged-in user.

  # ## Parameters
  # - `queries`: (Optional) A list of query strings.

  # ## Returns
  # - `{:ok, IdentityList.t()}` on success
  # - `{:error, reason}` on failure
  # """
  @spec list_identities(list(String.t()) | nil) ::
          {:ok, IdentityList.t()} | {:error, any()}
  def list_identities(queries \\ nil) do
    api_path = "/v1/account/identities"

    payload = %{
      queries: queries
    }

    api_header = %{"content-type" => "application/json"}

    Task.async(fn ->
      try do
        identity_list = Client.call("get", api_path, api_header, payload)

        {:ok, identity_list}
      rescue
        error -> {:error, error}
      end
    end)
    |> Task.await()
  end

  # @doc """
  # Delete an identity by its unique ID.

  # ## Parameters
  # - `identity_id`: The ID of the identity to delete.

  # ## Returns
  # - `{:ok, map()}` on success
  # - `{:error, reason}` on failure
  # """
  @spec delete_identity(String.t()) :: {:ok, map()} | {:error, any()}
  def delete_identity(identity_id) do
    if is_nil(identity_id) do
      {:error, %AppwriteException{message: "Missing required parameter: identity_id"}}
    else
      api_path = "/v1/account/identities/#{identity_id}"
      api_header = %{"content-type" => "application/json"}
      payload = %{}

      Task.async(fn ->
        try do
          deleted_identity = Client.call("delete", api_path, api_header, payload)

          {:ok, deleted_identity}
        rescue
          error -> {:error, error}
        end
      end)
      |> Task.await()
    end
  end

  # @doc """
  # Create a JWT for the current user.

  # ## Returns
  # - `{:ok, Jwt.t()}` on success
  # - `{:error, reason}` on failure
  # """
  @spec create_jwt() :: {:ok, Jwt.t()} | {:error, any()}
  def create_jwt() do
    api_path = "v1/account/jwts"
    api_header = %{"content-type" => "application/json"}
    payload = %{}

    Task.async(fn ->
      try do
        jwt = Client.call("post", api_path, api_header, payload)

        {:ok, jwt}
      rescue
        error -> {:error, error}
      end
    end)
    |> Task.await()
  end

  # @doc """
  # List logs for the currently logged-in user.

  # ## Parameters
  # - `queries`: (Optional) A list of query strings.

  # ## Returns
  # - `{:ok, LogList.t()}` on success
  # - `{:error, reason}` on failure
  # """
  @spec list_logs(list(String.t()) | nil) :: {:ok, LogList.t()} | {:error, any()}
  def list_logs(queries \\ nil) do
    api_path = "v1/account/logs"
    payload = if queries, do: %{queries: queries}, else: %{}
    api_header = %{"content-type" => "application/json"}

    Task.async(fn ->
      try do
        logs = Client.call("get", api_path, api_header, payload)

        {:ok, logs}
      rescue
        error -> {:error, error}
      end
    end)
    |> Task.await()
  end

  @doc """
  Update MFA status for the account.

  ## Parameters
  - `mfa`: Boolean to enable or disable MFA.

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
      payload = %{mfa: mfa}

      api_header = %{"content-type" => "application/json"}

      Task.async(fn ->
        try do
          user = Client.call("patch", api_path, api_header, payload)

          {:ok, user}
        rescue
          error -> {:error, error}
        end
      end)
      |> Task.await()
    end
  end

  @doc """
  Create a new MFA authenticator.

  ## Parameters
  - `type`: The type of authenticator.

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

      Task.async(fn ->
        try do
          mfa_type = Client.call("post", api_path, api_header, payload)

          {:ok, mfa_type}
        rescue
          error -> {:error, error}
        end
      end)
      |> Task.await()
    end
  end

  @doc """
  Verify an MFA authenticator.

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

      payload = %{otp: otp}

      Task.async(fn ->
        try do
          user = Client.call("put", api_path, api_header, payload)

          {:ok, user}
        rescue
          error -> {:error, error}
        end
      end)
      |> Task.await()
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

      Task.async(fn ->
        try do
          deleted_mfa_authenticator = Client.call("delete", api_path, api_header, payload)

          {:ok, deleted_mfa_authenticator}
        rescue
          error -> {:error, error}
        end
      end)
      |> Task.await()
    end
  end

  @doc """
  Create an MFA challenge.

  ## Parameters
  - `factor`: The MFA factor to challenge.

  ## Returns
  - `{:ok, MfaChallenge.t()}` on success
  - `{:error, reason}` on failure
  """
  @spec create_mfa_challenge(AuthenticationFactor) ::
          {:ok, MfaChallenge.t()} | {:error, any()}
  def create_mfa_challenge(factor) do
    if is_nil(factor) do
      {:error, %AppwriteException{message: "Missing required parameter: factor"}}
    else
      api_path = "/v1/account/mfa/challenge"
      api_header = %{"content-type" => "application/json"}
      payload = %{factor: factor}

      Task.async(fn ->
        try do
          mfa_challenge = Client.call("post", api_path, api_header, payload)

          {:ok, mfa_challenge}
        rescue
          error -> {:error, error}
        end
      end)
      |> Task.await()
    end
  end

  @doc """
  Complete the MFA challenge by providing the one-time password (OTP).
  To begin the MFA flow, use `create_mfa_challenge/1`.

  ## Parameters
    - `challenge_id` (required): The ID of the challenge.
    - `otp` (required): The one-time password.

  ## Returns
    - `:ok` on success.
    - `{:error, reason}` on failure.
  """
  @spec update_mfa_challenge(String.t(), String.t()) :: {:ok, map()} | {:error, any()}
  def update_mfa_challenge(challenge_id, otp) do
    with :ok <- validate_params(challenge_id: challenge_id, otp: otp) do
      api_path = "/v1/account/mfa/challenge"
      api_header = %{"content-type" => "application/json"}
      payload = %{"challengeId" => challenge_id, "otp" => otp}

      Task.async(fn ->
        try do
          updated_mfa_challenge = Client.call("put", api_path, api_header, payload)

          {:ok, updated_mfa_challenge}
        rescue
          error -> {:error, error}
        end
      end)
      |> Task.await()
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
  @spec list_mfa_factors() :: MfaFactors.t() | {:error, any()}
  def list_mfa_factors() do
    api_path = "/v1/account/mfa/factors"
    api_header = %{"content-type" => "application/json"}
    payload = %{}

    Task.async(fn ->
      try do
        mfa_factors = Client.call("get", api_path, api_header, payload)

        {:ok, mfa_factors}
      rescue
        error -> {:error, error}
      end
    end)
    |> Task.await()
  end

  @doc """
  Get recovery codes that can be used as a backup for the MFA flow.

  ## Returns
    - `%MfaRecoveryCodes{}` on success.
    - `{:error, reason}` on failure.
  """

  @spec get_mfa_recovery_codes() :: {:ok, MfaRecoveryCodes.t()} | {:error, any()}
  def get_mfa_recovery_codes() do
    api_path = "/v1/account/mfa/recovery-codes"
    api_header = %{"content-type" => "application/json"}
    payload = %{}

    Task.async(fn ->
      try do
        mfa_recovery_codes = Client.call("get", api_path, api_header, payload)

        {:ok, mfa_recovery_codes}
      rescue
        error -> {:error, error}
      end
    end)
    |> Task.await()
  end

  @doc """
  Generate recovery codes for MFA.

  ## Returns
    - `%MfaRecoveryCodes{}` on success.
    - `{:error, reason}` on failure.
  """
  @spec create_mfa_recovery_codes() :: {:ok, MfaRecoveryCodes.t()} | {:error, any()}
  def create_mfa_recovery_codes() do
    api_path = "/v1/account/mfa/recovery-codes"
    api_header = %{"content-type" => "application/json"}
    payload = %{}

    Task.async(fn ->
      try do
        mfa_recovery_codes = Client.call("post", api_path, api_header, payload)

        {:ok, mfa_recovery_codes}
      rescue
        error -> {:error, error}
      end
    end)
    |> Task.await()
  end

  @doc """
  Regenerate recovery codes for MFA. An OTP challenge is required.

  ## Returns
    - `%MfaRecoveryCodes{}` on success.
    - `{:error, reason}` on failure.
  """
  @spec update_mfa_recovery_codes() :: {:ok, MfaRecoveryCodes.t()} | {:error, any()}
  def update_mfa_recovery_codes() do
    api_path = "/v1/account/mfa/recovery-codes"
    api_header = %{"content-type" => "application/json"}
    payload = %{}

    Task.async(fn ->
      try do
        mfa_recovery_codes = Client.call("patch", api_path, api_header, payload)

        {:ok, mfa_recovery_codes}
      rescue
        error -> {:error, error}
      end
    end)
    |> Task.await()
  end

  @doc """
  Update the currently logged-in user's name.

  ## Parameters
    - `name` (required): The new name of the user.

  ## Returns
    - `%User{}` on success.
    - `{:error, reason}` on failure.
  """
  @spec update_name(String.t()) :: {:ok, User.t()} | {:error, any()}
  def update_name(name) do
    if is_nil(name) do
      {:error, %AppwriteException{message: "Missing required parameter: name"}}
    else
      api_path = "/v1/account/name"

      payload = %{name: name}

      api_header = %{"content-type" => "application/json"}

      Task.async(fn ->
        try do
          user = Client.call("patch", api_path, api_header, payload)

          {:ok, user}
        rescue
          error -> {:error, error}
        end
      end)
      |> Task.await()
    end
  end

  @doc """
  Update the currently logged-in user's password.

  ## Parameters
    - `password` (required): The new password for the user.
    - `old_password` (optional): The user's current password.

  ## Returns
    - `%User{}` on success.
    - `{:error, reason}` on failure.
  """
  @spec update_password(String.t(), String.t() | nil) ::
          {:ok, User.t()} | {:error, any()}
  def update_password(old_password, new_password \\ nil) do
    if is_nil(old_password) or is_nil(new_password) do
      {:error, %AppwriteException{message: "Missing required parameters"}}
    else
      api_path = "/v1/account/password"

      payload =
        %{"password" => new_password, "oldPassword" => old_password}
        |> Enum.reject(fn {_k, v} -> is_nil(v) end)

      api_header = %{"content-type" => "application/json"}

      Task.async(fn ->
        try do
          user = Client.call("patch", api_path, api_header, payload)

          {:ok, user}
        rescue
          error -> {:error, error}
        end
      end)
      |> Task.await()
    end
  end

  @doc """
  Update the currently logged-in user's phone number.

  ## Parameters
    - `phone` (required): The new phone number.
    - `password` (required): The user's password.

  ## Returns
    - `%User{}` on success.
    - `{:error, reason}` on failure.
  """
  @spec update_phone(String.t(), String.t()) :: {:ok, User.t()} | {:error, any()}
  def update_phone(phone, password) do
    with :ok <- validate_params(phone: phone, password: password) do
      api_path = "/v1/account/phone"

      payload = %{
        phone: phone,
        password: password
      }

      api_header = %{"content-type" => "application/json"}

      Task.async(fn ->
        try do
          user = Client.call("patch", api_path, api_header, payload)
          {:ok, user}
        rescue
          error -> {:error, error}
        end
      end)
      |> Task.await()
    end
  end

  @doc """
  Get the preference of the currently logged-in user.

  ## Returns
    - `%Preference{}` on success.
    - `{:error, reason}` on failure.
  """
  @spec get_prefs() :: {:ok, Preference.t()} | {:error, any()}
  def get_prefs() do
    api_path = "/v1/account/prefs"

    payload = %{}

    api_header = %{"content-type" => "application/json"}

    Task.async(fn ->
      try do
        preference = Client.call("get", api_path, api_header, payload)

        {:ok, preference}
      rescue
        error -> {:error, error}
      end
    end)
    |> Task.await()
  end

  @doc """
  Update the preferences of the currently logged-in user.

  ## Parameters
    - `prefs` (required): A map of user preferences.

  ## Returns
    - `%User{}` on success.
    - `{:error, reason}` on failure.
  """
  @spec update_prefs(map()) :: {:ok, User.t()} | {:error, any()}
  def update_prefs(prefs) do
    if is_nil(prefs) do
      {:error, %AppwriteException{message: "Missing required parameter: prefs"}}
    else
      api_path = "/v1/account/prefs"
      api_header = %{"content-type" => "application/json"}
      payload = %{prefs: prefs}

      Task.async(fn ->
        try do
          updated_prefs = Client.call("patch", api_path, api_header, payload)

          {:ok, updated_prefs}
        rescue
          error -> {:error, error}
        end
      end)
      |> Task.await()
    end
  end

  @doc """
  Create a password recovery request for the user.

  ## Parameters
    - `email` (required): The user's email address.
    - `url` (required): The URL to redirect the user to after password reset.

  ## Returns
    - `%Token{}` on success.
    - `{:error, reason}` on failure.
  """
  @spec create_recovery(String.t(), String.t()) :: {:ok, Token.t()} | {:error, any()}
  def create_recovery(email, url) do
    api_path = "/v1/account/recovery"
    api_header = %{"content-type" => "application/json"}
    payload = %{email: email, url: url}

    Task.async(fn ->
      try do
        recovery = Client.call("post", api_path, api_header, payload)

        {:ok, recovery}
      rescue
        error -> {:error, error}
      end
    end)
    |> Task.await()
  end

  @doc """
  List all active sessions for the currently logged-in user.

  ## Returns
    - `%SessionList{}` on success.
    - `{:error, reason}` on failure.
  """
  @spec list_sessions() :: {:ok, SessionList.t()} | {:error, any()}
  def list_sessions() do
    api_path = "/v1/account/sessions"
    api_header = %{"content-type" => "application/json"}
    payload = %{}

    Task.async(fn ->
      try do
        recovery = Client.call("get", api_path, api_header, payload)

        {:ok, recovery}
      rescue
        error -> {:error, error}
      end
    end)
    |> Task.await()
  end

  @doc """
  Delete all active sessions for the currently logged-in user.

  ## Returns
    - `:ok` on success.
    - `{:error, reason}` on failure.
  """
  @spec delete_sessions() :: :ok | {:error, any()}
  def delete_sessions() do
    api_path = "/v1/account/sessions"
    api_header = %{"content-type" => "application/json"}
    payload = %{}

    Task.async(fn ->
      try do
        recovery = Client.call("delete", api_path, api_header, payload)

        {:ok, recovery}
      rescue
        error -> {:error, error}
      end
    end)
    |> Task.await()
  end

  @doc """
  Creates an anonymous session.

  Registers an anonymous account in your project and creates a new session for the user.

  ## Returns
  - `{:ok, %Session{}}` on success
  - `{:error, reason}` on failure
  """
  @spec create_anonymous_session() :: {:ok, Session.t()} | {:error, any()}
  def create_anonymous_session() do
    api_path = "/v1/account/sessions/anonymous"
    api_header = %{"content-type" => "application/json"}
    payload = %{}

    Task.async(fn ->
      try do
        session = Client.call("post", api_path, api_header, payload)

        {:ok, session}
      rescue
        error -> {:error, error}
      end
    end)
    |> Task.await()
  end

  @doc """
  Creates an email-password session.
  Note, if theres secret in

  Allows the user to log in with an email and password combination.

  ## Parameters
  - `email`: The user's email (required).
  - `password`: The user's password (required).

  ## Returns
  - `{:ok, %Session{}}` on success
  - `{:error, reason}` on failure
  """
  @spec create_email_password_session(String.t(), String.t()) ::
          {:ok, Session.t()} | {:error, any()}
  def create_email_password_session(email, password) do
    if is_nil(email) or is_nil(password) do
      {:error, "Missing required parameters: 'email' or 'password'"}
    else
      api_path = "/v1/account/sessions/email"
      payload = %{email: email, password: password}

      api_header = %{"content-type" => "application/json"}

      Task.async(fn ->
        try do
          session = Client.call("post", api_path, api_header, payload)
          {:ok, session}
        rescue
          error -> {:error, error}
        end
      end)
      |> Task.await()
    end
  end

  @doc """
  Update magic URL session.

  Creates a session using the user ID and secret from a token-based authentication flow.

  ## Parameters
  - `user_id`: The user ID.
  - `secret`: The secret token.

  ## Returns
  - `{:ok, %Session{}}` on success
  - `{:error, reason}` on failure
  """
  @spec update_magic_url_session(String.t(), String.t()) ::
          {:ok, Session.t()} | {:error, any()}
  def update_magic_url_session(user_id, secret) do
    if is_nil(user_id) or is_nil(secret) do
      {:error, "Missing required parameters: 'user_id' or 'secret'"}
    else
      api_path = "/v1/account/sessions/magic-url"
      payload = %{userId: user_id, secret: secret}

      api_header = %{"content-type" => "application/json"}

      Task.async(fn ->
        try do
          session = Client.call("put", api_path, api_header, payload)
          {:ok, session}
        rescue
          error -> {:error, error}
        end
      end)
      |> Task.await()
    end
  end

  @doc """
  Create an OAuth2 session.

  Logs the user in with an OAuth2 provider.

  ## Parameters
  - `provider`: The OAuth2 provider.
  - `success`: URL to redirect on success.
  - `failure`: URL to redirect on failure.
  - `scopes`: List of requested OAuth2 scopes.

  ## Returns
  - `{:ok, String.t()}` containing the OAuth2 URL on success
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
    if is_nil(provider) do
      {:error, "Missing required parameter: 'provider'"}
    else
      try do
        api_path = "/account/sessions/oauth2/#{provider}"
        url = URI.merge(Client.default_config()[~c"endpoint"], api_path)
        payload = %{project: Client.default_config()["project"]}

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
        {to_string(url) <> "?" <> query_string}

        # try do
        #   api_path = "/account/tokens/oauth2/#{provider}"
        #   url = URI.merge(Client.default_config()[~c"endpoint"], api_path)

        #   params =
        #     %{
        #       "success" => success,
        #       "failure" => failure,
        #       "scopes" => scopes
        #     }
        #     |> Enum.reject(fn {_key, value} -> is_nil(value) end)

        #   query_string = URI.encode_query(Client.flatten(params))
        #   {to_string(url) <> "?" <> query_string}
      rescue
        e in RuntimeError -> {:error, e.message}
      end
    end
  end

  @doc """
  Update phone session.

  Creates a session using the user ID and secret from a phone-based authentication flow.

  ## Parameters
  - `user_id`: The user ID.
  - `secret`: The secret token.

  ## Returns
  - `{:ok, %Session{}}` on success
  - `{:error, reason}` on failure
  """
  @spec update_phone_session(String.t(), String.t()) ::
          {:ok, Session.t()} | {:error, any()}
  def update_phone_session(user_id, secret) do
    if is_nil(user_id) or is_nil(secret) do
      {:error, "Missing required parameters: 'user_id' or 'secret'"}
    else
      api_path = "/v1/account/sessions/phone"
      payload = %{userId: user_id, secret: secret}

      api_header = %{"content-type" => "application/json"}

      Task.async(fn ->
        try do
          session = Client.call("put", api_path, api_header, payload)
          {:ok, session}
        rescue
          error -> {:error, error}
        end
      end)
      |> Task.await()
    end
  end

  @doc """
  Create session.

  Creates a session using the user ID and secret from a token-based authentication flow.

  ## Parameters
  - `user_id`: The user ID.
  - `secret`: The secret token.

  ## Returns
  - `{:ok, %Session{}}` on success
  - `{:error, reason}` on failure
  """
  @spec create_session(String.t(), String.t()) :: {:ok, Session.t()} | {:error, any()}
  def create_session(user_id, secret) do
    if is_nil(user_id) or is_nil(secret) do
      {:error, "Missing required parameters: 'user_id' or 'secret'"}
    else
      api_path = "/v1/account/sessions/token"
      payload = %{userId: user_id, secret: secret}

      api_header = %{"content-type" => "application/json"}

      Task.async(fn ->
        try do
          session = Client.call("post", api_path, api_header, payload)
          {:ok, session}
        rescue
          error -> {:error, error}
        end
      end)
      |> Task.await()
    end
  end

  @doc """
  Updates a session to extend its length.

  This is useful when the session expiry is short. If the session was created using an OAuth provider, this endpoint refreshes the access token from the provider.

  ## Parameters
  - `session_id`: The ID of the session to update.

  ## Returns
  - `{:ok, %Session{}}` on success
  - `{:error, reason}` on failure
  """
  @spec update_session(String.t()) :: {:ok, Session.t()} | {:error, any()}
  def update_session(session_id) do
    if is_nil(session_id) do
      {:error, "Missing required parameter: 'session_id'"}
    else
      api_path = "/v1/account/sessions/#{session_id}"
      payload = %{}

      api_header = %{"content-type" => "application/json"}

      Task.async(fn ->
        try do
          session = Client.call("patch", api_path, api_header, payload)
          {:ok, session}
        rescue
          error -> {:error, error}
        end
      end)
      |> Task.await()
    end
  end

  @doc """
  Retrieves a session by session ID.

  ## Parameters
  - `session_id`: The session ID (use "current" for the current session).

  ## Returns
  - `{:ok, %Session{}}` on success
  - `{:error, reason}` on failure
  """
  @spec get_session(String.t() | nil) :: {:ok, Session.t()} | {:error, any()}
  def get_session(session_id) do
    if is_nil(session_id) do
      {:error, "Missing required parameter: 'session_id'"}
    else
      api_path = "/v1/account/sessions/#{session_id}"
      payload = %{}

      api_header = %{"content-type" => "application/json"}

      Task.async(fn ->
        try do
          session = Client.call("get", api_path, api_header, payload)
          {:ok, session}
        rescue
          error -> {:error, error}
        end
      end)
      |> Task.await()
    end
  end

  @doc """
  Deletes a session by session ID.

  ## Parameters
  - `session_id`: The session ID (use "current" for the current session).

  ## Returns
  - `{:ok, %{}}` on success
  - `{:error, reason}` on failure
  """
  @spec delete_session(String.t() | nil) :: {:ok, map()} | {:error, any()}
  def delete_session(session_id) do
    if is_nil(session_id) do
      {:error, "Missing required parameter: 'session_id'"}
    else
      api_path = "/v1/account/sessions/#{session_id}"
      payload = %{}
      api_header = %{"content-type" => "application/json"}

      Task.async(fn ->
        try do
          session = Client.call("delete", api_path, api_header, payload)
          {:ok, session}
        rescue
          error -> {:error, error}
        end
      end)
      |> Task.await()
    end
  end

  @doc """
  Updates the status of the currently logged-in user.

  Blocks the user account permanently. The user record is not deleted, but the account is blocked from access.

  ## Returns
    - `{:ok, user}` on success.
    - `{:error, %Appwrite.Exception{}}` on failure.
  """
  @spec update_status() :: {:ok, map()} | {:error, Exception.t()}
  def update_status() do
    api_path = "/v1/account/status"
    payload = %{}
    api_header = %{"content-type" => "application/json"}

    Task.async(fn ->
      try do
        status = Client.call("patch", api_path, api_header, payload)
        {:ok, status}
      rescue
        error -> {:error, error}
      end
    end)
    |> Task.await()
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
  @spec create_push_target(String.t(), String.t(), String.t()) ::
          {:ok, map()} | {:error, any()}
  def create_push_target(target_id, identifier, provider_id) do
    if is_nil(target_id) or is_nil(identifier) or is_nil(provider_id) do
      {:error, "Missing required parameters: 'targetId' or 'identifier or 'provider_id' "}
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

      Task.async(fn ->
        try do
          target = Client.call("post", api_path, api_header, payload)
          {:ok, target}
        rescue
          error -> {:error, error}
        end
      end)
      |> Task.await()
    end
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
  @spec update_push_target(String.t(), String.t()) ::
          {:ok, map()} | {:error, any()}
  def update_push_target(target_id, identifier) do
    if is_nil(target_id) or is_nil(identifier) do
      {:error, "Missing required parameters: 'targetId' or 'identifier"}
    else
      api_path = "/v1/account/targets/#{target_id}/push"
      api_header = %{"content-type" => "application/json"}

      payload = %{"identifier" => identifier}

      Task.async(fn ->
        try do
          target = Client.call("put", api_path, api_header, payload)
          {:ok, target}
        rescue
          error -> {:error, error}
        end
      end)
      |> Task.await()
    end
  end

  @doc """
  Deletes a push target.

  ## Parameters
    - `target_id` (required): Target identifier.

  ## Returns
    - `{:ok, %{}}` on success.
    - `{:error, %Appwrite.Exception{}}` on failure.
  """
  @spec delete_push_target(String.t()) :: {:ok, map()} | {:error, Exception.t()}
  def delete_push_target(target_id) do
    if is_nil(target_id) do
      {:error, "Missing required parameters: 'targetId' "}
    else
      api_path = "/v1/account/targets/#{target_id}/push"
      api_header = %{"content-type" => "application/json"}

      payload = %{}

      Task.async(fn ->
        try do
          target = Client.call("delete", api_path, api_header, payload)
          {:ok, target}
        rescue
          error -> {:error, error}
        end
      end)
      |> Task.await()
    end
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
  @spec create_email_token(String.t(), String.t(), boolean() | nil) ::
          {:ok, map()} | {:error, Exception.t()}
  def create_email_token(user_id, email, phrase \\ nil) do
    if is_nil(user_id) or is_nil(email) do
      {:error, "Missing required parameters: : 'userId' or 'email'"}
    else
      api_path = "/v1/account/tokens/email"
      api_header = %{"content-type" => "application/json"}

      payload =
        %{"userId" => user_id, "email" => email, "phrase" => phrase}
        |> Enum.reject(fn {_k, v} -> is_nil(v) end)

      Task.async(fn ->
        try do
          token = Client.call("post", api_path, api_header, payload)
          {:ok, token}
        rescue
          error -> {:error, error}
        end
      end)
      |> Task.await()
    end
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
          String.t(),
          String.t(),
          String.t() | nil,
          boolean() | nil
        ) ::
          {:ok, map()} | {:error, Exception.t()}
  def create_magic_url_token(user_id, email, url \\ nil, phrase \\ nil) do
    if is_nil(user_id) or is_nil(email) do
      {:error, "Missing required parameters: : 'userId' or 'email'"}
    else
      api_path = "/v1/account/tokens/magic-url"
      api_header = %{"content-type" => "application/json"}

      payload =
        %{"userId" => user_id, "email" => email, "url" => url, "phrase" => phrase}
        |> Enum.reject(fn {_k, v} -> is_nil(v) end)

      Task.async(fn ->
        try do
          token = Client.call("post", api_path, api_header, payload)
          {:ok, token}
        rescue
          error -> {:error, error}
        end
      end)
      |> Task.await()
    end
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
  @spec create_phone_token(String.t(), String.t()) ::
          {:ok, map()} | {:error, Exception.t()}
  def create_phone_token(user_id, phone) do
    if is_nil(user_id) or is_nil(phone) do
      {:error, "Missing required parameters: : 'userId' or 'phone'"}
    else
      api_path = "/v1/account/tokens/phone"
      api_header = %{"content-type" => "application/json"}
      payload = %{"userId" => user_id, "phone" => phone}

      Task.async(fn ->
        try do
          token = Client.call("post", api_path, api_header, payload)
          {:ok, token}
        rescue
          error -> {:error, error}
        end
      end)
      |> Task.await()
    end
  end

  @doc """
  Create OAuth2 token.

  Allow the user to login to their account using the OAuth2 provider of their choice. Each OAuth2 provider should be enabled from the Appwrite console first. Use the `success` and `failure` arguments to provide redirect URLs back to your app when login is completed.

  If authentication succeeds, `userId` and `secret` of a token will be appended to the success URL as query parameters. These can be used to create a new session using the `create_session/3` function.

  A user is limited to 10 active sessions at a time by default. [Learn more about session limits](https://appwrite.io/docs/authentication-security#limits).

  ## Parameters
    - `provider`: OAuth2 provider (required).
    - `success`: Success redirect URL (optional).
    - `failure`: Failure redirect URL (optional).
    - `scopes`: OAuth2 scopes (optional).

  ## Returns
    - `{:ok, url}`: Redirect URL.
    - `{:error, Exception.t()}`: Error details.
  """
  @spec create_oauth2_token(OAuthProvider, String.t(), [String.t()]) :: String.t()
  def create_oauth2_token(provider, success \\ nil, failure \\ nil, scopes \\ nil)
      when is_binary(provider) and
             (is_nil(success) or is_binary(success)) and
             (is_nil(failure) or is_binary(failure)) and
             (is_nil(scopes) or is_list(scopes)) do
    if provider == "" do
      {:error, %AppwriteException{message: "Missing required parameter: 'provider'"}}
    else
      try do
        api_path = "/account/tokens/oauth2/#{provider}"
        url = URI.merge(Client.default_config()["endpoint"], api_path)

        params =
          %{
            "success" => success,
            "failure" => failure,
            "scopes" => scopes
          }
          |> Enum.reject(fn {_key, value} -> is_nil(value) end)

        query_string = URI.encode_query(Client.flatten(params))
        {to_string(url) <> "?" <> query_string}
      rescue
        exception ->
          {:error, %AppwriteException{message: exception}}
      end
    end
  end

  @doc """
  Create email verification.

  Use this endpoint to send a verification message to your user's email address to confirm ownership. Learn more about how to complete the verification process by verifying both the `userId` and `secret` parameters.

  ## Parameters
    - `url`: The redirect URL (required).

  ## Returns
    - `{:ok, map()}`: Verification token.
    - `{:error, Exception.t()}`: Error details.
  """
  @spec create_verification(String.t()) :: {:ok, Token.t()} | {:error, any()}
  def create_verification(url) when is_binary(url) do
    if is_nil(url) do
      {:error, "Missing required parameters: : 'url' "}
    else
      api_path = "/v1/account/verification"
      api_header = %{"content-type" => "application/json"}
      payload = %{"url" => url}

      Task.async(fn ->
        try do
          verification = Client.call("post", api_path, api_header, payload)
          {:ok, verification}
        rescue
          error -> {:error, error}
        end
      end)
      |> Task.await()
    end
  end

  @doc """
  Update email verification.

  Use this endpoint to complete the user email verification process.

  ## Parameters
    - `user_id`: The user's ID (required).
    - `secret`: The secret key (required).

  ## Returns
    - `{:ok, map()}`: Verification token.
    - `{:error, Exception.t()}`: Error details.
  """
  @spec update_verification(String.t(), String.t()) ::
          {:ok, Token.t()} | {:error, any()}
  def update_verification(user_id, secret)
      when is_binary(user_id) and is_binary(secret) do
    if is_nil(user_id) or is_nil(secret) do
      {:error, "Missing required parameters: : 'user_id' or 'secret'"}
    else
      api_path = "/v1/account/verification"
      api_header = %{"content-type" => "application/json"}
      payload = %{"userId" => user_id, "secret" => secret}

      Task.async(fn ->
        try do
          verification_token = Client.call("put", api_path, api_header, payload)
          {:ok, verification_token}
        rescue
          error -> {:error, error}
        end
      end)
      |> Task.await()
    end
  end

  @doc """
  Create phone verification.

  Use this endpoint to send a verification SMS to the currently logged-in user.

  ## Parameters

  ## Returns
    - `{:ok, Token.t()}`: Verification token.
    - `{:error, Exception.t()}`: Error details.
  """
  @spec create_phone_verification() :: {:ok, Token.t()} | {:error, any()}
  def create_phone_verification() do
    api_path = "/v1/account/verification/phone"
    api_header = %{"content-type" => "application/json"}
    payload = %{}

    Task.async(fn ->
      try do
        verification_token = Client.call("post", api_path, api_header, payload)
        {:ok, verification_token}
      rescue
        error -> {:error, error}
      end
    end)
    |> Task.await()
  end

  @doc """
  Update phone verification.

  Use this endpoint to complete the user phone verification process.

  ## Parameters
    - `user_id`: The user's ID (required).
    - `secret`: The secret key (required).

  ## Returns
    - `{:ok, map()}`: Verification token.
    - `{:error, Exception.t()}`: Error details.
  """
  @spec update_phone_verification(String.t(), String.t()) :: {:ok, Token.t()} | {:error, any()}
  def update_phone_verification(user_id, secret)
      when is_binary(user_id) and is_binary(secret) do
    if is_nil(user_id) or is_nil(secret) do
      {:error, "Missing required parameters: : 'user_id' or 'secret'"}
    else
      api_path = "/v1/account/verification/phone"
      api_header = %{"content-type" => "application/json"}
      payload = %{"userId" => user_id, "secret" => secret}

      Task.async(fn ->
        try do
          verification_token = Client.call("put", api_path, api_header, payload)
          {:ok, verification_token}
        rescue
          error -> {:error, error}
        end
      end)
      |> Task.await()
    end
  end

  # Helper function to validate parameters
  defp validate_params(params) do
    case Enum.find(params, fn {_, value} -> is_nil(value) end) do
      nil -> :ok
      {key, _} -> {:error, "Missing required parameter: #{key}"}
    end
  end



  # # Helper function to update query

  # @doc """
  # Updates the query parameters of a given URI.

  # This function takes a URI and a map of parameters, merging the new parameters
  # with any existing ones in the URI. If the URI already has a query string, the
  # new parameters will override any existing ones with the same keys.

  # ## Parameters

  # - `uri`: A `%URI{}` struct or a string representing the URI to be updated.
  # - `params`: A map containing the query parameters to add or update in the URI.

  # ## Returns

  # - An updated `%URI{}` struct with the modified query parameters.

  # ## Examples

  # Update a URI with new query parameters:

  # ```elixir
  # uri = URI.parse("https://api.example.com/resource?key1=value1")
  # params = %{"key2" => "value2", "key1" => "newvalue1"}

  # updated_uri = update_query(uri, params)
  # URI.to_string(updated_uri)
  # # Output: "https://api.example.com/resource?key1=newvalue1&key2=value2"

  # """

  # defp update_query(uri, params) do
  #   uri
  #   |> URI.parse()
  #   |> Map.update!(:query, fn query ->
  #     existing_params = URI.decode_query(query || "")
  #     updated_params = Map.merge(existing_params, params)
  #     URI.encode_query(updated_params)
  #   end)
  # end
end
