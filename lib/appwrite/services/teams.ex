defmodule Appwrite.Services.Teams do
  @moduledoc """
  The Teams service allows you to group users of your project and
  to enable them to share read and write access to your project resources.
  """

  use Appwrite.Services.Base

  @doc "Create a new Team."
  @spec create(String.t(), String.t(), [String.t()] | nil) ::
          {:ok, map()} | {:error, any()}
  def create(team_id, name, roles \\ nil) do
    with :ok <- require_all(team_id: team_id, name: name) do
      payload =
        %{"teamId" => team_id, "name" => name}
        |> maybe_put("roles", roles)

      json_call("post", "/v1/teams", payload)
    end
  end

  @doc """
  List all Teams the current user belongs to.

  ## Parameters
  - `queries` (optional)
  - `search` (optional)
  - `total` (optional) — when `false`, skips count calculation
  """
  @spec list([String.t()] | nil, String.t() | nil, boolean() | nil) ::
          {:ok, map()} | {:error, any()}
  def list(queries \\ nil, search \\ nil, total \\ nil) do
    payload =
      %{}
      |> maybe_put("queries", queries)
      |> maybe_put("search", search)
      |> maybe_put("total", total)

    json_call("get", "/v1/teams", payload)
  end

  @doc "Get a Team by its unique ID."
  @spec get(String.t()) :: {:ok, map()} | {:error, any()}
  def get(team_id) do
    with :ok <- require_all(team_id: team_id) do
      json_call("get", "/v1/teams/#{team_id}", %{})
    end
  end

  @doc "Update a Team's name."
  @spec update(String.t(), String.t()) :: {:ok, map()} | {:error, any()}
  def update(team_id, name) do
    with :ok <- require_all(team_id: team_id, name: name) do
      json_call("put", "/v1/teams/#{team_id}", %{"name" => name})
    end
  end

  @doc "Update a Team's name (preferred alias for `update/2`)."
  @spec update_name(String.t(), String.t()) :: {:ok, map()} | {:error, any()}
  defdelegate update_name(team_id, name), to: __MODULE__, as: :update

  @doc "Delete a Team by its unique ID."
  @spec delete(String.t()) :: {:ok, map()} | {:error, any()}
  def delete(team_id) do
    with :ok <- require_all(team_id: team_id) do
      json_call("delete", "/v1/teams/#{team_id}", %{})
    end
  end

  @doc "Get a Team's preferences."
  @spec get_prefs(String.t()) :: {:ok, map()} | {:error, any()}
  def get_prefs(team_id) do
    with :ok <- require_all(team_id: team_id) do
      json_call("get", "/v1/teams/#{team_id}/prefs", %{})
    end
  end

  @doc "Update a Team's preferences."
  @spec update_prefs(String.t(), map()) :: {:ok, map()} | {:error, any()}
  def update_prefs(team_id, prefs) do
    with :ok <- require_all(team_id: team_id, prefs: prefs) do
      json_call("put", "/v1/teams/#{team_id}/prefs", %{"prefs" => prefs})
    end
  end

  @doc "Invite a user to the team (create a membership)."
  @spec create_membership(
          String.t(),
          [String.t()],
          String.t() | nil,
          String.t() | nil,
          String.t() | nil,
          String.t() | nil,
          String.t() | nil
        ) :: {:ok, map()} | {:error, any()}
  def create_membership(
        team_id,
        roles,
        email \\ nil,
        user_id \\ nil,
        phone \\ nil,
        url \\ nil,
        name \\ nil
      ) do
    with :ok <- require_all(team_id: team_id, roles: roles) do
      payload =
        %{"roles" => roles}
        |> maybe_put("email", email)
        |> maybe_put("userId", user_id)
        |> maybe_put("phone", phone)
        |> maybe_put("url", url)
        |> maybe_put("name", name)

      json_call("post", "/v1/teams/#{team_id}/memberships", payload)
    end
  end

  @doc """
  List memberships for a Team.

  ## Parameters
  - `team_id` (required)
  - `queries` (optional)
  - `search` (optional)
  - `total` (optional) — when `false`, skips count calculation
  """
  @spec list_memberships(String.t(), [String.t()] | nil, String.t() | nil, boolean() | nil) ::
          {:ok, map()} | {:error, any()}
  def list_memberships(team_id, queries \\ nil, search \\ nil, total \\ nil) do
    with :ok <- require_all(team_id: team_id) do
      payload =
        %{}
        |> maybe_put("queries", queries)
        |> maybe_put("search", search)
        |> maybe_put("total", total)

      json_call("get", "/v1/teams/#{team_id}/memberships", payload)
    end
  end

  @doc "Get a membership by its unique ID."
  @spec get_membership(String.t(), String.t()) :: {:ok, map()} | {:error, any()}
  def get_membership(team_id, membership_id) do
    with :ok <- require_all(team_id: team_id, membership_id: membership_id) do
      json_call("get", "/v1/teams/#{team_id}/memberships/#{membership_id}", %{})
    end
  end

  @doc "Update a membership's roles."
  @spec update_membership(String.t(), String.t(), [String.t()]) ::
          {:ok, map()} | {:error, any()}
  def update_membership(team_id, membership_id, roles) do
    with :ok <- require_all(team_id: team_id, membership_id: membership_id, roles: roles) do
      json_call("patch", "/v1/teams/#{team_id}/memberships/#{membership_id}", %{"roles" => roles})
    end
  end

  @doc "Accept an invitation (update membership status)."
  @spec update_membership_status(String.t(), String.t(), String.t(), String.t()) ::
          {:ok, map()} | {:error, any()}
  def update_membership_status(team_id, membership_id, user_id, secret) do
    with :ok <-
           require_all(
             team_id: team_id,
             membership_id: membership_id,
             user_id: user_id,
             secret: secret
           ) do
      json_call(
        "patch",
        "/v1/teams/#{team_id}/memberships/#{membership_id}/status",
        %{"userId" => user_id, "secret" => secret}
      )
    end
  end

  @doc "Remove a user from the team (delete membership)."
  @spec delete_membership(String.t(), String.t()) :: {:ok, map()} | {:error, any()}
  def delete_membership(team_id, membership_id) do
    with :ok <- require_all(team_id: team_id, membership_id: membership_id) do
      json_call("delete", "/v1/teams/#{team_id}/memberships/#{membership_id}", %{})
    end
  end
end
