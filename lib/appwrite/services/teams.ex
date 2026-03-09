defmodule Appwrite.Services.Teams do
  @moduledoc """
  The Teams service allows you to group users of your project and enable them to share
  read and write access to your project resources.

  Each user who creates a team becomes the team owner and can delegate the ownership role
  by assigning it to another team member. Only the team owner can invite new members,
  add new owners, and delete or update the team.

  A team member of any role can invite new members, but only the owner can delete the team.
  Invitations can be sent by email or via team invite URLs.
  """

  alias Appwrite.Exceptions.AppwriteException
  alias Appwrite.Utils.Client
  alias Appwrite.Types.{Team, TeamList, Membership, MembershipList, Preference}

  @doc """
  List all teams in which the current user is a member.

  ## Parameters
  - `queries` (`[String.t()] | nil`): Optional query strings to filter results.
  - `search` (`String.t() | nil`): Optional search term to filter teams by name.

  ## Returns
  - `{:ok, TeamList.t()}` on success.
  - `{:error, AppwriteException.t()}` on failure.
  """
  @spec list([String.t()] | nil, String.t() | nil) ::
          {:ok, TeamList.t()} | {:error, AppwriteException.t()}
  def list(queries \\ nil, search \\ nil) do
    params =
      %{}
      |> maybe_put("queries", queries)
      |> maybe_put("search", search)

    headers = %{"content-type" => "application/json"}

    Client.call("GET", "/v1/teams", headers, params)
    |> handle_response()
  end

  @doc """
  Create a new team.

  The user who creates the team is automatically assigned the owner role.
  Only owners can invite new members, add owners, and delete or update the team.

  ## Parameters
  - `team_id` (`String.t()`): Team ID. Use `ID.unique()` or provide a custom ID.
    Valid chars: a-z, A-Z, 0-9, `.`, `-`, `_`. Max length: 36 chars.
  - `name` (`String.t()`): Team name. Max length: 128 chars.
  - `roles` (`[String.t()] | nil`): Initial roles for the creator. Defaults to `["owner"]`.

  ## Returns
  - `{:ok, Team.t()}` on success.
  - `{:error, AppwriteException.t()}` on failure.
  """
  @spec create(String.t(), String.t(), [String.t()] | nil) ::
          {:ok, Team.t()} | {:error, AppwriteException.t()}
  def create(team_id, name, roles \\ nil) do
    cond do
      is_nil(team_id) ->
        {:error, %AppwriteException{message: "team_id is required"}}

      is_nil(name) ->
        {:error, %AppwriteException{message: "name is required"}}

      true ->
        params =
          %{"teamId" => team_id, "name" => name}
          |> maybe_put("roles", roles)

        headers = %{"content-type" => "application/json"}

        Client.call("POST", "/v1/teams", headers, params)
        |> handle_response()
    end
  end

  @doc """
  Get a team by its ID.

  All team members have read access to this endpoint.

  ## Parameters
  - `team_id` (`String.t()`): Team ID.

  ## Returns
  - `{:ok, Team.t()}` on success.
  - `{:error, AppwriteException.t()}` on failure.
  """
  @spec get(String.t()) :: {:ok, Team.t()} | {:error, AppwriteException.t()}
  def get(team_id) do
    if is_nil(team_id) do
      {:error, %AppwriteException{message: "team_id is required"}}
    else
      headers = %{"content-type" => "application/json"}

      Client.call("GET", "/v1/teams/#{team_id}", headers, %{})
      |> handle_response()
    end
  end

  @doc """
  Update a team's name.

  Only members with the owner role can update the team.

  ## Parameters
  - `team_id` (`String.t()`): Team ID.
  - `name` (`String.t()`): New team name. Max length: 128 chars.

  ## Returns
  - `{:ok, Team.t()}` on success.
  - `{:error, AppwriteException.t()}` on failure.
  """
  @spec update(String.t(), String.t()) :: {:ok, Team.t()} | {:error, AppwriteException.t()}
  def update(team_id, name) do
    cond do
      is_nil(team_id) ->
        {:error, %AppwriteException{message: "team_id is required"}}

      is_nil(name) ->
        {:error, %AppwriteException{message: "name is required"}}

      true ->
        headers = %{"content-type" => "application/json"}
        params = %{"name" => name}

        Client.call("PUT", "/v1/teams/#{team_id}", headers, params)
        |> handle_response()
    end
  end

  @doc """
  Delete a team.

  Only team members with the owner role can delete the team.

  ## Parameters
  - `team_id` (`String.t()`): Team ID.

  ## Returns
  - `{:ok, map()}` on success.
  - `{:error, AppwriteException.t()}` on failure.
  """
  @spec delete(String.t()) :: {:ok, map()} | {:error, AppwriteException.t()}
  def delete(team_id) do
    if is_nil(team_id) do
      {:error, %AppwriteException{message: "team_id is required"}}
    else
      headers = %{"content-type" => "application/json"}

      Client.call("DELETE", "/v1/teams/#{team_id}", headers, %{})
      |> handle_response()
    end
  end

  @doc """
  List a team's members.

  All team members have read access to this endpoint.

  ## Parameters
  - `team_id` (`String.t()`): Team ID.
  - `queries` (`[String.t()] | nil`): Optional query strings to filter results.
  - `search` (`String.t() | nil`): Optional search term to filter memberships.

  ## Returns
  - `{:ok, MembershipList.t()}` on success.
  - `{:error, AppwriteException.t()}` on failure.
  """
  @spec list_memberships(String.t(), [String.t()] | nil, String.t() | nil) ::
          {:ok, MembershipList.t()} | {:error, AppwriteException.t()}
  def list_memberships(team_id, queries \\ nil, search \\ nil) do
    if is_nil(team_id) do
      {:error, %AppwriteException{message: "team_id is required"}}
    else
      params =
        %{}
        |> maybe_put("queries", queries)
        |> maybe_put("search", search)

      headers = %{"content-type" => "application/json"}

      Client.call("GET", "/v1/teams/#{team_id}/memberships", headers, params)
      |> handle_response()
    end
  end

  @doc """
  Invite a new member to join a team.

  Provide an ID for existing users, or invite unregistered users via email or phone.
  From a client SDK, Appwrite will send an email or SMS with a link to join the team.

  ## Parameters
  - `team_id` (`String.t()`): Team ID.
  - `roles` (`[String.t()]`): Roles to assign to the new member.
  - `opts` (`keyword()`): Optional fields:
    - `:email` (`String.t()`) — email of the new member.
    - `:user_id` (`String.t()`) — ID of an existing user to add.
    - `:phone` (`String.t()`) — phone number of the new member.
    - `:url` (`String.t()`) — redirect URL for the invitation email.
    - `:name` (`String.t()`) — name of the new member.

  ## Returns
  - `{:ok, Membership.t()}` on success.
  - `{:error, AppwriteException.t()}` on failure.
  """
  @spec create_membership(String.t(), [String.t()], keyword()) ::
          {:ok, Membership.t()} | {:error, AppwriteException.t()}
  def create_membership(team_id, roles, opts \\ []) do
    cond do
      is_nil(team_id) ->
        {:error, %AppwriteException{message: "team_id is required"}}

      is_nil(roles) or roles == [] ->
        {:error, %AppwriteException{message: "roles is required"}}

      true ->
        params =
          %{"roles" => roles}
          |> maybe_put("email", Keyword.get(opts, :email))
          |> maybe_put("userId", Keyword.get(opts, :user_id))
          |> maybe_put("phone", Keyword.get(opts, :phone))
          |> maybe_put("url", Keyword.get(opts, :url))
          |> maybe_put("name", Keyword.get(opts, :name))

        headers = %{"content-type" => "application/json"}

        Client.call("POST", "/v1/teams/#{team_id}/memberships", headers, params)
        |> handle_response()
    end
  end

  @doc """
  Get a team member by their membership ID.

  All team members have read access to this endpoint.

  ## Parameters
  - `team_id` (`String.t()`): Team ID.
  - `membership_id` (`String.t()`): Membership ID.

  ## Returns
  - `{:ok, Membership.t()}` on success.
  - `{:error, AppwriteException.t()}` on failure.
  """
  @spec get_membership(String.t(), String.t()) ::
          {:ok, Membership.t()} | {:error, AppwriteException.t()}
  def get_membership(team_id, membership_id) do
    cond do
      is_nil(team_id) ->
        {:error, %AppwriteException{message: "team_id is required"}}

      is_nil(membership_id) ->
        {:error, %AppwriteException{message: "membership_id is required"}}

      true ->
        headers = %{"content-type" => "application/json"}

        Client.call("GET", "/v1/teams/#{team_id}/memberships/#{membership_id}", headers, %{})
        |> handle_response()
    end
  end

  @doc """
  Modify the roles of a team member.

  Only team members with the owner role can access this endpoint.

  ## Parameters
  - `team_id` (`String.t()`): Team ID.
  - `membership_id` (`String.t()`): Membership ID.
  - `roles` (`[String.t()]`): Updated array of roles.

  ## Returns
  - `{:ok, Membership.t()}` on success.
  - `{:error, AppwriteException.t()}` on failure.
  """
  @spec update_membership(String.t(), String.t(), [String.t()]) ::
          {:ok, Membership.t()} | {:error, AppwriteException.t()}
  def update_membership(team_id, membership_id, roles) do
    cond do
      is_nil(team_id) ->
        {:error, %AppwriteException{message: "team_id is required"}}

      is_nil(membership_id) ->
        {:error, %AppwriteException{message: "membership_id is required"}}

      is_nil(roles) ->
        {:error, %AppwriteException{message: "roles is required"}}

      true ->
        headers = %{"content-type" => "application/json"}
        params = %{"roles" => roles}

        Client.call("PATCH", "/v1/teams/#{team_id}/memberships/#{membership_id}", headers, params)
        |> handle_response()
    end
  end

  @doc """
  Delete a team membership.

  Allows a user to leave a team, or a team owner to remove any member.
  Also works for unaccepted invitations.

  ## Parameters
  - `team_id` (`String.t()`): Team ID.
  - `membership_id` (`String.t()`): Membership ID.

  ## Returns
  - `{:ok, map()}` on success.
  - `{:error, AppwriteException.t()}` on failure.
  """
  @spec delete_membership(String.t(), String.t()) ::
          {:ok, map()} | {:error, AppwriteException.t()}
  def delete_membership(team_id, membership_id) do
    cond do
      is_nil(team_id) ->
        {:error, %AppwriteException{message: "team_id is required"}}

      is_nil(membership_id) ->
        {:error, %AppwriteException{message: "membership_id is required"}}

      true ->
        headers = %{"content-type" => "application/json"}

        Client.call(
          "DELETE",
          "/v1/teams/#{team_id}/memberships/#{membership_id}",
          headers,
          %{}
        )
        |> handle_response()
    end
  end

  @doc """
  Accept a team membership invitation.

  Allows a user to confirm their team membership after being redirected back
  to your app from the invitation email. On success, a session is created automatically.

  ## Parameters
  - `team_id` (`String.t()`): Team ID.
  - `membership_id` (`String.t()`): Membership ID.
  - `user_id` (`String.t()`): User ID.
  - `secret` (`String.t()`): Secret key from the invitation link.

  ## Returns
  - `{:ok, Membership.t()}` on success.
  - `{:error, AppwriteException.t()}` on failure.
  """
  @spec update_membership_status(String.t(), String.t(), String.t(), String.t()) ::
          {:ok, Membership.t()} | {:error, AppwriteException.t()}
  def update_membership_status(team_id, membership_id, user_id, secret) do
    cond do
      is_nil(team_id) ->
        {:error, %AppwriteException{message: "team_id is required"}}

      is_nil(membership_id) ->
        {:error, %AppwriteException{message: "membership_id is required"}}

      is_nil(user_id) ->
        {:error, %AppwriteException{message: "user_id is required"}}

      is_nil(secret) ->
        {:error, %AppwriteException{message: "secret is required"}}

      true ->
        headers = %{"content-type" => "application/json"}
        params = %{"userId" => user_id, "secret" => secret}

        Client.call(
          "PATCH",
          "/v1/teams/#{team_id}/memberships/#{membership_id}/status",
          headers,
          params
        )
        |> handle_response()
    end
  end

  @doc """
  Get a team's shared preferences.

  Returns the team's preferences as a plain string-keyed map.
  If a preference does not need to be shared by all members, store it in user preferences instead.

  ## Parameters
  - `team_id` (`String.t()`): Team ID.

  ## Returns
  - `{:ok, Preference.t()}` on success.
  - `{:error, AppwriteException.t()}` on failure.
  """
  @spec get_prefs(String.t()) :: {:ok, Preference.t()} | {:error, AppwriteException.t()}
  def get_prefs(team_id) do
    if is_nil(team_id) do
      {:error, %AppwriteException{message: "team_id is required"}}
    else
      headers = %{"content-type" => "application/json"}

      # NOTE: Preference is a plain map type alias, not a struct.
      # handle_response returns the raw body which is already the prefs map.
      Client.call("GET", "/v1/teams/#{team_id}/prefs", headers, %{})
      |> handle_response()
    end
  end

  @doc """
  Update a team's shared preferences.

  The object you pass replaces any previous preferences.
  Maximum allowed prefs size is 64 kB.

  ## Parameters
  - `team_id` (`String.t()`): Team ID.
  - `prefs` (`Preference.t()`): New preferences as a string-keyed map.

  ## Returns
  - `{:ok, Preference.t()}` on success.
  - `{:error, AppwriteException.t()}` on failure.
  """
  @spec update_prefs(String.t(), Preference.t()) ::
          {:ok, Preference.t()} | {:error, AppwriteException.t()}
  def update_prefs(team_id, prefs) do
    cond do
      is_nil(team_id) ->
        {:error, %AppwriteException{message: "team_id is required"}}

      is_nil(prefs) ->
        {:error, %AppwriteException{message: "prefs is required"}}

      true ->
        headers = %{"content-type" => "application/json"}
        params = %{"prefs" => prefs}

        Client.call("PUT", "/v1/teams/#{team_id}/prefs", headers, params)
        |> handle_response()
    end
  end

  # --- Private Helpers ---

  defp maybe_put(map, _key, nil), do: map
  defp maybe_put(map, key, value), do: Map.put(map, key, value)

  defp handle_response({:ok, body}), do: {:ok, body}
  defp handle_response({:error, reason}), do: {:error, reason}
end
