defmodule Appwrite.Services.GraphQL do
  @moduledoc """
  The GraphQL service allows you to query and mutate your Appwrite server
  using the GraphQL protocol.

  You can use GraphQL to interact with any service in your Appwrite project.
  The endpoint accepts a JSON object containing a GraphQL query string and
  an optional variables map.
  """

  use Appwrite.Services.Base

  @graphql_headers %{
    "content-type" => "application/json",
    "x-sdk-graphql" => "true"
  }

  @doc """
  Execute a GraphQL mutation.

  ## Parameters

  - `query` (`map()`): The GraphQL mutation document. Must include a `"query"` key,
    and optionally `"variables"` and `"operationName"` keys.

  ## Returns

  - `{:ok, map()}` containing the GraphQL response data on success.
  - `{:error, AppwriteException.t()}` on failure.
  """
  @spec mutation(map()) :: {:ok, map()} | {:error, AppwriteException.t()}
  def mutation(query) do
    if is_nil(query) do
      {:error, %AppwriteException{message: "query is required"}}
    else
      # FIX: was `Client.call(...) |> handle_response()` — Credo flags single-function
      # pipe chains. Replaced with direct tuple wrapping. `handle_response/1` removed.
      try do
        {:ok, Client.call("POST", "/v1/graphql/mutation", @graphql_headers, query)}
      rescue
        error -> {:error, error}
      end
    end
  end

  @doc """
  Execute a GraphQL query.

  ## Parameters

  - `query` (`map()`): The GraphQL query document. Must include a `"query"` key,
    and optionally `"variables"` and `"operationName"` keys.

  ## Returns

  - `{:ok, map()}` containing the GraphQL response data on success.
  - `{:error, AppwriteException.t()}` on failure.
  """
  @spec query(map()) :: {:ok, map()} | {:error, AppwriteException.t()}
  def query(query) do
    if is_nil(query) do
      {:error, %AppwriteException{message: "query is required"}}
    else
      try do
        {:ok, Client.call("POST", "/v1/graphql", @graphql_headers, query)}
      rescue
        error -> {:error, error}
      end
    end
  end
end
