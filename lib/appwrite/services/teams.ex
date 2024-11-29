defmodule Appwrite.Services.Teams do
  @moduledoc """
  The Teams service allows you to group users of your project and
  to enable them to share read and write access to your project resources, such as database documents or storage files.
  Each user who creates a team becomes the team owner and can delegate the ownership role by inviting a new team member.
  Only team owners can invite new users to their team.
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

  alias Appwrite.Utils.Client
  alias Appwrite.Exceptions.AppwriteException
  alias Appwrite.Types.{Membership, MembershipList, TeamList, Team, Preference}

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

  @spec list([String.t()] | nil, String.t() | nil) ::
          {:ok, TeamList.t()} | {:error, AppwriteException.t()}
  def list(queries \\ nil, search \\ nil) do
    api_path = "/v1/teams"

    payload =
      %{
        "search" => search,
        "queries" => queries
      }
      |> Enum.reject(fn {_key, value} -> is_nil(value) end)

    api_header = %{"content-type" => "application/json"}

    Task.async(fn ->
      try do
        team_list = Client.call("get", api_path, api_header, payload)
        {:ok, team_list}
      rescue
        error -> {:error, error}
      end
    end)
    |> Task.await()
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
  @spec create(String.t(), String.t(), [String.t()] | nil) ::
          {:ok, Team.t()} | {:error, AppwriteException.t()}
  def create(team_id, name, roles \\ nil) do
    if is_nil(team_id) or is_nil(name) do
      raise AppwriteException, "Missing required parameters: 'team_id' or 'name'"
    end

    api_path = "/v1/teams"

    payload =
      %{
        "teamId" => team_id,
        "name" => name,
        "roles" => roles
      }
      |> Enum.reject(fn {_key, value} -> is_nil(value) end)

    api_header = %{"content-type" => "application/json"}

    Task.async(fn ->
      try do
        team = Client.call("post", api_path, api_header, payload)
        {:ok, team}
      rescue
        error -> {:error, error}
      end
    end)
    |> Task.await()
  end

  @doc """
  Get team details by ID.

  ## Parameters
  - `team_id` (`String.t()`): Unique team ID.

  ## Returns
  - `{:ok, %Team{}}` on success.
  - `{:error, %AppwriteException{}}` on failure.
  """
  @spec get(String.t()) :: {:ok, Team.t()} | {:error, AppwriteException.t()}
  def get(team_id) do
    if is_nil(team_id) do
      raise AppwriteException, "Missing required parameter: 'team_id'"
    end

    api_path = "/v1/teams/#{team_id}"

    payload = %{}

    api_header = %{"content-type" => "application/json"}

    Task.async(fn ->
      try do
        team = Client.call("get", api_path, api_header, payload)
        {:ok, team}
      rescue
        error -> {:error, error}
      end
    end)
    |> Task.await()
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
  @spec update_name(String.t(), String.t()) ::
          {:ok, Team.t()} | {:error, AppwriteException.t()}
  def update_name(team_id, name) do
    if is_nil(team_id) or is_nil(name) do
      raise AppwriteException, "Missing required parameters: 'team_id' or 'name'"
    end

    api_path = "/v1/teams/#{team_id}"

    payload = %{"name" => name}

    api_header = %{"content-type" => "application/json"}

    Task.async(fn ->
      try do
        team = Client.call("put", api_path, api_header, payload)
        {:ok, team}
      rescue
        error -> {:error, error}
      end
    end)
    |> Task.await()
  end

  @doc """
  Delete a team by its ID.

  ## Parameters
  - `team_id` (`String.t()`): Unique team ID.

  ## Returns
  - `{:ok, %{}}` on success.
  - `{:error, %AppwriteException{}}` on failure.
  """
  @spec delete(String.t()) :: {:ok, map()} | {:error, AppwriteException.t()}
  def delete(team_id) do
    if is_nil(team_id) do
      raise AppwriteException, "Missing required parameter: 'team_id'"
    end

    api_path = "/v1/teams/#{team_id}"

    payload = %{}

    api_header = %{"content-type" => "application/json"}

    Task.async(fn ->
      try do
        team = Client.call("delete", api_path, api_header, payload)
        {:ok, :deleted}
      rescue
        error -> {:error, error}
      end
    end)
    |> Task.await()
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
  @spec list_memberships(String.t(), list(String.t()) | nil, String.t() | nil) ::
          {:ok, MembershipList.t()} | {:error, any()}
  def list_memberships(team_id, queries \\ nil, search \\ nil) do
    if is_nil(team_id) do
      raise AppwriteException, "Missing required parameter: 'team_id'"
    end

    api_path = "/v1/teams/#{team_id}/memberships"

    payload =
      %{
        "queries" => queries,
        "search" => search
      }
      |> Enum.reject(fn {_key, value} -> is_nil(value) end)

    api_header = %{"content-type" => "application/json"}

    Task.async(fn ->
      try do
        memberships = Client.call("get", api_path, api_header, payload)
        {:ok, memberships}
      rescue
        error -> {:error, error}
      end
    end)
    |> Task.await()
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
          String.t(),
          list(String.t()),
          String.t() | nil,
          String.t() | nil,
          String.t() | nil,
          String.t() | nil,
          String.t() | nil
        ) :: {:ok, Membership.t()} | {:error, any()}
  def create_membership(
        team_id,
        roles,
        email \\ nil,
        user_id \\ nil,
        phone \\ nil,
        url \\ nil,
        name \\ nil
      ) do
    if is_nil(team_id) or is_nil(roles) do
      raise AppwriteException, "Missing required parameter: 'team_id' or 'roles'"
    end

    api_path = "/v1/teams/#{team_id}/memberships"

    payload =
      %{
        "roles" => roles,
        "email" => email,
        "userId" => user_id,
        "phone" => phone,
        "url" => url,
        "name" => name
      }
      |> Enum.reject(&is_nil/1)

    api_header = %{"content-type" => "application/json"}

    Task.async(fn ->
      try do
        membership = Client.call("post", api_path, api_header, payload)
        {:ok, membership}
      rescue
        error -> {:error, error}
      end
    end)
    |> Task.await()
  end

  @doc """
  Get a team membership by ID.

  ## Parameters:
  - `team_id` (string): Team ID.
  - `membership_id` (string): Membership ID.

  ## Returns:
  - `Membership`: Membership details.
  """
  @spec get_membership(String.t(), String.t()) ::
          {:ok, Membership.t()} | {:error, any()}
  def get_membership(team_id, membership_id) do
    if is_nil(team_id) or is_nil(membership_id) do
      raise AppwriteException, "Missing required parameter: 'team_id' or 'membership_id'"
    end

    api_path = "/v1/teams/#{team_id}/memberships/#{membership_id}"

    payload = %{}

    api_header = %{"content-type" => "application/json"}

    Task.async(fn ->
      try do
        membership = Client.call("get", api_path, api_header, payload)
        {:ok, membership}
      rescue
        error -> {:error, error}
      end
    end)
    |> Task.await()
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
  @spec update_membership(String.t(), String.t(), list(String.t())) ::
          {:ok, Membership.t()} | {:error, any()}
  def update_membership(team_id, membership_id, roles) do
    if is_nil(team_id) or is_nil(membership_id) or is_nil(roles) do
      raise AppwriteException,
            "Missing required parameter: 'team_id' or 'membership_id' or 'roles'"
    end

    api_path = "/v1/teams/#{team_id}/memberships/#{membership_id}"

    payload = %{"roles" => roles}

    api_header = %{"content-type" => "application/json"}

    Task.async(fn ->
      try do
        membership = Client.call("patch", api_path, api_header, payload)
        {:ok, membership}
      rescue
        error -> {:error, error}
      end
    end)
    |> Task.await()
  end

  @doc """
  Delete a team membership.

  ## Parameters:
  - `team_id` (string): Team ID.
  - `membership_id` (string): Membership ID.

  ## Returns:
  - `{}`: Empty response.
  """
  @spec delete_membership(String.t(), String.t()) ::
          {:ok, map()} | {:error, any()}
  def delete_membership(team_id, membership_id) do
    if is_nil(team_id) or is_nil(membership_id) do
      raise AppwriteException,
            "Missing required parameter: 'team_id' or 'membership_id'"
    end

    api_path = "/v1/teams/#{team_id}/memberships/#{membership_id}"

    payload = %{}

    api_header = %{"content-type" => "application/json"}

    Task.async(fn ->
      try do
        Client.call("delete", api_path, api_header, payload)
        {:ok, :deleted}
      rescue
        error -> {:error, error}
      end
    end)
    |> Task.await()
  end

  @doc """
  Update team membership status.

  Allows a user to accept an invitation to join a team after being redirected back to the app.

  ## Parameters:
    - `team_id` (String): The team ID.
    - `membership_id` (String): The membership ID.
    - `user_id` (String): The user ID.
    - `secret` (String): The secret received via the invitation email.

  ## Returns:
    - `Membership`: Updated membership details.
  """
  @spec update_membership_status(String.t(), String.t(), String.t(), String.t()) ::
          {:ok, Membership.t()} | {:error, any()}
  def update_membership_status(team_id, membership_id, user_id, secret) do
    if is_nil(team_id) or is_nil(membership_id) or is_nil(user_id) or is_nil(secret) do
      raise AppwriteException,
            "Missing required parameter: 'team_id' or 'membership_id' or 'user_id' or 'secret'"
    end

    api_path = "/v1/teams/#{team_id}/memberships/#{membership_id}/status"

    payload = %{"userId" => user_id, "secret" => secret}

    api_header = %{"content-type" => "application/json"}

    Task.async(fn ->
      try do
        membership = Client.call("post", api_path, api_header, payload)
        {:ok, membership}
      rescue
        error -> {:error, error}
      end
    end)
    |> Task.await()
  end

  @doc """
  Get team preferences.

  Retrieves the shared preferences of a team by its unique ID.

  ## Parameters:
  - `team_id` (String): The team ID.

  ## Returns:
  - `Preferences`: Team preferences.
  """
  @spec get_prefs(String.t()) :: {:ok, Preference.t()} | {:error, any()}
  def get_prefs(team_id) do
    if is_nil(team_id) do
      raise AppwriteException, "Missing required parameter: 'team_id'"
    end

    api_path = "/v1/teams/#{team_id}/prefs"

    payload = %{}

    api_header = %{"content-type" => "application/json"}

    Task.async(fn ->
      try do
        preferences = Client.call("get", api_path, api_header, payload)
        {:ok, preferences}
      rescue
        error -> {:error, error}
      end
    end)
    |> Task.await()
  end

  @doc """
  Update team preferences.

  Updates the team's preferences. The new preferences replace any existing ones.

  ## Parameters:
  - `team_id` (String): The team ID.
  - `prefs` (map): The preferences to update.

  ## Returns:
  - `Preferences`: Updated team preferences.
  """
  @spec update_prefs(String.t(), map()) :: {:ok, Preference.t()} | {:error, any()}
  def update_prefs(team_id, prefs) do
    if is_nil(team_id) or is_nil(prefs) do
      raise AppwriteException, "Missing required parameter: 'team_id' or 'prefs'"
    end

    api_path = "/v1/teams/#{team_id}/prefs"

    payload = %{"prefs" => prefs}

    api_header = %{"content-type" => "application/json"}

    Task.async(fn ->
      try do
        preferences = Client.call("put", api_path, api_header, payload)
        {:ok, preferences}
      rescue
        error -> {:error, error}
      end
    end)
    |> Task.await()
  end

  # Helper to validate required parameters
  defp validate_param(nil, param), do: {:error, "#{param} is required"}
  defp validate_param("", param), do: {:error, "#{param} cannot be empty"}
  defp validate_param(_, _), do: :o
end
