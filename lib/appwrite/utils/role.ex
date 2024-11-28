defmodule Appwrite.Utils.Role do
  @moduledoc """
  A helper module for generating role strings for `Permission`.
  """

  @doc """
  Grants access to anyone, including authenticated and unauthenticated users.

  ## Examples

      iex> Role.any()
      "any"
  """
  @spec any() :: String.t()
  def any do
    "any"
  end

  @doc """
  Grants access to a specific user by user ID. Optionally, specify `status`
  as `"verified"` or `"unverified"` to target specific types of users.

  ## Parameters
    - id: A string representing the user ID.
    - status: (Optional) A string representing user verification status.

  ## Examples

      iex> Role.user("12345")
      "user:12345"

      iex> Role.user("12345", "verified")
      "user:12345/verified"
  """
  @spec user(String.t(), String.t()) :: String.t()
  def user(id, status \\ "") when is_binary(id) and is_binary(status) do
    if status == "", do: "user:#{id}", else: "user:#{id}/#{status}"
  end

  @doc """
  Grants access to any authenticated or anonymous user. Optionally, specify
  `status` as `"verified"` or `"unverified"`.

  ## Parameters
    - status: (Optional) A string representing user verification status.

  ## Examples

      iex> Role.users()
      "users"

      iex> Role.users("verified")
      "users/verified"
  """
  @spec users(String.t()) :: String.t()
  def users(status \\ "") when is_binary(status) do
    if status == "", do: "users", else: "users/#{status}"
  end

  @doc """
  Grants access to any guest user without a session. Authenticated users do not
  have access to this role.

  ## Examples

      iex> Role.guests()
      "guests"
  """
  @spec guests() :: String.t()
  def guests do
    "guests"
  end

  @doc """
  Grants access to a team by team ID. Optionally, specify `role` to target
  team members with the specified role.

  ## Parameters
    - id: A string representing the team ID.
    - role: (Optional) A string representing the role within the team.

  ## Examples

      iex> Role.team("team123")
      "team:team123"

      iex> Role.team("team123", "admin")
      "team:team123/admin"
  """
  @spec team(String.t(), String.t()) :: String.t()
  def team(id, role \\ "") when is_binary(id) and is_binary(role) do
    if role == "", do: "team:#{id}", else: "team:#{id}/#{role}"
  end

  @doc """
  Grants access to a specific member of a team. When the member is removed from
  the team, they will no longer have access.

  ## Parameters
    - id: A string representing the member ID.

  ## Examples

      iex> Role.member("member123")
      "member:member123"
  """
  @spec member(String.t()) :: String.t()
  def member(id) when is_binary(id) do
    "member:#{id}"
  end

  @doc """
  Grants access to a user with the specified label.

  ## Parameters
    - name: A string representing the label name.

  ## Examples

      iex> Role.label("manager")
      "label:manager"
  """
  @spec label(String.t()) :: String.t()
  def label(name) when is_binary(name) do
    "label:#{name}"
  end
end
