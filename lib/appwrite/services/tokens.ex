defmodule Appwrite.Services.Tokens do
  @moduledoc """
  The Tokens service allows you to create short-lived, scoped file access
  tokens that grant unauthenticated (or differently-authenticated) access
  to individual Storage files.

  Tokens are a new Appwrite Cloud feature added in v1.0.0.

  A token URL can be appended to any Storage file URL via the `?token=` query
  parameter (see `Appwrite.Services.Storage.get_file_download/3`, `get_file_view/3`,
  and `get_file_preview/3`).
  """

  use Appwrite.Services.Base

  @doc """
  Create a new file Token.

  ## Parameters
  - `bucket_id` (required) – the bucket the file lives in
  - `file_id` (required) – the file to grant access to
  - `expire` (optional) – ISO 8601 expiration date string; defaults to +30 days
  """
  @spec create_file_token(String.t(), String.t(), String.t() | nil) ::
          {:ok, map()} | {:error, any()}
  def create_file_token(bucket_id, file_id, expire \\ nil) do
    with :ok <- require_all(bucket_id: bucket_id, file_id: file_id) do
      payload =
        %{"bucketId" => bucket_id, "fileId" => file_id}
        |> maybe_put("expire", expire)

      json_call("post", "/v1/tokens/files", payload)
    end
  end

  @doc """
  Get a Token by its unique ID.

  ## Parameters
  - `token_id` (required)
  """
  @spec get_token(String.t()) :: {:ok, map()} | {:error, any()}
  def get_token(token_id) do
    with :ok <- require_all(token_id: token_id) do
      json_call("get", "/v1/tokens/#{token_id}", %{})
    end
  end

  @doc """
  List all Tokens belonging to the current user.

  ## Parameters
  - `queries` (optional)
  """
  @spec list_tokens([String.t()] | nil) :: {:ok, map()} | {:error, any()}
  def list_tokens(queries \\ nil) do
    payload = maybe_put(%{}, "queries", queries)
    json_call("get", "/v1/tokens", payload)
  end

  @doc """
  Update a Token — extend its expiry date or change its scopes.

  ## Parameters
  - `token_id` (required)
  - `expire` (optional) – new ISO 8601 expiration date string
  """
  @spec update_token(String.t(), String.t() | nil) ::
          {:ok, map()} | {:error, any()}
  def update_token(token_id, expire \\ nil) do
    with :ok <- require_all(token_id: token_id) do
      payload = maybe_put(%{}, "expire", expire)
      json_call("patch", "/v1/tokens/#{token_id}", payload)
    end
  end

  @doc """
  Delete a Token by its unique ID.

  ## Parameters
  - `token_id` (required)
  """
  @spec delete_token(String.t()) :: {:ok, map()} | {:error, any()}
  def delete_token(token_id) do
    with :ok <- require_all(token_id: token_id) do
      json_call("delete", "/v1/tokens/#{token_id}", %{})
    end
  end

  # ────────────────────────────────────────────────
  # Private helpers
  # ────────────────────────────────────────────────
end
