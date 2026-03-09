defmodule Appwrite.Services.Storage do
  @moduledoc """
  The Storage service allows you to manage your project files.

  Using the Storage service, you can upload, view, download, and query all your project files.
  Each file in the service is granted read and write permissions to manage who has access to
  view or edit it.

  The preview endpoint allows you to generate preview images for your files and manipulate
  the resulting image's dimensions, quality, and file format for optimal delivery.
  """

  alias Appwrite.Utils.General
  alias Appwrite.Utils.Client
  alias Appwrite.Exceptions.AppwriteException
  alias Appwrite.Types.{File, FileList}

  @type bucket_id :: String.t()
  @type file_id :: String.t()
  @type permissions :: [String.t()]
  @type queries :: [String.t()]

  @doc """
  List files in a bucket.

  ## Parameters
  - `bucket_id` (`String.t()`): The ID of the bucket.
  - `queries` (`[String.t()] | nil`): Query strings to filter the results.
  - `search` (`String.t() | nil`): Search term to filter files by name.

  ## Returns
  - `{:ok, FileList.t()}` on success.
  - `{:error, AppwriteException.t()}` on failure.
  """
  @spec list_files(bucket_id(), queries() | nil, String.t() | nil) ::
          {:ok, FileList.t()} | {:error, AppwriteException.t()}
  def list_files(bucket_id, queries \\ nil, search \\ nil) do
    with :ok <- ensure_not_nil(bucket_id, "bucketId") do
      api_path = "/v1/storage/buckets/#{bucket_id}/files"

      payload = %{
        "queries" => queries,
        "search" => search
      }

      api_header = %{"content-type" => "application/json"}
      try do
        file_list = Client.call("get", api_path, api_header, payload)
        {:ok, file_list}
      rescue
        error -> {:error, error}
      end
    end
  end

  @doc """
  Create (upload) a new file in a bucket.

  Accepts the file as a map with base64-encoded content (e.g. from a LiveView file hook).

  ## Parameters
  - `bucket_id` (`String.t()`): The ID of the bucket.
  - `file_id` (`String.t() | nil`): Unique file ID. Auto-generated if `nil`.
  - `file` (any): The file data to upload.
  - `permissions` (`[String.t()] | nil`): Optional permission strings.

  ## Returns
  - `{:ok, File.t()}` on success.
  - `{:error, AppwriteException.t()}` on failure.

  ## LiveView Usage

  ### Step 1 — `fileInput.js` hook

  ```javascript
  export default {
    mounted() {
      this.el.addEventListener("change", async (e) => {
        let file = e.target.files[0];
        if (file) {
          let reader = new FileReader();
          reader.onload = (event) => {
            let base64Content = event.target.result.split(",")[1];
            this.pushEvent("file_selected", {
              name: file.name, size: file.size, type: file.type, content: base64Content
            });
          };
          reader.readAsDataURL(file);
        }
      });
    },
  };
  ```

  ### Step 2 — Handle in LiveView

  ```elixir
  def handle_event("file_selected", %{"name" => name, "content" => content, ...}, socket) do
    {:noreply, assign(socket, :file_content, %{"name" => name, "data" => content, ...})}
  end

  def handle_event("save", _params, socket) do
    {:ok, _file} = Appwrite.Services.Storage.create_file(bucket_id, nil, socket.assigns.file_content)
    {:noreply, socket}
  end
  ```
  """
 @spec create_file(bucket_id(), file_id() | nil, any(), permissions() | nil) ::
        {:ok, File.t()} | {:error, AppwriteException.t()}
def create_file(bucket_id, file_id \\ nil, file, permissions \\ nil) do
  with :ok <- ensure_not_nil(bucket_id, "bucketId"),
       :ok <- ensure_not_nil(file, "file") do
    cust_or_autogen_file_id =
      if file_id == nil,
        do: String.replace(to_string(General.generate_uniqe_id()), "-", ""),
        else: file_id

    api_path = "/v1/storage/buckets/#{bucket_id}/files"

    payload =
      %{
        "fileId" => cust_or_autogen_file_id,
        "file" => file
      }
      |> then(fn p ->
        if permissions != nil, do: Map.put(p, "permissions", permissions), else: p
      end)

    api_header = %{"content-type" => "multipart/form-data"}

    try do
      uploaded_file = Client.chunked_upload("post", api_path, api_header, payload, nil)
      {:ok, uploaded_file}
    rescue
      error -> {:error, error}
    end
  end
end

  @doc """
  Get a file's metadata by its unique ID.

  ## Parameters
  - `bucket_id` (`String.t()`): The ID of the bucket.
  - `file_id` (`String.t()`): The ID of the file.

  ## Returns
  - `{:ok, File.t()}` on success.
  - `{:error, AppwriteException.t()}` on failure.
  """
  @spec get_file(bucket_id(), file_id()) :: {:ok, File.t()} | {:error, AppwriteException.t()}
  def get_file(bucket_id, file_id) do
    with :ok <- ensure_not_nil(bucket_id, "bucketId"),
         :ok <- ensure_not_nil(file_id, "fileId") do
      api_path = "/v1/storage/buckets/#{bucket_id}/files/#{file_id}"
      payload = %{}
      api_header = %{"content-type" => "application/json"}
      try do
        file = Client.call("get", api_path, api_header, payload)
        {:ok, file}
      rescue
        error -> {:error, error}
      end
    end
  end

  @doc """
  Delete a file by its unique ID.

  ## Parameters
  - `bucket_id` (`String.t()`): The ID of the bucket.
  - `file_id` (`String.t()`): The ID of the file.

  ## Returns
  - `{:ok, :deleted}` on success.
  - `{:error, AppwriteException.t()}` on failure.
  """
  @spec delete_file(bucket_id(), file_id()) ::
          {:ok, :deleted} | {:error, AppwriteException.t()}
  def delete_file(bucket_id, file_id) do
    with :ok <- ensure_not_nil(bucket_id, "bucketId"),
         :ok <- ensure_not_nil(file_id, "fileId") do
      api_path = "/v1/storage/buckets/#{bucket_id}/files/#{file_id}"
      payload = %{}
      api_header = %{"content-type" => "application/json"}
      try do
        # NOTE: delete uses Client.call, not chunked_upload
        Client.call("delete", api_path, api_header, payload)
        {:ok, :deleted}
      rescue
        error -> {:error, error}
      end
    end
  end

  @doc """
  Build a file download URL.

  Returns a URL that, when visited, triggers a browser download of the file
  (via a `Content-Disposition: attachment` header).

  ## Parameters
  - `bucket_id` (`String.t()`): The ID of the bucket.
  - `file_id` (`String.t()`): The ID of the file.

  ## Returns
  - `{:ok, String.t()}` containing the download URL on success.
  - `{:error, AppwriteException.t()}` if parameters are missing.
  """
  @spec get_file_download(String.t(), String.t()) ::
          {:ok, String.t()} | {:error, AppwriteException.t()}
  def get_file_download(bucket_id, file_id) do
    with :ok <- ensure_not_nil(bucket_id, "bucketId"),
         :ok <- ensure_not_nil(file_id, "fileId") do
      api_path = "/v1/storage/buckets/#{bucket_id}/files/#{file_id}/download"
      uri = URI.merge(Client.default_config()["endpoint"], api_path)

      query_string =
        %{project: Client.default_config()["project"]}
        |> Client.flatten()
        |> URI.encode_query()

      {:ok, URI.append_query(uri, query_string) |> URI.to_string()}
    end
  end

  @doc """
  Build a file preview URL.

  Generates a preview of an image file. Supports optional resize and customization
  options as a keyword list.

  ## Parameters
  - `bucket_id` (`String.t()`): The ID of the bucket.
  - `file_id` (`String.t()`): The ID of the file.
  - `options` (`keyword()`): Optional preview settings such as `width`, `height`,
    `gravity`, `quality`, `border_width`, `border_color`, `border_radius`,
    `opacity`, `rotation`, `background`, `output`.

  ## Returns
  - `{:ok, String.t()}` containing the preview URL on success.
  - `{:error, AppwriteException.t()}` if parameters are missing.
  """
  @spec get_file_preview(String.t(), String.t(), keyword()) ::
          {:ok, String.t()} | {:error, AppwriteException.t()}
  def get_file_preview(bucket_id, file_id, options \\ []) do
    with :ok <- ensure_not_nil(bucket_id, "bucketId"),
         :ok <- ensure_not_nil(file_id, "fileId") do
      api_path = "/v1/storage/buckets/#{bucket_id}/files/#{file_id}/preview"
      uri = URI.merge(Client.default_config()["endpoint"], api_path)

      query_string =
        options
        |> Enum.map(fn {k, v} -> {to_string(k), v} end)
        |> Map.new()
        |> Map.put("project", Client.default_config()["project"])
        |> Client.flatten()
        |> URI.encode_query()

      {:ok, URI.append_query(uri, query_string) |> URI.to_string()}
    end
  end

  @doc """
  Build a file view URL.

  Returns a URL that renders the file inline in the browser
  (no `Content-Disposition: attachment` header).

  ## Parameters
  - `bucket_id` (`String.t()`): The ID of the bucket.
  - `file_id` (`String.t()`): The ID of the file.

  ## Returns
  - `{:ok, String.t()}` containing the view URL on success.
  - `{:error, AppwriteException.t()}` if parameters are missing.
  """
  @spec get_file_view(String.t(), String.t()) ::
          {:ok, String.t()} | {:error, AppwriteException.t()}
  def get_file_view(bucket_id, file_id) do
    with :ok <- ensure_not_nil(bucket_id, "bucketId"),
         :ok <- ensure_not_nil(file_id, "fileId") do
      api_path = "/v1/storage/buckets/#{bucket_id}/files/#{file_id}/view"
      uri = URI.merge(Client.default_config()["endpoint"], api_path)

      query_string =
        %{"project" => Client.default_config()["project"]}
        |> Client.flatten()
        |> URI.encode_query()

      {:ok, URI.append_query(uri, query_string) |> URI.to_string()}
    end
  end

  # --- Private Helpers ---

  defp ensure_not_nil(nil, param_name) do
    {:error, %AppwriteException{message: "#{param_name} is required.", code: 400}}
  end

  defp ensure_not_nil(_value, _param_name), do: :ok
end
