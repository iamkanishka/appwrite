defmodule Appwrite.Utils.Role do
  @moduledoc """
  Helpers for generating Appwrite role strings to use with `Appwrite.Utils.Permission`.

  ## Usage

      alias Appwrite.Utils.Role
      alias Appwrite.Utils.Permission

      Permission.read(Role.any())               # public read
      Permission.write(Role.user("abc123"))      # owner write
      Permission.read(Role.team("team1", "admin"))
      Permission.create(Role.users("verified"))

  """

  @doc """
  Grants access to anyone — authenticated and unauthenticated users alike.

  ## Examples

      iex> Appwrite.Utils.Role.any()
      "any"

  """
  @spec any() :: String.t()
  def any, do: "any"

  @doc """
  Grants access to a specific user by `id`.

  Optionally pass `status` as `"verified"` or `"unverified"` to target only
  users with that email-verification state.

  ## Examples

      iex> Appwrite.Utils.Role.user("12345")
      "user:12345"

      iex> Appwrite.Utils.Role.user("12345", "verified")
      "user:12345/verified"

  """
  @spec user(String.t(), String.t()) :: String.t()
  def user(id, status \\ "") when is_binary(id) and is_binary(status) do
    if status == "", do: "user:#{id}", else: "user:#{id}/#{status}"
  end

  @doc """
  Grants access to any authenticated user.

  Optionally restrict to `"verified"` or `"unverified"` users.

  ## Examples

      iex> Appwrite.Utils.Role.users()
      "users"

      iex> Appwrite.Utils.Role.users("verified")
      "users/verified"

  """
  @spec users(String.t()) :: String.t()
  def users(status \\ "") when is_binary(status) do
    if status == "", do: "users", else: "users/#{status}"
  end

  @doc """
  Grants access to unauthenticated (guest) users only.

  Authenticated users do **not** match this role.

  ## Examples

      iex> Appwrite.Utils.Role.guests()
      "guests"

  """
  @spec guests() :: String.t()
  def guests, do: "guests"

  @doc """
  Grants access to all members of a team identified by `id`.

  Optionally restrict to members who hold a specific `role` within that team.

  ## Examples

      iex> Appwrite.Utils.Role.team("team123")
      "team:team123"

      iex> Appwrite.Utils.Role.team("team123", "admin")
      "team:team123/admin"

  """
  @spec team(String.t(), String.t()) :: String.t()
  def team(id, role \\ "") when is_binary(id) and is_binary(role) do
    if role == "", do: "team:#{id}", else: "team:#{id}/#{role}"
  end

  @doc """
  Grants access to a specific team member by their membership `id`.

  Access is revoked automatically when the member is removed from the team.

  ## Examples

      iex> Appwrite.Utils.Role.member("member123")
      "member:member123"

  """
  @spec member(String.t()) :: String.t()
  def member(id) when is_binary(id), do: "member:#{id}"

  @doc """
  Grants access to any user who has been assigned a specific label `name`.

  ## Examples

      iex> Appwrite.Utils.Role.label("manager")
      "label:manager"

  """
  @spec label(String.t()) :: String.t()
  def label(name) when is_binary(name), do: "label:#{name}"
end
