defmodule AuthenticatorType do
  @moduledoc """
  Provides constants and validation functions for different types of authenticators.

  This module defines allowed authenticator types and provides helper functions to validate
  them. It is useful for ensuring that only recognized authenticator types are used within
  the application.
  """

  @totp "totp"

  @all_types [@totp]

  @doc """
  Guard clause to check if a given type is a valid authenticator type.

  ## Examples

      iex> AuthenticatorType.valid_type("totp")
      true

      iex> AuthenticatorType.valid_type("unknown")
      false
  """
  defguard valid_type(type) when type in @all_types

  @doc """
  Validates the given `type` and returns `{:ok, type}` if it is valid,
  or `{:error, "Invalid authenticator type"}` otherwise.

  ## Examples

      iex> AuthenticatorType.validate_type("totp")
      {:ok, "totp"}

      iex> AuthenticatorType.validate_type("unknown")
      {:error, "Invalid authenticator type"}
  """
  def validate_type(type) when valid_type(type), do: {:ok, type}
  def validate_type(_type), do: {:error, "Invalid authenticator type"}

  @doc """
  Returns `true` if the given `type` is a valid authenticator type, otherwise `false`.

  ## Examples

      iex> AuthenticatorType.is_valid_type?("totp")
      true

      iex> AuthenticatorType.is_valid_type?("unknown")
      false
  """
  def is_valid_type?(type), do: type in @all_types

  @doc """
  Validates the given `type` and returns it if it is valid. Raises an
  `ArgumentError` if the `type` is invalid.

  ## Examples

      iex> AuthenticatorType.validate_type!("totp")
      "totp"

      iex> AuthenticatorType.validate_type!("unknown")
      ** (ArgumentError) Invalid authenticator type: "unknown"
  """
  def validate_type!(type) do
    if type in @all_types do
      type
    else
      raise ArgumentError, "Invalid authenticator type: #{inspect(type)}"
    end
  end
end
