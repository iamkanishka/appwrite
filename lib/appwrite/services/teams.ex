defmodule Appwrite.Services.Teams do
  @moduledoc """
  The Teams service allows you to group users of your project and
  to enable them to share read and write access to your project resources, such as database documents or storage files.
  Each user who creates a team becomes the team owner and can delegate the ownership role by inviting a new team member.
  Only team owners can invite new users to their team.

  Status: In Testing
  """

  @doc """
  List teams.

  Fetches a list of all teams in which the current user is a member.
  Parameters can be used to filter the results.

  ## Parameters
    - `queries` (optional, `[String.t()]`): List of query strings.
    - `search` (optional, `String.t()`): Search term.

  ## Returns
    - `{:ok, %TeamList{}}` on success.
    - `{:error, %AppwriteException{}}` on failure.
  """

  alias Appwrite.Helpers.Client
  alias Appwrite.Exceptions.AppwriteException
  alias Appwrite.Types.{Membership, MembershipList, TeamList, Team, Preferences}

  @doc """
  List teams.

  Fetches a list of all teams in which the current user is a member.
  Parameters can be used to filter the results.

  ## Parameters
    - `queries` (optional, `[String.t()]`): List of query strings.
    - `search` (optional, `String.t()`): Search term.

  ## Returns
    - `{:ok, %TeamList{}}` on success.
    - `{:error, %AppwriteException{}}` on failure.
  """

  @spec list(Client.t(), [String.t()] | nil, String.t() | nil) ::
          {:ok, TeamList.t()} | {:error, AppwriteException.t()}
  def list(client, queries \\ nil, search \\ nil) do
    api_path = "/teams"
    payload = %{}

    payload =
      if queries, do: Map.put(payload, "queries", queries), else: payload

    payload =
      if search, do: Map.put(payload, "search", search), else: payload

    uri = URI.merge(client.config.endpoint, api_path)

    try do
      Client.call(client, :get, uri, payload, %{"content-type" => "application/json"})
    rescue
      e -> {:error, %AppwriteException{message: Exception.message(e)}}
    end
  end

  @doc """
  Create a new team.

  The user who creates the team is automatically assigned as the owner.

  ## Parameters
  - `team_id` (`String.t()`): Unique team ID.
  - `name` (`String.t()`): Name of the team.
  - `roles` (optional, `[String.t()]`): List of roles for the team.

  ## Returns
  - `{:ok, %Team{}}` on success.
  - `{:error, %AppwriteException{}}` on failure.
  """
  @spec create(Client.t(), String.t(), String.t(), [String.t()] | nil) ::
          {:ok, Team.t()} | {:error, AppwriteException.t()}
  def create(client, team_id, name, roles \\ nil) do
    if is_nil(team_id) or is_nil(name) do
      raise AppwriteException, "Missing required parameters: 'team_id' or 'name'"
    end

    api_path = "/teams"
    payload = %{"teamId" => team_id, "name" => name}

    payload =
      if roles, do: Map.put(payload, "roles", roles), else: payload

    uri = URI.merge(client.config.endpoint, api_path)

    try do
      Client.call(client, :post, uri, payload, %{"content-type" => "application/json"})
    rescue
      e -> {:error, %AppwriteException{message: Exception.message(e)}}
    end
  end

  @doc """
  Get team details by ID.

  ## Parameters
  - `team_id` (`String.t()`): Unique team ID.

  ## Returns
  - `{:ok, %Team{}}` on success.
  - `{:error, %AppwriteException{}}` on failure.
  """
  @spec get(Client.t(), String.t()) :: {:ok, Team.t()} | {:error, AppwriteException.t()}
  def get(client, team_id) do
    if is_nil(team_id) do
      raise AppwriteException, "Missing required parameter: 'team_id'"
    end

    api_path = "/teams/#{team_id}"
    uri = URI.merge(client.config.endpoint, api_path)

    try do
      Client.call(client, :get, uri, %{}, %{"content-type" => "application/json"})
    rescue
      e -> {:error, %AppwriteException{message: Exception.message(e)}}
    end
  end

  @doc """
  Update team name by ID.

  ## Parameters
  - `team_id` (`String.t()`): Unique team ID.
  - `name` (`String.t()`): New name for the team.

  ## Returns
  - `{:ok, %Team{}}` on success.
  - `{:error, %AppwriteException{}}` on failure.
  """
  @spec update_name(Client.t(), String.t(), String.t()) ::
          {:ok, Team.t()} | {:error, AppwriteException.t()}
  def update_name(client, team_id, name) do
    if is_nil(team_id) or is_nil(name) do
      raise AppwriteException, "Missing required parameters: 'team_id' or 'name'"
    end

    api_path = "/teams/#{team_id}"
    payload = %{"name" => name}
    uri = URI.merge(client.config.endpoint, api_path)

    try do
      Client.call(client, :put, uri, payload, %{"content-type" => "application/json"})
    rescue
      e -> {:error, %AppwriteException{message: Exception.message(e)}}
    end
  end

  @doc """
  Delete a team by its ID.

  ## Parameters
  - `team_id` (`String.t()`): Unique team ID.

  ## Returns
  - `{:ok, %{}}` on success.
  - `{:error, %AppwriteException{}}` on failure.
  """
  @spec delete(Client.t(), String.t()) :: {:ok, map()} | {:error, AppwriteException.t()}
  def delete(client, team_id) do
    if is_nil(team_id) do
      raise AppwriteException, "Missing required parameter: 'team_id'"
    end

    api_path = "/teams/#{team_id}"
    uri = URI.merge(client.config.endpoint, api_path)

    try do
      Client.call(client, :delete, uri, %{}, %{"content-type" => "application/json"})
    rescue
      e -> {:error, %AppwriteException{message: Exception.message(e)}}
    end
  end

  @doc """
  List team memberships.

  ## Parameters:
    - `team_id` (string): Team ID.
    - `queries` (list of strings, optional): Query filters.
    - `search` (string, optional): Search keyword.

  ## Returns:
    - `MembershipList`: A list of memberships.
  """
  @spec list_memberships(Client.t(), String.t(), list(String.t()) | nil, String.t() | nil) ::
          {:ok, MembershipList.t()} | {:error, any()}
  def list_memberships(client, team_id, queries \\ nil, search \\ nil) do
    with :ok <- validate_param(team_id, "team_id"),
         api_path <- "/teams/#{team_id}/memberships",
         uri <- URI.merge(client.config.endpoint, api_path),
         payload <- %{"queries" => queries, "search" => search} |> Enum.reject(&is_nil/1),
         headers <- %{"content-type" => "application/json"} do
      Client.call(client, :get, uri, headers, payload)
    else
      {:error, reason} -> {:error, %AppwriteException{message: reason}}
    end
  end

  @doc """
  Create a new membership in a team.

  ## Parameters:
  - `team_id` (string): Team ID.
  - `roles` (list of strings): Roles assigned to the member.
  - `email` (string, optional): Email address.
  - `user_id` (string, optional): User ID.
  - `phone` (string, optional): Phone number.
  - `url` (string, optional): Redirect URL.
  - `name` (string, optional): Member's name.

  ## Returns:
  - `Membership`: Membership details.
  """
  @spec create_membership(
          Client.t(),
          String.t(),
          list(String.t()),
          String.t() | nil,
          String.t() | nil,
          String.t() | nil,
          String.t() | nil,
          String.t() | nil
        ) :: {:ok, Membership.t()} | {:error, any()}
  def create_membership(
        client,
        team_id,
        roles,
        email \\ nil,
        user_id \\ nil,
        phone \\ nil,
        url \\ nil,
        name \\ nil
      ) do
    with :ok <- validate_param(team_id, "team_id"),
         :ok <- validate_param(roles, "roles"),
         api_path <- "/teams/#{team_id}/memberships",
         uri <- URI.merge(client.config.endpoint, api_path),
         payload <-
           %{
             "roles" => roles,
             "email" => email,
             "userId" => user_id,
             "phone" => phone,
             "url" => url,
             "name" => name
           }
           |> Enum.reject(&is_nil/1),
         headers <- %{"content-type" => "application/json"} do
      Client.call(client, :post, uri, headers, payload)
    else
      {:error, reason} -> {:error, %AppwriteException{message: reason}}
    end
  end

  @doc """
  Get a team membership by ID.

  ## Parameters:
  - `team_id` (string): Team ID.
  - `membership_id` (string): Membership ID.

  ## Returns:
  - `Membership`: Membership details.
  """
  @spec get_membership(Client.t(), String.t(), String.t()) ::
          {:ok, Membership.t()} | {:error, any()}
  def get_membership(client, team_id, membership_id) do
    with :ok <- validate_param(team_id, "team_id"),
         :ok <- validate_param(membership_id, "membership_id"),
         api_path <- "/teams/#{team_id}/memberships/#{membership_id}",
         uri <- URI.merge(client.config.endpoint, api_path),
         headers <- %{"content-type" => "application/json"} do
      Client.call(client, :get, uri, headers, %{})
    else
      {:error, reason} -> {:error, %AppwriteException{message: reason}}
    end
  end

  @doc """
  Update a team membership's roles.

  ## Parameters:
  - `team_id` (string): Team ID.
  - `membership_id` (string): Membership ID.
  - `roles` (list of strings): Updated roles.

  ## Returns:
  - `Membership`: Updated membership details.
  """
  @spec update_membership(Client.t(), String.t(), String.t(), list(String.t())) ::
          {:ok, Membership.t()} | {:error, any()}
  def update_membership(client, team_id, membership_id, roles) do
    with :ok <- validate_param(team_id, "team_id"),
         :ok <- validate_param(membership_id, "membership_id"),
         :ok <- validate_param(roles, "roles"),
         api_path <- "/teams/#{team_id}/memberships/#{membership_id}",
         uri <- URI.merge(client.config.endpoint, api_path),
         payload <- %{"roles" => roles},
         headers <- %{"content-type" => "application/json"} do
      Client.call(client, :patch, uri, headers, payload)
    else
      {:error, reason} -> {:error, %AppwriteException{message: reason}}
    end
  end

  @doc """
  Delete a team membership.

  ## Parameters:
  - `team_id` (string): Team ID.
  - `membership_id` (string): Membership ID.

  ## Returns:
  - `{}`: Empty response.
  """
  @spec delete_membership(Client.t(), String.t(), String.t()) ::
          {:ok, map()} | {:error, any()}
  def delete_membership(client, team_id, membership_id) do
    with :ok <- validate_param(team_id, "team_id"),
         :ok <- validate_param(membership_id, "membership_id"),
         api_path <- "/teams/#{team_id}/memberships/#{membership_id}",
         uri <- URI.merge(client.config.endpoint, api_path),
         headers <- %{"content-type" => "application/json"} do
      Client.call(client, :delete, uri, headers, %{})
    else
      {:error, reason} -> {:error, %AppwriteException{message: reason}}
    end
  end

  @doc """
  Update team membership status.

  Allows a user to accept an invitation to join a team after being redirected back to the app.

  ## Parameters:
    - `client` (Client): The Appwrite client instance.
    - `team_id` (String): The team ID.
    - `membership_id` (String): The membership ID.
    - `user_id` (String): The user ID.
    - `secret` (String): The secret received via the invitation email.

  ## Returns:
    - `Membership`: Updated membership details.
  """
  @spec update_membership_status(Client.t(), String.t(), String.t(), String.t(), String.t()) ::
          {:ok, Membership.t()} | {:error, any()}
  def update_membership_status(client, team_id, membership_id, user_id, secret) do
    with :ok <- validate_param(team_id, "team_id"),
         :ok <- validate_param(membership_id, "membership_id"),
         :ok <- validate_param(user_id, "user_id"),
         :ok <- validate_param(secret, "secret"),
         api_path <- "/teams/#{team_id}/memberships/#{membership_id}/status",
         uri <- URI.merge(client.config.endpoint, api_path),
         payload <- %{"userId" => user_id, "secret" => secret},
         headers <- %{"content-type" => "application/json"} do
      Client.call(client, :patch, uri, headers, payload)
    else
      {:error, reason} -> {:error, %AppwriteException{message: reason}}
    end
  end

  @doc """
  Get team preferences.

  Retrieves the shared preferences of a team by its unique ID.

  ## Parameters:
  - `client` (Client): The Appwrite client instance.
  - `team_id` (String): The team ID.

  ## Returns:
  - `Preferences`: Team preferences.
  """
  @spec get_prefs(Client.t(), String.t()) :: {:ok, Preferences.t()} | {:error, any()}
  def get_prefs(client, team_id) do
    with :ok <- validate_param(team_id, "team_id"),
         api_path <- "/teams/#{team_id}/prefs",
         uri <- URI.merge(client.config.endpoint, api_path),
         headers <- %{"content-type" => "application/json"} do
      Client.call(client, :get, uri, headers, %{})
    else
      {:error, reason} -> {:error, %AppwriteException{message: reason}}
    end
  end

  @doc """
  Update team preferences.

  Updates the team's preferences. The new preferences replace any existing ones.

  ## Parameters:
  - `client` (Client): The Appwrite client instance.
  - `team_id` (String): The team ID.
  - `prefs` (map): The preferences to update.

  ## Returns:
  - `Preferences`: Updated team preferences.
  """
  @spec update_prefs(Client.t(), String.t(), map()) :: {:ok, Preferences.t()} | {:error, any()}
  def update_prefs(client, team_id, prefs) do
    with :ok <- validate_param(team_id, "team_id"),
         :ok <- validate_param(prefs, "prefs"),
         api_path <- "/teams/#{team_id}/prefs",
         uri <- URI.merge(client.config.endpoint, api_path),
         payload <- %{"prefs" => prefs},
         headers <- %{"content-type" => "application/json"} do
      Client.call(client, :put, uri, headers, payload)
    else
      {:error, reason} -> {:error, %AppwriteException{message: reason}}
    end
  end

  # Helper to validate required parameters
  defp validate_param(nil, param), do: {:error, "#{param} is required"}
  defp validate_param("", param), do: {:error, "#{param} cannot be empty"}
  defp validate_param(_, _), do: :o
end
