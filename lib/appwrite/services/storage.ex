defmodule Appwrite.Services.Storage do
  @moduledoc """
  The Storage service allows you to manage your project files.
  Using the Storage service, you can upload, view, download, and query all your project files.

  Each file in the service is granted with read and write permissions to manage who has access to view or edit it.
  You can also learn more about how to manage your resources permissions.

  The preview endpoint allows you to generate preview images for your files.
  Using the preview endpoint, you can also manipulate the resulting image so that it will fit perfectly inside your app in terms of dimensions, file size, and style. The preview endpoint also allows you to change the resulting image file format for better compression or image quality for better delivery over the network.

  Status: In Testing
  """

  alias Appwrite.Helpers.Client
  alias Appwrite.Exceptions.AppwriteException
  alias Appwrite.Types.{File, FileList}
  alias Appwrite.Helpers.Service
  alias Appwrite.Consts.{ImageGravity, ImageFormat}
  alias Appwrite.Types.Client.Payload


  @type bucket_id :: String.t()
  @type file_id :: String.t()
  @type permissions :: [String.t()]
  @type queries :: [String.t()]
  @type payload :: Appwrite.Types.Client.Payload.t()

  @doc """
  List files in a bucket.

  ## Parameters
  - `bucket_id` (String): The ID of the bucket.
  - `queries` (list of String, optional): Queries to filter the results.
  - `search` (String, optional): Search query to filter files.

  ## Returns
  - `{:ok, FileList.t()}` on success.
  - `{:error, AppwriteException.t()}` on failure.
  """
  @spec list_files(bucket_id(), queries() | nil, String.t() | nil) ::
          {:ok, FileList.t()} | {:error, AppwriteException.t()}
  def list_files(bucket_id, queries \\ nil, search \\ nil) do
    with :ok <- ensure_not_nil(bucket_id, "bucketId") do
      api_path = "/storage/buckets/#{bucket_id}/files"

      payload =
        %{}
        |> Map.put_new("queries", queries)
        |> Map.put_new("search", search)

      uri = URI.merge(Appwrite.Config.endpoint(), api_path)

      headers = %{
        "content-type" => "application/json"
      }

      try do
        Client.call(:get, uri, headers, payload)
      rescue
        exception ->
          {:error,
           AppwriteException.new(
             exception.message,
             exception.code,
             exception.type,
             exception.response
           )}
      end
    end
  end

  @doc """
  Create a new file in a bucket.

  ## Parameters
  - `bucket_id` (String): The ID of the bucket.
  - `file_id` (String): Unique ID for the file.
  - `file` (File): The file to upload.
  - `permissions` (list of String, optional): Permissions for the file.

  ## Returns
  - `{:ok, File.t()}` on success.
  - `{:error, AppwriteException.t()}` on failure.
  """
  @spec create_file(bucket_id(), file_id(), File.t(), permissions() | nil) ::
          {:ok, File.t()} | {:error, AppwriteException.t()}
  def create_file(bucket_id, file_id, file, permissions \\ nil) do
    with :ok <- ensure_not_nil(bucket_id, "bucketId"),
         :ok <- ensure_not_nil(file_id, "fileId"),
         :ok <- ensure_not_nil(file, "file") do
      api_path = "/storage/buckets/#{bucket_id}/files"

      payload = %{
        "fileId" => file_id,
        "file" => file,
        "permissions" => permissions
      }

      uri = URI.merge(Appwrite.Config.endpoint(), api_path)

      headers = %{
        "content-type" => "multipart/form-data"
      }

      try do
        Client.chunked_upload(:post, uri, headers, payload)
      rescue
        exception ->
          {:error,
           AppwriteException.new(
             exception.message,
             exception.code,
             exception.type,
             exception.response
           )}
      end
    end
  end

  @doc """
  Get a file by its unique ID.

  ## Parameters
  - `bucket_id` (String): The ID of the bucket.
  - `file_id` (String): The ID of the file.

  ## Returns
  - `{:ok, File.t()}` on success.
  - `{:error, AppwriteException.t()}` on failure.
  """
  @spec get_file(bucket_id(), file_id()) :: {:ok, File.t()} | {:error, AppwriteException.t()}
  def get_file(bucket_id, file_id) do
    with :ok <- ensure_not_nil(bucket_id, "bucketId"),
         :ok <- ensure_not_nil(file_id, "fileId") do
      api_path = "/storage/buckets/#{bucket_id}/files/#{file_id}"

      uri = URI.merge(Appwrite.Config.endpoint(), api_path)
      headers = %{"content-type" => "application/json"}

      try do
        Client.call(:get, uri, headers, %{})
      rescue
        exception ->
          {:error,
           AppwriteException.new(
             exception.message,
             exception.code,
             exception.type,
             exception.response
           )}
      end
    end
  end

  @doc """
  Delete a file by its unique ID.

  ## Parameters
  - `bucket_id` (String): The ID of the bucket.
  - `file_id` (String): The ID of the file.

  ## Returns
  - `{:ok, :deleted}` on success.
  - `{:error, AppwriteException.t()}` on failure.
  """
  @spec delete_file(bucket_id(), file_id()) ::
          {:ok, :deleted} | {:error, AppwriteException.t()}
  def delete_file(bucket_id, file_id) do
    with :ok <- ensure_not_nil(bucket_id, "bucketId"),
         :ok <- ensure_not_nil(file_id, "fileId") do
      api_path = "/storage/buckets/#{bucket_id}/files/#{file_id}"

      uri = URI.merge(Appwrite.Config.endpoint(), api_path)
      headers = %{"content-type" => "application/json"}

      try do
        Client.call(:delete, uri, headers, %{})
        {:ok, :deleted}
      rescue
        exception ->
          {:error,
           AppwriteException.new(
             exception.message,
             exception.code,
             exception.type,
             exception.response
           )}
      end
    end
  end

  @doc """
  Get a file for download.

  Retrieves the file content by its unique ID. The response includes a
  `Content-Disposition: attachment` header, prompting the browser to download the file.

  ## Parameters
  - `bucket_id` (String.t): The ID of the bucket.
  - `file_id` (String.t): The ID of the file.

  ## Returns
  - `String.t`: The URI for downloading the file.

  ## Raises
  - `AppwriteException` if parameters are missing or request fails.
  """
  @spec get_file_download(Client.t(), String.t(), String.t()) :: String.t()
  def get_file_download(client, bucket_id, file_id) do
    with :ok <- ensure_not_nil(bucket_id, "bucketId"),
         :ok <- ensure_not_nil(file_id, "fileId") do
      api_path = "/storage/buckets/#{bucket_id}/files/#{file_id}/download"
      uri = URI.merge(client.config.endpoint, api_path)

      payload =
        %{
          "project" => client.config.project
        }
        |> Service.flatten()

      Enum.each(payload, fn {key, value} ->
        uri = URI.append_query(uri, key, value)
      end)

      uri
    else
      {:error, message} -> raise AppwriteException.new(message: message)
    end
  end

  @doc """
  Get a file preview.

  Generates a preview of an image file. Supports query string arguments for resizing and customization.

  ## Parameters
  - `bucket_id` (String.t): The ID of the bucket.
  - `file_id` (String.t): The ID of the file.
  - Optional preview settings (width, height, gravity, quality, etc.).

  ## Returns
  - `String.t`: The URI for the file preview.

  ## Raises
  - `AppwriteException` if parameters are missing or invalid.
  """
  @spec get_file_preview(
          Client.t(),
          String.t(),
          String.t(),
          keyword()
        ) :: String.t()
  def get_file_preview(client, bucket_id, file_id, options \\ []) do
    with :ok <- ensure_not_nil(bucket_id, "bucketId"),
         :ok <- ensure_not_nil(file_id, "fileId") do
      api_path = "/storage/buckets/#{bucket_id}/files/#{file_id}/preview"
      uri = URI.merge(client.config.endpoint, api_path)

      payload =
        options
        |> Enum.into(%{})
        |> Map.put("project", client.config.project)
        |> Service.flatten()

      Enum.each(payload, fn {key, value} ->
        uri = URI.append_query(uri, key, value)
      end)

      uri
    else
      {:error, message} -> raise AppwriteException.new(message: message)
    end
  end

  @doc """
  Get a file for viewing.

  Retrieves file content by its unique ID. Unlike download, it does not include the
  `Content-Disposition: attachment` header.

  ## Parameters
  - `bucket_id` (String.t): The ID of the bucket.
  - `file_id` (String.t): The ID of the file.

  ## Returns
  - `String.t`: The URI for viewing the file.

  ## Raises
  - `AppwriteException` if parameters are missing.
  """
  @spec get_file_view(Client.t(), String.t(), String.t()) :: String.t()
  def get_file_view(client, bucket_id, file_id) do
    with :ok <- ensure_not_nil(bucket_id, "bucketId"),
         :ok <- ensure_not_nil(file_id, "fileId") do
      api_path = "/storage/buckets/#{bucket_id}/files/#{file_id}/view"
      uri = URI.merge(client.config.endpoint, api_path)

      payload =
        %{
          "project" => client.config.project
        }
        |> Service.flatten()

      Enum.each(payload, fn {key, value} ->
        uri = URI.append_query(uri, key, value)
      end)

      uri
    else
      {:error, message} -> raise AppwriteException.new(message: message)
    end
  end

  # Helper function to validate inputs
  defp ensure_not_nil(value, param_name) when is_nil(value) do
    {:error, AppwriteException.new("#{param_name} is required.", 400)}
  end

  defp ensure_not_nil(_value, _param_name), do: :ok
end
