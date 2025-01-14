defmodule Appwrite.Services.Database do
  @moduledoc """
  The Database service allows you to create structured collections of documents,
  query and filter lists of documents, and manage an advanced set of read and write access permissions.

  All the data in the database service is stored in structured JSON documents.
  The Appwrite database service also allows you to nest child documents in parent documents and use deep filters to both search
  and query your data.

  Each database document structure in your project is defined using the Appwrite collection rules.
  The collections rules help you ensure all your user-submitted data is validated and stored according to the collection structure.

  Using Appwrite permissions architecture,
  you can assign read or write access to each document in your project for either a specific user,
  team, user role, or even grant it with public access (*).
  """
  alias Appwrite.Utils.General
  alias Appwrite.Utils.Client
  alias Appwrite.Types.{Document, DocumentList}

  @doc """
  Lists documents in a specified collection.

  ## Parameters
    - `database_id` (`String.t`): The database ID.
    - `collection_id` (`String.t`): The collection ID.
    - `queries` (`list(String.t)`): Optional list of queries.

  ## Returns
    - `{:ok, %DocumentList{}}` on success.
    - `{:error, reason}` on failure.
  """
  @spec list_documents(String.t(), String.t(), list(String.t()) | nil) ::
          {:ok, DocumentList.t()} | {:error, any()}
  def list_documents(database_id, collection_id, queries \\ nil) do
    with :ok <- validate_params(%{database_id: database_id, collection_id: collection_id}) do
      api_path = "/v1/databases/#{database_id}/collections/#{collection_id}/documents"
      payload = if queries, do: %{queries: queries}, else: %{}
      api_header = %{"content-type" => "application/json"}

      Task.async(fn ->
        try do
          documents = Client.call("get", api_path, api_header, payload)
          {:ok, documents}
        rescue
          error -> {:error, error}
        end
      end)
      |> Task.await()
    end
  end

  @doc """
  Creates a new document in a specified collection.

  ## Parameters
    - `database_id` (`String.t`): The database ID.
    - `collection_id` (`String.t`): The collection ID.
    - `document_id` (`String.t`): The document ID.
    - `data` (`map`): Document data.
    - `permissions` (`list(String.t)`): Optional permissions.

  ## Returns
    - `{:ok, %Document{}}` on success.
    - `{:error, reason}` on failure.
  """
  @spec create_document(
          String.t(),
          String.t(),
          String.t() | nil,
          map(),
          list(String.t()) | nil
        ) :: {:ok, Document.t()} | {:error, any()}
  def create_document(database_id, collection_id, document_id \\ nil, data, permissions \\ nil) do
    with :ok <-
           validate_params(%{
             database_id: database_id,
             collection_id: collection_id,
             #  document_id: document_id,
             data: data
           }) do
      cust_or_autogen_document_id =
        if document_id == nil,
          do: String.replace(to_string(General.generate_uniqe_id()), "-", ""),
          else: document_id

      api_path = "/v1/databases/#{database_id}/collections/#{collection_id}/documents"
      payload = %{documentId: cust_or_autogen_document_id, data: data, permissions: permissions}
      api_header = %{"content-type" => "application/json"}

      Task.async(fn ->
        try do
          document = Client.call("post", api_path, api_header, payload)
          {:ok, document}
        rescue
          error -> {:error, error}
        end
      end)
      |> Task.await()
    end
  end

  @doc """
  Retrieves a document by its ID.

  ## Parameters
    - `client` (`%Client{}`): The Appwrite client instance.
    - `database_id` (`String.t`): The database ID.
    - `collection_id` (`String.t`): The collection ID.
    - `document_id` (`String.t`): The document ID.
    - `queries` (`list(String.t)`): Optional list of queries.

  ## Returns
    - `{:ok, %Document{}}` on success.
    - `{:error, reason}` on failure.
  """
  @spec get_document(String.t(), String.t(), String.t(), list(String.t()) | nil) ::
          {:ok, Document.t()} | {:error, any()}
  def get_document(database_id, collection_id, document_id, queries \\ nil) do
    with :ok <-
           validate_params(%{
             database_id: database_id,
             collection_id: collection_id,
             document_id: document_id
           }) do
      api_path =
        "/v1/databases/#{database_id}/collections/#{collection_id}/documents/#{document_id}"

      payload = if queries, do: %{queries: queries}, else: %{}
      api_header = %{"content-type" => "application/json"}

      Task.async(fn ->
        try do
          document = Client.call("get", api_path, api_header, payload)
          {:ok, document}
        rescue
          error -> {:error, error}
        end
      end)
      |> Task.await()
    end
  end

  @doc """
  Updates a document by its ID.

  ## Parameters
    - `database_id` (`String.t`): The database ID.
    - `collection_id` (`String.t`): The collection ID.
    - `document_id` (`String.t`): The document ID.
    - `data` (`map`): Partial data to update.
    - `permissions` (`list(String.t)`): Optional permissions.

  ## Returns
    - `{:ok, %Document{}}` on success.
    - `{:error, reason}` on failure.
  """
  @spec update_document(
          String.t(),
          String.t(),
          String.t(),
          map() | nil,
          list(String.t()) | nil
        ) :: {:ok, Document.t()} | {:error, any()}
  def update_document(
        database_id,
        collection_id,
        document_id,
        data \\ nil,
        permissions \\ nil
      ) do
    with :ok <-
           validate_params(%{
             database_id: database_id,
             collection_id: collection_id,
             document_id: document_id
           }) do
      api_path =
        "/v1/databases/#{database_id}/collections/#{collection_id}/documents#{document_id}"

      payload = %{data: data, permissions: permissions}
      api_header = %{"content-type" => "application/json"}

      Task.async(fn ->
        try do
          document = Client.call("patch", api_path, api_header, payload)
          {:ok, document}
        rescue
          error -> {:error, error}
        end
      end)
      |> Task.await()
    end
  end

  @doc """
  Deletes a document by its ID.

  ## Parameters
    - `database_id` (`String.t`): The database ID.
    - `collection_id` (`String.t`): The collection ID.
    - `document_id` (`String.t`): The document ID.

  ## Returns
    - `{:ok, %{}}` on success.
    - `{:error, reason}` on failure.
  """
  @spec delete_document(String.t(), String.t(), String.t()) ::
          {:ok, %{}} | {:error, any()}
  def delete_document(database_id, collection_id, document_id) do
    with :ok <-
           validate_params(%{
             database_id: database_id,
             collection_id: collection_id,
             document_id: document_id
           }) do
      api_path =
        "/v1/databases/#{database_id}/collections/#{collection_id}/documents#{document_id}"

      payload = %{}
      api_header = %{"content-type" => "application/json"}

      Task.async(fn ->
        try do
          document = Client.call("delete", api_path, api_header, payload)
          {:ok, document}
        rescue
          error -> {:error, error}
        end
      end)
      |> Task.await()
    end
  end

  # Helper function to validate parameters
  defp validate_params(params) do
    case Enum.find(params, fn {_, v} -> is_nil(v) end) do
      nil -> :ok
      {key, _} -> {:error, "#{key} is required but was nil"}
    end
  end
end
