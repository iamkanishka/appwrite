defmodule ExecutionMethod do
  @moduledoc """
  Provides constants and validation functions for different HTTP methods.

  This module defines the allowed HTTP methods (GET, POST, PUT, PATCH, DELETE, OPTIONS)
  and provides helper functions to validate them, ensuring only recognized methods are used
  within the application.
  """

  @get "GET"
  @post "POST"
  @put "PUT"
  @patch "PATCH"
  @delete "DELETE"
  @options "OPTIONS"

  @all_methods [
    @get,
    @post,
    @put,
    @patch,
    @delete,
    @options
  ]

  @doc """
  Guard clause to check if a given HTTP method is valid.

  ## Examples

      iex> ExecutionMethod.valid_method("GET")
      true

      iex> ExecutionMethod.valid_method("UNKNOWN")
      false
  """
  defguard valid_method(method) when method in @all_methods

  @doc """
  Validates the given `method` and returns `{:ok, method}` if it is valid,
  or `{:error, "Invalid HTTP method"}` otherwise.

  ## Examples

      iex> ExecutionMethod.validate_method("POST")
      {:ok, "POST"}

      iex> ExecutionMethod.validate_method("UNKNOWN")
      {:error, "Invalid HTTP method"}
  """
  def validate_method(method) when valid_method(method), do: {:ok, method}
  def validate_method(_method), do: {:error, "Invalid HTTP method"}

  @doc """
  Returns `true` if the given `method` is a valid HTTP method, otherwise `false`.

  ## Examples

      iex> ExecutionMethod.is_valid_method?("PUT")
      true

      iex> ExecutionMethod.is_valid_method?("UNKNOWN")
      false
  """
  def is_valid_method?(method), do: method in @all_methods

  @doc """
  Validates the given `method` and returns it if it is valid. Raises an
  `ArgumentError` if the `method` is invalid.

  ## Examples

      iex> ExecutionMethod.validate_method!("PATCH")
      "PATCH"

      iex> ExecutionMethod.validate_method!("UNKNOWN")
      ** (ArgumentError) Invalid HTTP method: "UNKNOWN"
  """
  def validate_method!(method) do
    if method in @all_methods do
      method
    else
      raise ArgumentError, "Invalid HTTP method: #{inspect(method)}"
    end
  end
end
