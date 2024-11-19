defmodule Appwrite.AppwriteException do
  @moduledoc """
  Exception thrown by the Appwrite package.
  """
  defexception [:message, :code, :type, :response]

  @type t :: %__MODULE__{
          message: String.t(),
          code: non_neg_integer(),
          type: String.t(),
          response: String.t()
        }

  @doc """
  Initializes a new AppwriteException.

  ## Parameters
  - `message`: The error message.
  - `code`: The error code (default: 0).
  - `type`: The error type (default: an empty string).
  - `response`: The response string (default: an empty string).
  """
  def exception(%{
        message: message,
        code: code,
        type: type,
        response: response
      }) do
    %__MODULE__{
      message: message,
      code: code,
      type: type,
      response: response
    }
  end
end


# You can raise the exception in Elixir using raise:
# raise Appwrite.AppwriteException, message: "An error occurred", code: 500
