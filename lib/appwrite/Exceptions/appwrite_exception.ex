defmodule Appwrite.Exceptions.AppwriteException do
  @moduledoc """
  Represents an error returned by the Appwrite API or the HTTP layer.

  ## Fields

    * `message`  – Human-readable description of the error.
    * `code`     – HTTP status code (0 for network-level errors).
    * `type`     – Appwrite error type string (e.g. `"user_not_found"`).
    * `response` – The raw decoded response body map, or `nil`.

  ## Usage

      iex> AppwriteException.new("Not found", 404, "document_not_found", %{})
      %AppwriteException{message: "Not found", code: 404, type: "document_not_found", response: %{}}

      # Raise directly
      raise AppwriteException, message: "Unauthorized", code: 401, type: "user_unauthorized"
  """

  defexception [:message, :code, :type, :response]

  @type t :: %__MODULE__{
          message:  String.t(),
          code:     non_neg_integer(),
          type:     String.t(),
          response: map() | nil
        }

  @doc """
  Builds a new `AppwriteException` struct.

  ## Parameters

    * `message`  – Error message string. Defaults to `"An error occurred"`.
    * `code`     – HTTP status code. Defaults to `0`.
    * `type`     – Appwrite error type. Defaults to `"unknown"`.
    * `response` – Raw response body. Defaults to `nil`.
  """
  @spec new(String.t(), non_neg_integer(), String.t(), any()) :: t()
  def new(message \\ "An error occurred", code \\ 0, type \\ "unknown", response \\ nil) do
    %__MODULE__{
      message:  message,
      code:     code,
      type:     type,
      response: response
    }
  end

  @impl true
  def message(%__MODULE__{message: msg, code: code, type: type}) do
    "AppwriteException [#{code}] (#{type}): #{msg}"
  end
end
