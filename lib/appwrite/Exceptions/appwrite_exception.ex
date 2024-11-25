defmodule Appwrite.Exceptions.AppwriteException do
  @moduledoc """
  Represents an exception in the Appwrite library.

  This exception is raised when errors occur during API calls, such as invalid responses or request failures.
  """

  @type t :: %__MODULE__{
          message: String.t(),
          code: non_neg_integer(),
          type: String.t(),
          response: any()
        }

  defexception [
    :message,
    :code,
    :type,
    :response
  ]

  @doc """
  Creates a new `Appwrite.Exception` struct.

  ## Parameters
  - `message` - The error message (default: `"An error occurred"`).
  - `code` - The error code (default: `0`).
  - `type` - The type of the error (default: an empty string).
  - `response` - Additional response data (default: `nil`).

  ## Examples

      iex> Appwrite.Exception.new("Unauthorized access", 401, "auth_error", %{"details" => "Invalid token"})
      %Appwrite.Exception{
        message: "Unauthorized access",
        code: 401,
        type: "auth_error",
        response: %{"details" => "Invalid token"}
      }
  """
  @spec new(String.t(), non_neg_integer(), String.t(), any()) :: t()
  def new(message \\ "An error occurred", code \\ 0, type \\ "", response \\ nil) do
    %__MODULE__{
      message: message,
      code: code,
      type: type,
      response: response
    }
  end

  @doc """
  Converts the exception into a readable string format.

  ## Examples

      iex> exception = Appwrite.Exception.new("Not found", 404, "not_found", %{})
      iex> Appwrite.Exception.to_string(exception)
      "[404] not_found: Not found"
  """
  @spec to_string(t()) :: String.t()
  def to_string(%__MODULE__{message: message, code: code, type: type}) do
    "[#{code}] #{type}: #{message}"
  end
end
