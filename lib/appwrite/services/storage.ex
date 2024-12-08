defmodule Appwrite.Services.Storage do
  @moduledoc """
   The Storage service allows you to manage your project files.
   Using the Storage service, you can upload, view, download, and query all your project files.

   Each file in the service is granted with read and write permissions to manage who has access to view or edit it.
   You can also learn more about how to manage your resources permissions.

   The preview endpoint allows you to generate preview images for your files.
   Using the preview endpoint, you can also manipulate the resulting image so that it will fit perfectly inside your app in terms of dimensions, file size, and style. The preview endpoint also allows you to change the resulting image file format for better compression or image quality for better delivery over the network.
  """

  alias Appwrite.Utils.General
  alias Appwrite.Utils.Client
  alias Appwrite.Exceptions.AppwriteException
  alias Appwrite.Types.{File, FileList}
  alias Appwrite.Utils.Service

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
      api_path = "/v1/storage/buckets/#{bucket_id}/files"

      payload = %{
        queries: queries,
        search: search
      }

      api_header = %{"content-type" => "application/json"}

      Task.async(fn ->
        try do
          file_list = Client.call("get", api_path, api_header, payload)
          {:ok, file_list}
        rescue
          error -> {:error, error}
        end
      end)
      |> Task.await()
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


  ## Usage

   Step 1: Create the fileInput.js Hook
  Navigate to the assets/js directory in your Phoenix project.
  Create a new file called fileInput.js with the following content:

  export default {
  mounted() {
    this.el.addEventListener("change", async (e) => {
      let file = e.target.files[0];
      if (file) {
        let reader = new FileReader();

        reader.onload = (event) => {
          let base64Content = event.target.result.split(",")[1]; // Extract Base64 content
          this.pushEvent("file_selected", {
            name: file.name,
            size: file.size,
            type: file.type,
            content: base64Content, // Send Base64 file content
          });
        };

        reader.readAsDataURL(file); // Convert file to Base64 Data URL
      }
    });
  },
  };

  Step 2: Initialize the Hook in app.js
  Open assets/js/app.js.
  Import and initialize the fileInput hook by adding the following code:

  let Hooks = {};
  import FileInput from "./fileInput";
  Hooks.FileInput = FileInput;

  let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");
  let liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: { _csrf_token: csrfToken },
  hooks: Hooks,
  });


  Step 3: Use the Hook in Your LiveView
  Frontend (HTML)
  Use the FileInput hook in your form input field:
  <.form phx-submit="file_selected">
  <input type="file" id="file-input" phx-hook="FileInput" name="inputfile" />
  </.form>

  Handle the file upload event in your LiveView module:
  Add an event handler for file_selected:

  @impl true
  def handle_event(
      "file_selected",
      %{"name" => name, "size" => size, "type" => type, "content" => base64_content},
      socket
    ) do
  {:noreply,
   assign(socket, :file_content, %{
     "name" => name,
     "size" => size,
     "type" => type,
     "data" => base64_content,
     "lastModified" => DateTime.utc_now()
   })}
  end

  Add a handler to save the file using your storage service (e.g., Appwrite):
  @impl true
  def handle_event("save", _params, socket) do
  uploaded_file =
    Appwrite.Services.Storage.create_file(
      bucket_id,
      nil,
      socket.assigns.file_content,
      nil
    )

  {:noreply, socket}
  end



  """
  @spec create_file(bucket_id(), file_id() | nil, any(), permissions() | nil) ::
          {:ok, File.t()} | {:error, AppwriteException.t()}
  def create_file(bucket_id, file_id, file, permissions \\ nil) do
    with :ok <- ensure_not_nil(bucket_id, "bucketId"),
         :ok <- ensure_not_nil(file_id, "fileId"),
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
          # "permissions" => permissions
        }

      if permissions != nil do
        Map.put(payload, "permissions", permissions)
      end

      api_header = %{"content-type" => "multipart/form-data"}

      Task.async(fn ->
        try do
          file = Client.chunked_upload("post", api_path, api_header, payload, nil)
          {:ok, file}
        rescue
          error -> {:error, error}
        end
      end)
      |> Task.await()
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
      api_path = "/v1/storage/buckets/#{bucket_id}/files/#{file_id}"

      payload = %{}

      api_header = %{"content-type" => "application/json"}

      Task.async(fn ->
        try do
          file = Client.call("get", api_path, api_header, payload)
          {:ok, file}
        rescue
          error -> {:error, error}
        end
      end)
      |> Task.await()
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
      api_path = "/v1/storage/buckets/#{bucket_id}/files/#{file_id}"

      payload = %{}

      api_header = %{"content-type" => "application/json"}

      Task.async(fn ->
        try do
          Client.chunked_upload("delete", api_path, api_header, payload)
          {:ok, :deleted}
        rescue
          error -> {:error, error}
        end
      end)
      |> Task.await()
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
  @spec get_file_download(String.t(), String.t()) :: String.t()
  def get_file_download(bucket_id, file_id) do
    with :ok <- ensure_not_nil(bucket_id, "bucketId"),
         :ok <- ensure_not_nil(file_id, "fileId") do
      api_path = "/storage/buckets/#{bucket_id}/files/#{file_id}/download"
      uri = URI.merge(Client.default_config()["endpoint"], api_path)

      payload =
        %{
          project: Client.default_config()["project"]
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
          String.t(),
          String.t(),
          keyword()
        ) :: String.t()
  def get_file_preview(bucket_id, file_id, options \\ []) do
    with :ok <- ensure_not_nil(bucket_id, "bucketId"),
         :ok <- ensure_not_nil(file_id, "fileId") do
      api_path = "/storage/buckets/#{bucket_id}/files/#{file_id}/preview"
      uri = URI.merge(Client.default_config()["endpoint"], api_path)

      payload =
        options
        |> Enum.into(%{})
        |> Map.put("project", Client.default_config()["project"])
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
  @spec get_file_view(String.t(), String.t()) :: String.t()
  def get_file_view(bucket_id, file_id) do
    with :ok <- ensure_not_nil(bucket_id, "bucketId"),
         :ok <- ensure_not_nil(file_id, "fileId") do
      api_path = "/storage/buckets/#{bucket_id}/files/#{file_id}/view"
      uri = URI.merge(Client.default_config()["endpoint"], api_path)

      payload =
        %{
          "project" => Client.default_config()["project"]
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

  def to_preflight_payload(file) do
    %{
      lastModified: file.client_last_modified,
      name: file.client_name,
      webkitRelativePath: "",
      # webkitRelativePath: Map.get(file.client_relative_path, :webkit_relative_path, nil) ||  nil,

      size: file.client_size,
      type: file.client_type,
      meta: extract_meta(file.client_meta)
    }
  end

  defp extract_meta(%{meta: meta}) when is_function(meta, 0), do: meta.()
  defp extract_meta(_), do: nil
end
