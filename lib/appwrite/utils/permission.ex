defmodule Appwrite.Utils.Permission do
  @moduledoc """
  A helper module for generating permission strings for resources.
  """

  @doc """
  Generates a read permission string for the provided role.

  ## Parameters
    - role: A string representing the role.

  ## Examples

      iex> Permission.read("user")
      "read(\"user\")"
  """
  @spec read(String.t()) :: String.t()
  def read(role) when is_binary(role) do
    "read(\"#{role}\")"
  end

  @doc """
  Generates a write permission string for the provided role.

  This is an alias of update, delete, and possibly create.
  Avoid using `write` in combination with `update`, `delete`, or `create`.

  ## Parameters
    - role: A string representing the role.

  ## Examples

      iex> Permission.write("admin")
      "write(\"admin\")"
  """
  @spec write(String.t()) :: String.t()
  def write(role) when is_binary(role) do
    "write(\"#{role}\")"
  end

  @doc """
  Generates a create permission string for the provided role.

  ## Parameters
    - role: A string representing the role.

  ## Examples

      iex> Permission.create("editor")
      "create(\"editor\")"
  """
  @spec create(String.t()) :: String.t()
  def create(role) when is_binary(role) do
    "create(\"#{role}\")"
  end

  @doc """
  Generates an update permission string for the provided role.

  ## Parameters
    - role: A string representing the role.

  ## Examples

      iex> Permission.update("moderator")
      "update(\"moderator\")"
  """
  @spec update(String.t()) :: String.t()
  def update(role) when is_binary(role) do
    "update(\"#{role}\")"
  end

  @doc """
  Generates a delete permission string for the provided role.

  ## Parameters
    - role: A string representing the role.

  ## Examples

      iex> Permission.delete("admin")
      "delete(\"admin\")"
  """
  @spec delete(String.t()) :: String.t()
  def delete(role) when is_binary(role) do
    "delete(\"#{role}\")"
  end
end
