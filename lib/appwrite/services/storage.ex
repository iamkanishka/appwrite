defmodule Appwrite.Services.Storage do
  @moduledoc """
  The Storage service allows you to manage your project files.

  ## File format for uploads

  The `file_info` argument accepted by `create_file/5` must be a map with the
  following string keys:

      %{
        "name" => "report.pdf",          # display filename
        "data" => <<binary content>>,    # raw binary — NOT base64 at call site
        "type" => "application/pdf",     # MIME type
        "size" => 204_800                # byte length (integer)
      }

  The SDK handles base64 encoding internally for chunked uploads.

  See `CHANGELOG.md` for version history.
  """

  use Appwrite.Services.Base

  @chunk_size 5 * 1024 * 1024

  # ---------------------------------------------------------------------------
  # List
  # ---------------------------------------------------------------------------

  @doc """
  List files in a storage bucket.

  ## Parameters
  - `bucket_id` (required)
  - `queries` (optional) — list of query strings
  - `search` (optional) — text search term
  - `total` (optional) — when `false`, skips count calculation for performance
  """
  @spec list_files(String.t(), [String.t()] | nil, String.t() | nil, boolean() | nil) ::
          {:ok, map()} | {:error, any()}
  def list_files(bucket_id, queries \\ nil, search \\ nil, total \\ nil) do
    with :ok <- require_all(bucket_id: bucket_id) do
      payload =
        %{}
        |> maybe_put("queries", queries)
        |> maybe_put("search", search)
        |> maybe_put("total", total)

      json_call("get", "/v1/storage/buckets/#{bucket_id}/files", payload)
    end
  end

  # ---------------------------------------------------------------------------
  # Create
  # ---------------------------------------------------------------------------

  @doc """
  Create (upload) a new file. Files larger than 5 MB are uploaded in chunks
  automatically using `Client.chunked_upload/5`.

  ## Parameters
  - `bucket_id` (required)
  - `file_id` (required) — use `Appwrite.Utils.Id.unique()` to auto-generate
  - `file_info` (required) — map with string keys:
    - `"name"` — display filename (e.g. `"report.pdf"`)
    - `"data"` — raw binary content
    - `"type"` — MIME type (e.g. `"application/pdf"`)
    - `"size"` — byte length as integer
  - `permissions` (optional) — list of permission strings
  - `on_progress` (optional) — 1-arity callback called after each chunk with
    `%Appwrite.Types.Client.UploadProgress{}`
  """
  @spec create_file(
          String.t(),
          String.t(),
          %{String.t() => String.t() | binary() | integer()},
          [String.t()] | nil,
          (map() -> any()) | nil
        ) :: {:ok, map()} | {:error, any()}
  def create_file(bucket_id, file_id, file_info, permissions \\ nil, on_progress \\ nil) do
    with :ok <- require_all(bucket_id: bucket_id, file_id: file_id),
         :ok <- validate_file_info(file_info) do
      api_path = "/v1/storage/buckets/#{bucket_id}/files"
      file_size = file_info["size"] || byte_size(file_info["data"])

      # Build the file map expected by Client.process_payload:
      # "data" must be base64-encoded; raw binary is encoded here.
      encoded_file = %{
        "name" => file_info["name"],
        "data" => Base.encode64(file_info["data"]),
        "type" => file_info["type"] || "application/octet-stream",
        "size" => file_size
      }

      payload =
        %{"fileId" => file_id, "file" => encoded_file}
        |> maybe_put("permissions", permissions)

      try do
        if file_size <= @chunk_size do
          {:ok, Client.call("post", api_path, multipart_header(), payload)}
        else
          {:ok, Client.chunked_upload("post", api_path, multipart_header(), payload, on_progress)}
        end
      rescue
        e -> {:error, e}
      end
    end
  end

  # ---------------------------------------------------------------------------
  # Read
  # ---------------------------------------------------------------------------

  @doc "Get file metadata by its unique ID."
  @spec get_file(String.t(), String.t()) :: {:ok, map()} | {:error, any()}
  def get_file(bucket_id, file_id) do
    with :ok <- require_all(bucket_id: bucket_id, file_id: file_id) do
      json_call("get", "/v1/storage/buckets/#{bucket_id}/files/#{file_id}", %{})
    end
  end

  # ---------------------------------------------------------------------------
  # Update
  # ---------------------------------------------------------------------------

  @doc """
  Update a file's display name and/or permissions.

  ## Parameters
  - `bucket_id` (required)
  - `file_id` (required)
  - `name` (optional) — new display name
  - `permissions` (optional) — replacement permission list
  """
  @spec update_file(String.t(), String.t(), String.t() | nil, [String.t()] | nil) ::
          {:ok, map()} | {:error, any()}
  def update_file(bucket_id, file_id, name \\ nil, permissions \\ nil) do
    with :ok <- require_all(bucket_id: bucket_id, file_id: file_id) do
      payload =
        %{}
        |> maybe_put("name", name)
        |> maybe_put("permissions", permissions)

      json_call("put", "/v1/storage/buckets/#{bucket_id}/files/#{file_id}", payload)
    end
  end

  # ---------------------------------------------------------------------------
  # Delete
  # ---------------------------------------------------------------------------

  @doc "Delete a file by its unique ID."
  @spec delete_file(String.t(), String.t()) :: {:ok, map()} | {:error, any()}
  def delete_file(bucket_id, file_id) do
    with :ok <- require_all(bucket_id: bucket_id, file_id: file_id) do
      json_call("delete", "/v1/storage/buckets/#{bucket_id}/files/#{file_id}", %{})
    end
  end

  # ---------------------------------------------------------------------------
  # URL builders (return a download/view/preview URL string, no HTTP call)
  # ---------------------------------------------------------------------------

  @doc """
  Build a file download URL.

  ## Parameters
  - `bucket_id` (required)
  - `file_id` (required)
  - `token` (optional) — file token for unauthenticated access via the Tokens API
  """
  @spec get_file_download(String.t(), String.t(), String.t() | nil) ::
          {:ok, String.t()} | {:error, any()}
  def get_file_download(bucket_id, file_id, token \\ nil) do
    with :ok <- require_all(bucket_id: bucket_id, file_id: file_id) do
      {:ok, build_file_url("download", bucket_id, file_id, token: token)}
    end
  end

  @doc """
  Build a file view URL (inline browser display).

  ## Parameters
  - `bucket_id` (required)
  - `file_id` (required)
  - `token` (optional) — file token for unauthenticated access
  """
  @spec get_file_view(String.t(), String.t(), String.t() | nil) ::
          {:ok, String.t()} | {:error, any()}
  def get_file_view(bucket_id, file_id, token \\ nil) do
    with :ok <- require_all(bucket_id: bucket_id, file_id: file_id) do
      {:ok, build_file_url("view", bucket_id, file_id, token: token)}
    end
  end

  @doc """
  Build a file preview URL.

  ## Parameters
  - `bucket_id` (required)
  - `file_id` (required)
  - `opts` — optional keyword list:
    - `:width`, `:height`, `:gravity`, `:quality`
    - `:border_width`, `:border_color`, `:border_radius`
    - `:opacity`, `:rotation`, `:background`, `:output`
    - `:token` — file token for unauthenticated access
  """
  @spec get_file_preview(String.t(), String.t(), keyword()) ::
          {:ok, String.t()} | {:error, any()}
  def get_file_preview(bucket_id, file_id, opts \\ []) do
    with :ok <- require_all(bucket_id: bucket_id, file_id: file_id) do
      extra = [
        width: opts[:width],
        height: opts[:height],
        gravity: opts[:gravity],
        quality: opts[:quality],
        borderWidth: opts[:border_width],
        borderColor: opts[:border_color],
        borderRadius: opts[:border_radius],
        opacity: opts[:opacity],
        rotation: opts[:rotation],
        background: opts[:background],
        output: opts[:output],
        token: opts[:token]
      ]

      {:ok, build_file_url("preview", bucket_id, file_id, extra)}
    end
  end

  # ---------------------------------------------------------------------------
  # Private helpers
  # ---------------------------------------------------------------------------

  @spec build_file_url(String.t(), String.t(), String.t(), keyword()) :: String.t()
  defp build_file_url(operation, bucket_id, file_id, opts) do
    base =
      "#{Client.default_config()["endpoint"]}/v1/storage/buckets/#{bucket_id}/files/#{file_id}/#{operation}"

    params =
      opts
      |> Enum.reject(fn {_, v} -> is_nil(v) end)
      |> Enum.into(%{}, fn {k, v} -> {to_string(k), v} end)
      |> Map.put("project", Client.default_config()["project"])

    "#{base}?#{URI.encode_query(params)}"
  end

  @spec validate_file_info(map() | nil) :: :ok | {:error, AppwriteException.t()}
  defp validate_file_info(nil) do
    {:error, %AppwriteException{message: "Missing required parameter: file_info"}}
  end

  defp validate_file_info(info) when is_map(info) do
    cond do
      is_nil(info["name"]) ->
        {:error, %AppwriteException{message: "file_info must include \"name\""}}

      is_nil(info["data"]) ->
        {:error, %AppwriteException{message: "file_info must include \"data\" (binary content)"}}

      not is_binary(info["data"]) ->
        {:error, %AppwriteException{message: "file_info[\"data\"] must be a binary"}}

      true ->
        :ok
    end
  end

  defp validate_file_info(_) do
    {:error, %AppwriteException{message: "file_info must be a map"}}
  end

  defp multipart_header, do: %{"content-type" => "multipart/form-data"}
end
