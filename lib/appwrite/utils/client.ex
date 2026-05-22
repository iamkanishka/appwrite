defmodule Appwrite.Utils.Client do
  # The HTTP client legitimately depends on many standard-library modules
  # (HTTPoison, Jason, URI, Base, Enum, Map, Stream, System, Application,
  # DateTime, String) plus internal aliases. The dependency count of 22 is
  # acceptable for a low-level networking module.
  # credo:disable-for-this-file Credo.Check.Refactor.ModuleDependencies
  @moduledoc """
  HTTP client for the Appwrite SDK.

  Handles request preparation, authentication headers, chunked file uploads,
  and response normalisation for all Appwrite service calls.
  """

  # Aliases ordered alphabetically; one per line (Credo.Check.Readability.AliasOrder,
  # Credo.Check.Readability.MultiAlias).
  alias Appwrite.Exceptions.AppwriteException
  alias Appwrite.Types.Client.Config
  alias Appwrite.Types.Client.Headers
  alias Appwrite.Types.Client.Payload
  alias Appwrite.Types.Client.UploadProgress

  @chunk_size 1_024 * 1_024 * 5

  @base_headers %{
    "x-sdk-name" => "Web",
    "x-sdk-platform" => "client",
    "x-sdk-language" => "web",
    "x-sdk-version" => "16.0.2",
    "X-Appwrite-Response-Format" => "1.6.0",
    "X-Appwrite-Session" => ""
  }

  @base_config %{
    "endpoint" => "https://cloud.appwrite.io/v1",
    "endpoint_realtime" => "wss://cloud.appwrite.io/v1",
    "project" => nil,
    "jwt" => nil,
    "locale" => nil,
    "session" => nil
  }

  # ---------------------------------------------------------------------------
  # Public config / header builders
  # ---------------------------------------------------------------------------

  @doc "Returns the resolved runtime configuration map."
  @spec default_config() :: Config.t()
  def default_config do
    @base_config
    |> Map.put("endpoint", get_root_uri())
    |> Map.put("project", get_project_id())
  end

  @doc "Updates the project ID in the configuration."
  @spec set_project(String.t()) :: Config.t()
  def set_project(project) when is_binary(project) do
    Map.put(default_config(), "project", project)
  end

  @doc "Returns headers with the JWT token set."
  @spec set_jwt(String.t()) :: Headers.t()
  def set_jwt(jwt) when is_binary(jwt) do
    Map.put(build_headers(), "X-Appwrite-JWT", jwt)
  end

  @doc "Returns headers with the locale set."
  @spec set_locale(String.t()) :: Headers.t()
  def set_locale(locale) when is_binary(locale) do
    Map.put(build_headers(), "X-Appwrite-Locale", locale)
  end

  @doc "Returns headers with the session token set."
  @spec set_session(String.t()) :: Headers.t()
  def set_session(session) when is_binary(session) do
    Map.put(build_headers(), "X-Appwrite-Session", session)
  end

  # ---------------------------------------------------------------------------
  # Request preparation
  # ---------------------------------------------------------------------------

  @doc """
  Builds the final URI string and HTTPoison options map for a request.

  For `GET` requests all params are encoded into the query string.
  For other methods the body is JSON- or multipart-encoded depending on
  the `content-type` header.
  """
  @spec prepare_request(String.t(), String.t(), Headers.t(), Payload.t()) :: {String.t(), map()}
  def prepare_request(method, api_path, headers \\ %{}, params \\ %{}) do
    url = URI.merge(default_config()["endpoint"], api_path)
    upcased = String.upcase(method)

    merged_headers =
      build_headers()
      |> Map.merge(headers)
      |> maybe_add_fallback_cookie()

    base_opts = %{method: upcased, headers: merged_headers, credentials: "include"}

    if upcased == "GET" do
      query = URI.encode_query(flatten(params))
      {to_string(url) <> "?" <> query, Map.put(base_opts, :body, Jason.encode!(%{}))}
    else
      body = encode_body(merged_headers["content-type"], params)
      {to_string(url), Map.put(base_opts, :body, body)}
    end
  end

  # ---------------------------------------------------------------------------
  # HTTP call
  # ---------------------------------------------------------------------------

  @doc """
  Makes a synchronous HTTP call and returns the decoded response.

  Raises `AppwriteException` on network or server errors.

  ## Parameters
  - `method`        — HTTP verb (e.g. `"get"`, `"POST"`).
  - `api_path`      — Path relative to the configured endpoint.
  - `headers`       — Extra headers merged on top of defaults.
  - `params`        — Query params (GET) or body params (other methods).
  - `response_type` — `"json"` (default), `"arrayBuffer"`, or other.
  """
  @spec call(String.t(), String.t(), Headers.t(), Payload.t(), String.t()) ::
          map() | nil | binary()
  def call(method, api_path, headers \\ %{}, params \\ %{}, response_type \\ "json") do
    {uri, opts} = prepare_request(method, api_path, headers, params)

    # FIX: String.to_existing_atom/1 is safe here because all valid HTTP method
    # atoms (:get, :post, :put, :patch, :delete, :head, :options) are guaranteed
    # to exist in any Elixir app that loads HTTPoison.
    http_method =
      method
      |> String.downcase()
      |> String.to_existing_atom()

    case HTTPoison.request(http_method, uri, opts[:body], opts[:headers],
           recv_timeout: :timer.hours(1)
         ) do
      {:ok, %HTTPoison.Response{status_code: code, body: body, headers: resp_headers}} ->
        handle_response(code, body, resp_headers, response_type)

      {:error, %HTTPoison.Error{reason: reason}} ->
        raise AppwriteException,
          message: inspect(reason),
          code: 500,
          type: response_type,
          response: nil
    end
  end

  # ---------------------------------------------------------------------------
  # Chunked upload
  # ---------------------------------------------------------------------------

  @doc """
  Uploads a file, splitting into 5 MB chunks when the file exceeds the limit.

  The `payload["file"]` value must be a map with:
  - `"data"` — base64-encoded binary
  - `"name"` — filename string
  - `"type"` — MIME type string
  - `"size"` — byte length integer
  """
  @spec chunked_upload(
          String.t(),
          String.t(),
          Headers.t(),
          Payload.t(),
          (UploadProgress.t() -> any()) | nil
        ) :: map() | nil | binary()
  def chunked_upload(method, url, headers \\ %{}, payload \\ %{}, on_progress \\ nil) do
    file = payload["file"]

    if file["size"] <= @chunk_size do
      call(method, url, headers, payload)
    else
      chunked_upload_process(method, url, headers, payload, file, on_progress)
    end
  end

  # ---------------------------------------------------------------------------
  # flatten/2 — public; used by service modules for URI encoding
  # ---------------------------------------------------------------------------

  @doc """
  Flattens a nested map or list into a single-level map with bracket-notation
  keys, suitable for `URI.encode_query/1`.

  ## Examples

      iex> Appwrite.Utils.Client.flatten(%{"a" => %{"b" => "v"}})
      %{"a[b]" => "v"}

      iex> Appwrite.Utils.Client.flatten(%{"list" => ["x", "y"]})
      %{"list[0]" => "x", "list[1]" => "y"}

  """
  @spec flatten(map() | list() | any(), String.t()) :: map()
  def flatten(data, prefix \\ "")

  def flatten(data, prefix) when is_map(data) do
    Enum.reduce(data, %{}, fn {key, value}, acc ->
      final_key = if prefix == "", do: to_string(key), else: "#{prefix}[#{key}]"
      Map.merge(acc, flatten(value, final_key))
    end)
  end

  def flatten(data, prefix) when is_list(data) do
    data
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {value, index}, acc ->
      Map.merge(acc, flatten(value, "#{prefix}[#{index}]"))
    end)
  end

  def flatten(data, prefix), do: %{prefix => data}

  # ---------------------------------------------------------------------------
  # Private — response handling
  # ---------------------------------------------------------------------------

  @spec handle_response(integer(), binary(), list(), String.t()) :: map() | nil | binary()
  defp handle_response(code, body, _headers, response_type) when code >= 400 do
    data =
      if response_type == "json" do
        case Jason.decode(body) do
          {:ok, decoded} -> decoded
          _ -> %{"message" => body}
        end
      else
        %{"message" => body}
      end

    raise AppwriteException,
      message: Map.get(data, "message", "Request failed with status #{code}"),
      code: code,
      type: response_type,
      response: data
  end

  defp handle_response(204, _body, _headers, _response_type), do: nil

  defp handle_response(_code, body, _headers, "arrayBuffer"), do: body

  defp handle_response(_code, body, _headers, "json") do
    case Jason.decode(body) do
      {:ok, decoded} -> decoded
      {:error, _} -> %{"raw" => body}
    end
  end

  defp handle_response(_code, body, _headers, _type), do: %{"message" => body}

  # ---------------------------------------------------------------------------
  # Private — body encoding
  # ---------------------------------------------------------------------------

  @spec encode_body(String.t() | nil, map()) :: binary() | {:multipart, list()}
  defp encode_body("application/json", params), do: Jason.encode!(params)
  defp encode_body("multipart/form-data", params), do: {:multipart, process_payload(params)}
  defp encode_body(_type, _params), do: Jason.encode!(%{})

  # ---------------------------------------------------------------------------
  # Private — header helpers
  # ---------------------------------------------------------------------------

  @spec maybe_add_fallback_cookie(Headers.t()) :: Headers.t()
  defp maybe_add_fallback_cookie(headers) do
    case System.get_env("FALLBACK_COOKIE") do
      nil -> headers
      cookie -> Map.put(headers, "X-Fallback-Cookies", cookie)
    end
  end

  @spec build_headers() :: Headers.t()
  defp build_headers do
    @base_headers
    |> Map.put("X-Appwrite-Project", get_project_id())
    |> Map.put("X-Appwrite-Key", get_secret())
  end

  # ---------------------------------------------------------------------------
  # Private — multipart payload processing
  # ---------------------------------------------------------------------------

  @spec process_payload(map()) :: list()
  defp process_payload(payload) do
    payload
    |> Enum.reduce([], fn {key, value}, acc ->
      [build_form_entry(key, value) | acc]
    end)
    |> Enum.reverse()
  end

  @spec build_form_entry(String.t(), any()) :: tuple()
  defp build_form_entry("file", value) when is_map(value) do
    binary_content = Base.decode64!(value["data"])

    {"file", binary_content, {"form-data", [{"name", "file"}, {"filename", value["name"]}]},
     [{"Content-Type", value["type"]}]}
  end

  defp build_form_entry(key, value), do: {"#{key}", "#{value}"}

  # ---------------------------------------------------------------------------
  # Private — chunked upload (extracted into focused helpers to reduce ABC size)
  # ---------------------------------------------------------------------------

  @spec chunked_upload_process(
          String.t(),
          String.t(),
          Headers.t(),
          Payload.t(),
          map(),
          (UploadProgress.t() -> any()) | nil
        ) :: map() | nil | binary()
  defp chunked_upload_process(method, url, headers, payload, file, on_progress) do
    # FIX: Assign the stream to a variable before piping (Credo.Check.Refactor.PipeChainStart)
    chunk_stream = build_chunk_stream(file["size"])

    chunk_stream
    |> Enum.reduce({nil, headers}, fn start, {_last_resp, current_headers} ->
      upload_one_chunk(method, url, current_headers, payload, file, start, on_progress)
    end)
    |> elem(0)
  rescue
    exception ->
      reraise AppwriteException,
              [
                message: Exception.message(exception),
                code: 500,
                type: "chunked_upload",
                response: nil
              ],
              __STACKTRACE__
  end

  # Builds the stream of byte-offset start positions for each chunk.
  @spec build_chunk_stream(non_neg_integer()) :: Enumerable.t()
  defp build_chunk_stream(file_size) do
    # FIX: assign stream to variable before piping to satisfy PipeChainStart
    initial = Stream.iterate(0, &(&1 + @chunk_size))
    Stream.take_while(initial, fn start -> start < file_size end)
  end

  # Uploads a single chunk and returns an updated {response, headers} tuple.
  @spec upload_one_chunk(
          String.t(),
          String.t(),
          Headers.t(),
          Payload.t(),
          map(),
          non_neg_integer(),
          (UploadProgress.t() -> any()) | nil
        ) :: {map() | nil | binary(), Headers.t()}
  defp upload_one_chunk(method, url, headers, payload, file, start, on_progress) do
    file_size = file["size"]
    end_byte = min(start + @chunk_size, file_size)
    chunk_size = end_byte - start

    chunk_headers =
      Map.put(headers, "content-range", "bytes #{start}-#{end_byte - 1}/#{file_size}")

    chunk = :binary.part(Base.decode64!(file["data"]), start, chunk_size)

    updated_payload =
      Map.put(payload, "file", %{
        "data" => Base.encode64(chunk),
        "name" => file["name"],
        "size" => file_size,
        "type" => file["type"],
        "lastModified" => DateTime.utc_now()
      })

    response = call(method, url, chunk_headers, updated_payload)

    maybe_report_progress(on_progress, response, end_byte, file_size)

    next_headers = maybe_add_id_header(chunk_headers, response)

    {response, next_headers}
  end

  @spec maybe_report_progress(
          (UploadProgress.t() -> any()) | nil,
          map() | nil | binary(),
          non_neg_integer(),
          non_neg_integer()
        ) :: :ok
  defp maybe_report_progress(nil, _response, _end_byte, _file_size), do: :ok

  defp maybe_report_progress(on_progress, response, end_byte, file_size) do
    on_progress.(%UploadProgress{
      id: if(is_map(response), do: Map.get(response, "$id"), else: nil),
      progress: round(end_byte / file_size * 100),
      size_uploaded: end_byte,
      chunks_total: ceil(file_size / @chunk_size),
      chunks_uploaded: div(end_byte, @chunk_size)
    })

    :ok
  end

  @spec maybe_add_id_header(Headers.t(), map() | nil | binary()) :: Headers.t()
  defp maybe_add_id_header(headers, response) when is_map(response) do
    case Map.get(response, "$id") do
      nil -> headers
      id -> Map.put(headers, "x-appwrite-id", id)
    end
  end

  defp maybe_add_id_header(headers, _response), do: headers

  # ---------------------------------------------------------------------------
  # Private — config readers
  # ---------------------------------------------------------------------------

  @spec get_project_id() :: String.t()
  defp get_project_id do
    case Application.get_env(:appwrite, :project_id) do
      nil -> raise Appwrite.MissingProjectIdError
      id -> id
    end
  end

  @spec get_secret() :: String.t()
  defp get_secret do
    case Application.get_env(:appwrite, :secret) do
      nil -> raise Appwrite.MissingSecretError
      secret -> secret
    end
  end

  @spec get_root_uri() :: String.t()
  defp get_root_uri do
    case Application.get_env(:appwrite, :root_uri) do
      nil -> raise Appwrite.MissingRootUriError
      uri -> uri
    end
  end
end
