defmodule Appwrite.Utils.Permission do
  @moduledoc """
  Helpers for generating Appwrite permission strings.

  Each function takes a role string (produced by `Appwrite.Utils.Role`) and
  wraps it in the appropriate permission verb expected by the Appwrite API.

  ## Usage

      alias Appwrite.Utils.Permission
      alias Appwrite.Utils.Role

      Permission.read(Role.any())           # => ~s|read("any")|
      Permission.create(Role.users())       # => ~s|create("users")|
      Permission.delete(Role.user("abc"))   # => ~s|delete("user:abc")|

  """

  @doc """
  Grants read access to `role`.

  ## Examples

      iex> Appwrite.Utils.Permission.read("any")
      ~s|read("any")|

  """
  @spec read(String.t()) :: String.t()
  def read(role) when is_binary(role), do: ~s|read("#{role}")|

  @doc """
  Grants write access to `role`.

  This is a combined alias for create + update + delete.
  Avoid mixing `write` with the more granular verbs on the same resource.

  ## Examples

      iex> Appwrite.Utils.Permission.write("admin")
      ~s|write("admin")|

  """
  @spec write(String.t()) :: String.t()
  def write(role) when is_binary(role), do: ~s|write("#{role}")|

  @doc """
  Grants create access to `role`.

  ## Examples

      iex> Appwrite.Utils.Permission.create("users")
      ~s|create("users")|

  """
  @spec create(String.t()) :: String.t()
  def create(role) when is_binary(role), do: ~s|create("#{role}")|

  @doc """
  Grants update access to `role`.

  ## Examples

      iex> Appwrite.Utils.Permission.update("team:abc/admin")
      ~s|update("team:abc/admin")|

  """
  @spec update(String.t()) :: String.t()
  def update(role) when is_binary(role), do: ~s|update("#{role}")|

  @doc """
  Grants delete access to `role`.

  ## Examples

      iex> Appwrite.Utils.Permission.delete("user:123")
      ~s|delete("user:123")|

  """
  @spec delete(String.t()) :: String.t()
  def delete(role) when is_binary(role), do: ~s|delete("#{role}")|
end
