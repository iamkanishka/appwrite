defmodule Appwrite.Services.Database do
  @moduledoc """
  The Database service allows you to create structured collections of documents,
  query and filter lists of documents, and manage an advanced set of read and
  write access permissions.

  """

  use Appwrite.Services.Base

  # ────────────────────────────────────────────────
  # Documents
  # ────────────────────────────────────────────────

  @doc """
  Create a new Document.

  ## Parameters
  - `database_id` (required)
  - `collection_id` (required)
  - `document_id` (required) – use `ID.unique()` for auto-generation
  - `data` (optional) – document payload map
  - `permissions` (optional) – list of permission strings
  - `transaction_id` (optional) – stage inside an existing transaction
  """
  @spec create_document(
          String.t(),
          String.t(),
          String.t(),
          map() | nil,
          [String.t()] | nil,
          String.t() | nil
        ) :: {:ok, map()} | {:error, any()}
  def create_document(
        database_id,
        collection_id,
        document_id,
        data \\ nil,
        permissions \\ nil,
        transaction_id \\ nil
      ) do
    with :ok <-
           require_all(
             database_id: database_id,
             collection_id: collection_id,
             document_id: document_id
           ) do
      api_path = "/v1/databases/#{database_id}/collections/#{collection_id}/documents"

      payload =
        %{"documentId" => document_id}
        |> maybe_put("data", data)
        |> maybe_put("permissions", permissions)
        |> maybe_put("transactionId", transaction_id)

      try do
        json_call("post", api_path, payload)
      rescue
        e -> {:error, e}
      end
    end
  end

  @doc """
  Get a Document by its unique ID.

  ## Parameters
  - `database_id` (required)
  - `collection_id` (required)
  - `document_id` (required)
  - `queries` (optional)
  - `transaction_id` (optional) – read uncommitted changes within a transaction
  """
  @spec get_document(String.t(), String.t(), String.t(), [String.t()] | nil, String.t() | nil) ::
          {:ok, map()} | {:error, any()}
  def get_document(database_id, collection_id, document_id, queries \\ nil, transaction_id \\ nil) do
    with :ok <-
           require_all(
             database_id: database_id,
             collection_id: collection_id,
             document_id: document_id
           ) do
      api_path =
        "/v1/databases/#{database_id}/collections/#{collection_id}/documents/#{document_id}"

      payload =
        %{}
        |> maybe_put("queries", queries)
        |> maybe_put("transactionId", transaction_id)

      try do
        json_call("get", api_path, payload)
      rescue
        e -> {:error, e}
      end
    end
  end

  @doc """
  List Documents in a collection.

  ## Parameters
  - `database_id` (required)
  - `collection_id` (required)
  - `queries` (optional)
  - `transaction_id` (optional)
  - `total` (optional) – when `false`, skips count calculation
  - `ttl` (optional) – cache TTL in seconds (0–86400) for select queries
  """
  @spec list_documents(
          String.t(),
          String.t(),
          [String.t()] | nil,
          String.t() | nil,
          boolean() | nil,
          integer() | nil
        ) :: {:ok, map()} | {:error, any()}
  def list_documents(
        database_id,
        collection_id,
        queries \\ nil,
        transaction_id \\ nil,
        total \\ nil,
        ttl \\ nil
      ) do
    with :ok <- require_all(database_id: database_id, collection_id: collection_id) do
      api_path = "/v1/databases/#{database_id}/collections/#{collection_id}/documents"

      payload =
        %{}
        |> maybe_put("queries", queries)
        |> maybe_put("transactionId", transaction_id)
        |> maybe_put("total", total)
        |> maybe_put("ttl", ttl)

      try do
        json_call("get", api_path, payload)
      rescue
        e -> {:error, e}
      end
    end
  end

  @doc """
  Update a Document by its unique ID.

  ## Parameters
  - `database_id` (required)
  - `collection_id` (required)
  - `document_id` (required)
  - `data` (optional) – fields to update
  - `permissions` (optional)
  - `transaction_id` (optional)
  """
  @spec update_document(
          String.t(),
          String.t(),
          String.t(),
          map() | nil,
          [String.t()] | nil,
          String.t() | nil
        ) :: {:ok, map()} | {:error, any()}
  def update_document(
        database_id,
        collection_id,
        document_id,
        data \\ nil,
        permissions \\ nil,
        transaction_id \\ nil
      ) do
    with :ok <-
           require_all(
             database_id: database_id,
             collection_id: collection_id,
             document_id: document_id
           ) do
      api_path =
        "/v1/databases/#{database_id}/collections/#{collection_id}/documents/#{document_id}"

      payload =
        %{}
        |> maybe_put("data", data)
        |> maybe_put("permissions", permissions)
        |> maybe_put("transactionId", transaction_id)

      try do
        json_call("patch", api_path, payload)
      rescue
        e -> {:error, e}
      end
    end
  end

  @doc """
  Upsert a Document (create or update atomically).

  ## Parameters
  - `database_id` (required)
  - `collection_id` (required)
  - `document_id` (required)
  - `data` (optional)
  - `permissions` (optional)
  - `transaction_id` (optional)
  """
  @spec upsert_document(
          String.t(),
          String.t(),
          String.t(),
          map() | nil,
          [String.t()] | nil,
          String.t() | nil
        ) :: {:ok, map()} | {:error, any()}
  def upsert_document(
        database_id,
        collection_id,
        document_id,
        data \\ nil,
        permissions \\ nil,
        transaction_id \\ nil
      ) do
    with :ok <-
           require_all(
             database_id: database_id,
             collection_id: collection_id,
             document_id: document_id
           ) do
      api_path =
        "/v1/databases/#{database_id}/collections/#{collection_id}/documents/#{document_id}"

      payload =
        %{}
        |> maybe_put("data", data)
        |> maybe_put("permissions", permissions)
        |> maybe_put("transactionId", transaction_id)

      try do
        json_call("put", api_path, payload)
      rescue
        e -> {:error, e}
      end
    end
  end

  @doc """
  Delete a Document by its unique ID.

  ## Parameters
  - `database_id` (required)
  - `collection_id` (required)
  - `document_id` (required)
  - `transaction_id` (optional)
  """
  @spec delete_document(String.t(), String.t(), String.t(), String.t() | nil) ::
          {:ok, map()} | {:error, any()}
  def delete_document(database_id, collection_id, document_id, transaction_id \\ nil) do
    with :ok <-
           require_all(
             database_id: database_id,
             collection_id: collection_id,
             document_id: document_id
           ) do
      api_path =
        "/v1/databases/#{database_id}/collections/#{collection_id}/documents/#{document_id}"

      payload = maybe_put(%{}, "transactionId", transaction_id)

      try do
        json_call("delete", api_path, payload)
      rescue
        e -> {:error, e}
      end
    end
  end

  @doc """
  Atomically increment a numeric attribute on a document.

  ## Parameters
  - `database_id` (required)
  - `collection_id` (required)
  - `document_id` (required)
  - `attribute` (required) – the attribute key to increment
  - `value` (optional) – amount to increment by
  - `max` (optional) – upper cap; error thrown if exceeded
  - `transaction_id` (optional)
  """
  @spec increment_document_attribute(
          String.t(),
          String.t(),
          String.t(),
          String.t(),
          number() | nil,
          number() | nil,
          String.t() | nil
        ) :: {:ok, map()} | {:error, any()}
  def increment_document_attribute(
        database_id,
        collection_id,
        document_id,
        attribute,
        value \\ nil,
        max \\ nil,
        transaction_id \\ nil
      ) do
    with :ok <-
           require_all(
             database_id: database_id,
             collection_id: collection_id,
             document_id: document_id,
             attribute: attribute
           ) do
      api_path =
        "/v1/databases/#{database_id}/collections/#{collection_id}/" <>
          "documents/#{document_id}/#{attribute}/increment"

      payload =
        %{}
        |> maybe_put("value", value)
        |> maybe_put("max", max)
        |> maybe_put("transactionId", transaction_id)

      try do
        json_call("patch", api_path, payload)
      rescue
        e -> {:error, e}
      end
    end
  end

  @doc """
  Atomically decrement a numeric attribute on a document.

  ## Parameters
  - `database_id` (required)
  - `collection_id` (required)
  - `document_id` (required)
  - `attribute` (required) – the attribute key to decrement
  - `value` (optional) – amount to decrement by
  - `min` (optional) – lower floor; exception thrown if breached
  - `transaction_id` (optional)
  """
  @spec decrement_document_attribute(
          String.t(),
          String.t(),
          String.t(),
          String.t(),
          number() | nil,
          number() | nil,
          String.t() | nil
        ) :: {:ok, map()} | {:error, any()}
  def decrement_document_attribute(
        database_id,
        collection_id,
        document_id,
        attribute,
        value \\ nil,
        min \\ nil,
        transaction_id \\ nil
      ) do
    with :ok <-
           require_all(
             database_id: database_id,
             collection_id: collection_id,
             document_id: document_id,
             attribute: attribute
           ) do
      api_path =
        "/v1/databases/#{database_id}/collections/#{collection_id}/" <>
          "documents/#{document_id}/#{attribute}/decrement"

      payload =
        %{}
        |> maybe_put("value", value)
        |> maybe_put("min", min)
        |> maybe_put("transactionId", transaction_id)

      try do
        json_call("patch", api_path, payload)
      rescue
        e -> {:error, e}
      end
    end
  end

  # ────────────────────────────────────────────────
  # Transactions
  # ────────────────────────────────────────────────

  @doc """
  Create a new Transaction.

  ## Parameters
  - `ttl` (optional) – seconds before the transaction expires
  """
  @spec create_transaction(integer() | nil) :: {:ok, map()} | {:error, any()}
  def create_transaction(ttl \\ nil) do
    payload = maybe_put(%{}, "ttl", ttl)

    try do
      json_call("post", "/v1/databases/transactions", payload)
    rescue
      e -> {:error, e}
    end
  end

  @doc """
  Get a Transaction by its unique ID.

  ## Parameters
  - `transaction_id` (required)
  """
  @spec get_transaction(String.t()) :: {:ok, map()} | {:error, any()}
  def get_transaction(transaction_id) do
    with :ok <- require_all(transaction_id: transaction_id) do
      try do
        json_call("get", "/v1/databases/transactions/#{transaction_id}", %{})
      rescue
        e -> {:error, e}
      end
    end
  end

  @doc """
  List Transactions across all databases.

  ## Parameters
  - `queries` (optional)
  """
  @spec list_transactions([String.t()] | nil) :: {:ok, map()} | {:error, any()}
  def list_transactions(queries \\ nil) do
    payload = maybe_put(%{}, "queries", queries)

    try do
      json_call("get", "/v1/databases/transactions", payload)
    rescue
      e -> {:error, e}
    end
  end

  @doc """
  Update (commit or rollback) a Transaction.

  ## Parameters
  - `transaction_id` (required)
  - `commit` (optional) – pass `true` to commit
  - `rollback` (optional) – pass `true` to rollback
  """
  @spec update_transaction(String.t(), boolean() | nil, boolean() | nil) ::
          {:ok, map()} | {:error, any()}
  def update_transaction(transaction_id, commit \\ nil, rollback \\ nil) do
    with :ok <- require_all(transaction_id: transaction_id) do
      payload =
        %{}
        |> maybe_put("commit", commit)
        |> maybe_put("rollback", rollback)

      try do
        json_call("patch", "/v1/databases/transactions/#{transaction_id}", payload)
      rescue
        e -> {:error, e}
      end
    end
  end

  @doc """
  Delete a Transaction by its unique ID.

  ## Parameters
  - `transaction_id` (required)
  """
  @spec delete_transaction(String.t()) :: {:ok, map()} | {:error, any()}
  def delete_transaction(transaction_id) do
    with :ok <- require_all(transaction_id: transaction_id) do
      try do
        json_call("delete", "/v1/databases/transactions/#{transaction_id}", %{})
      rescue
        e -> {:error, e}
      end
    end
  end

  @doc """
  Create multiple Operations inside a Transaction in one request.

  ## Parameters
  - `transaction_id` (required)
  - `operations` (optional) – list of operation maps
  """
  @spec create_operations(String.t(), [map()] | nil) :: {:ok, map()} | {:error, any()}
  def create_operations(transaction_id, operations \\ nil) do
    with :ok <- require_all(transaction_id: transaction_id) do
      payload = maybe_put(%{}, "operations", operations)

      try do
        json_call("post", "/v1/databases/transactions/#{transaction_id}/operations", payload)
      rescue
        e -> {:error, e}
      end
    end
  end

  # ────────────────────────────────────────────────
  # Private helpers
  # ────────────────────────────────────────────────
end
