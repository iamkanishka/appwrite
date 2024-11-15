defmodule AuthenticationFactor do
  @moduledoc """
  Provides constants and validation functions for different authentication factors.

  This module defines the allowed authentication factors and provides helper functions
  to validate them. It ensures that only recognized authentication factors are used
  within the application.
  """

  @email "email"
  @phone "phone"
  @totp "totp"
  @recovery_code "recoverycode"

  @all_factors [@email, @phone, @totp, @recovery_code]

  @doc """
  Guard clause to check if a given factor is a valid authentication factor.

  ## Examples

      iex> AuthenticationFactor.valid_factor("email")
      true

      iex> AuthenticationFactor.valid_factor("unknown")
      false
  """
  defguard valid_factor(factor) when factor in @all_factors

  @doc """
  Validates the given `factor` and returns `{:ok, factor}` if it is valid,
  or `{:error, "Invalid authentication factor"}` otherwise.

  ## Examples

      iex> AuthenticationFactor.validate_factor("email")
      {:ok, "email"}

      iex> AuthenticationFactor.validate_factor("unknown")
      {:error, "Invalid authentication factor"}
  """
  def validate_factor(factor) when valid_factor(factor), do: {:ok, factor}
  def validate_factor(_factor), do: {:error, "Invalid authentication factor"}

  @doc """
  Returns `true` if the given `factor` is a valid authentication factor, otherwise `false`.

  ## Examples

      iex> AuthenticationFactor.is_valid_factor?("totp")
      true

      iex> AuthenticationFactor.is_valid_factor?("unknown")
      false
  """
  def is_valid_factor?(factor), do: factor in @all_factors

  @doc """
  Validates the given `factor` and returns it if it is valid. Raises an
  `ArgumentError` if the `factor` is invalid.

  ## Examples

      iex> AuthenticationFactor.validate_factor!("phone")
      "phone"

      iex> AuthenticationFactor.validate_factor!("unknown")
      ** (ArgumentError) Invalid authentication factor: "unknown"
  """
  def validate_factor!(factor) do
    if factor in @all_factors do
      factor
    else
      raise ArgumentError, "Invalid authentication factor: #{inspect(factor)}"
    end
  end
end
