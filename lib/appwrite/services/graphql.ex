defmodule Appwrite.Services.GraphQL do
  @moduledoc """
  The GraphQL service allows you to query and mutate your Appwrite server
  using the GraphQL protocol.

  You can use GraphQL to interact with any service in your Appwrite project.
  The endpoint accepts a JSON object containing a GraphQL query string and
  an optional variables map.
  """

  alias Appwrite.Exceptions.AppwriteException
  alias Appwrite.Utils.Client

  @doc """
  Execute a GraphQL mutation.

  ## Parameters

  - `query` (`map()`): The GraphQL mutation document as a map with the `"query"` key
    (required) and optionally `"variables"` and `"operationName"` keys.

    ```elixir
    %{
      "query" => "mutation CreateUser($email: String!) { createAccount(email: $email) { _id } }",
      "variables" => %{"email" => "user@example.com"}
    }
    ```

  ## Returns

  - `{:ok, map()}` containing the GraphQL response data on success.
  - `{:error, AppwriteException.t()}` on failure.

  ## Examples

      iex> Appwrite.Services.GraphQL.mutation(%{
      ...>   "query" => "mutation { createAccount(email: \\"user@example.com\\", password: \\"password\\") { _id } }"
      ...> })
      {:ok, %{"data" => %{"createAccount" => %{"_id" => "..."}}}}
  """
  @spec mutation(map()) :: {:ok, map()} | {:error, AppwriteException.t()}
  def mutation(query) do
    if is_nil(query) do
      {:error, %AppwriteException{message: "query is required"}}
    else
      # NOTE: x-sdk-graphql header must be combined with content-type.
      # Client.call signature: (method, path, headers, payload)
      headers = %{
        "content-type" => "application/json",
        "x-sdk-graphql" => "true"
      }

      Client.call("POST", "/v1/graphql/mutation", headers, query)
      |> handle_response()
    end
  end

  @doc """
  Execute a GraphQL query.

  ## Parameters

  - `query` (`map()`): The GraphQL query document as a map with the `"query"` key
    (required) and optionally `"variables"` and `"operationName"` keys.

    ```elixir
    %{
      "query" => "query GetUser($id: String!) { getAccount { _id name email } }",
      "variables" => %{"id" => "user123"}
    }
    ```

  ## Returns

  - `{:ok, map()}` containing the GraphQL response data on success.
  - `{:error, AppwriteException.t()}` on failure.

  ## Examples

      iex> Appwrite.Services.GraphQL.query(%{
      ...>   "query" => "{ getAccount { _id name email } }"
      ...> })
      {:ok, %{"data" => %{"getAccount" => %{"_id" => "...", "name" => "...", "email" => "..."}}}}
  """
  @spec query(map()) :: {:ok, map()} | {:error, AppwriteException.t()}
  def query(query) do
    if is_nil(query) do
      {:error, %AppwriteException{message: "query is required"}}
    else
      headers = %{
        "content-type" => "application/json",
        "x-sdk-graphql" => "true"
      }

      Client.call("POST", "/v1/graphql", headers, query)
      |> handle_response()
    end
  end

  # --- Private Helpers ---

  defp handle_response({:ok, body}), do: {:ok, body}
  defp handle_response({:error, reason}), do: {:error, reason}
end
