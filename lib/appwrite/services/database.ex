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

Status: In Testing
"""


alias Appwrite.Helpers.Client
alias Appwrite.Types.{Document, DocumentList}

@doc """
Lists documents in a specified collection.

## Parameters
  - `client` (`%Client{}`): The Appwrite client instance.
  - `database_id` (`String.t`): The database ID.
  - `collection_id` (`String.t`): The collection ID.
  - `queries` (`list(String.t)`): Optional list of queries.

## Returns
  - `{:ok, %DocumentList{}}` on success.
  - `{:error, reason}` on failure.
"""
@spec list_documents(Client.t(), String.t(), String.t(), list(String.t()) | nil) ::
        {:ok, DocumentList.t()} | {:error, any()}
def list_documents(client, database_id, collection_id, queries \\ nil) do
  with :ok <- validate_params(%{database_id: database_id, collection_id: collection_id}) do
    api_path = "/databases/#{database_id}/collections/#{collection_id}/documents"
    uri = URI.merge(client.config.endpoint, api_path)
    payload = if queries, do: %{queries: queries}, else: %{}

    try do
      Client.call(client, :get, uri, payload)
    rescue
      e -> {:error, e}
    end
  end
end

@doc """
Creates a new document in a specified collection.

## Parameters
  - `client` (`%Client{}`): The Appwrite client instance.
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
        Client.t(),
        String.t(),
        String.t(),
        String.t(),
        map(),
        list(String.t()) | nil
      ) :: {:ok, Document.t()} | {:error, any()}
def create_document(client, database_id, collection_id, document_id, data, permissions \\ nil) do
  with :ok <-
         validate_params(%{
           database_id: database_id,
           collection_id: collection_id,
           document_id: document_id,
           data: data
         }) do
    api_path = "/databases/#{database_id}/collections/#{collection_id}/documents"
    uri = URI.merge(client.config.endpoint, api_path)
    payload = %{documentId: document_id, data: data, permissions: permissions}

    try do
      Client.call(client, :post, uri, payload)
    rescue
      e -> {:error, e}
    end
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
@spec get_document(Client.t(), String.t(), String.t(), String.t(), list(String.t()) | nil) ::
        {:ok, Document.t()} | {:error, any()}
def get_document(client, database_id, collection_id, document_id, queries \\ nil) do
  with :ok <-
         validate_params(%{
           database_id: database_id,
           collection_id: collection_id,
           document_id: document_id
         }) do
    api_path = "/databases/#{database_id}/collections/#{collection_id}/documents/#{document_id}"
    uri = URI.merge(client.config.endpoint, api_path)
    payload = if queries, do: %{queries: queries}, else: %{}

    try do
      Client.call(client, :get, uri, payload)
    rescue
      e -> {:error, e}
    end
  end
end

@doc """
Updates a document by its ID.

## Parameters
  - `client` (`%Client{}`): The Appwrite client instance.
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
        Client.t(),
        String.t(),
        String.t(),
        String.t(),
        map() | nil,
        list(String.t()) | nil
      ) :: {:ok, Document.t()} | {:error, any()}
def update_document(client, database_id, collection_id, document_id, data \\ nil, permissions \\ nil) do
  with :ok <-
         validate_params(%{
           database_id: database_id,
           collection_id: collection_id,
           document_id: document_id
         }) do
    api_path = "/databases/#{database_id}/collections/#{collection_id}/documents/#{document_id}"
    uri = URI.merge(client.config.endpoint, api_path)
    payload = %{data: data, permissions: permissions}

    try do
      Client.call(client, :patch, uri, payload)
    rescue
      e -> {:error, e}
    end
  end
end

@doc """
Deletes a document by its ID.

## Parameters
  - `client` (`%Client{}`): The Appwrite client instance.
  - `database_id` (`String.t`): The database ID.
  - `collection_id` (`String.t`): The collection ID.
  - `document_id` (`String.t`): The document ID.

## Returns
  - `{:ok, %{}}` on success.
  - `{:error, reason}` on failure.
"""
@spec delete_document(Client.t(), String.t(), String.t(), String.t()) ::
        {:ok, %{}} | {:error, any()}
def delete_document(client, database_id, collection_id, document_id) do
  with :ok <-
         validate_params(%{
           database_id: database_id,
           collection_id: collection_id,
           document_id: document_id
         }) do
    api_path = "/databases/#{database_id}/collections/#{collection_id}/documents/#{document_id}"
    uri = URI.merge(client.config.endpoint, api_path)

    try do
      Client.call(client, :delete, uri, %{})
    rescue
      e -> {:error, e}
    end
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
