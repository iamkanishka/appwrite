defmodule Appwrite.Utils.Client do
  @moduledoc """
  HTTP client for the Appwrite SDK.

  Handles request preparation, authentication headers, chunked file uploads,
  and response normalisation for all Appwrite service calls.
  """

  alias Appwrite.Types.Client.{Config, Payload, Headers, UploadProgress}
  alias Appwrite.Exceptions.AppwriteException

  @chunk_size 1024 * 1024 * 5

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

  @type response_type :: String.t()
  @type response :: {:ok, any()} | {:error, any()}

  # ---------------------------------------------------------------------------
  # Public config / header builders (called by service modules)
  # ---------------------------------------------------------------------------

  @doc """
  Returns the resolved runtime configuration map.

  Merges `@base_config` with values from the application environment so that
  service modules can read `endpoint`, `project`, etc.
  """
  @spec default_config() :: Config.t()
  def default_config do
    Map.put(@base_config, "endpoint", get_root_uri())
    |> Map.put("project", get_project_id())
  end

  @doc """
  Updates the project ID in the configuration.
  """
  @spec set_project(String.t()) :: Config.t()
  def set_project(project) when is_binary(project) do
    Map.put(default_config(), "project", project)
  end

  @doc """
  Returns headers with the JWT token set.
  """
  @spec set_jwt(String.t()) :: Headers.t()
  def set_jwt(jwt) when is_binary(jwt) do
    Map.put(build_headers(), "X-Appwrite-JWT", jwt)
  end

  @doc """
  Returns headers with the locale set.
  """
  @spec set_locale(String.t()) :: Headers.t()
  def set_locale(locale) when is_binary(locale) do
    Map.put(build_headers(), "X-Appwrite-Locale", locale)
  end

  @doc """
  Returns headers with the session token set.
  """
  @spec set_session(String.t()) :: Headers.t()
  def set_session(session) when is_binary(session) do
    Map.put(build_headers(), "X-Appwrite-Session", session)
  end

  # ---------------------------------------------------------------------------
  # Request preparation
  # ---------------------------------------------------------------------------

  @doc """
  Builds the final URI and options map for an HTTP request.

  For `GET` requests all params are encoded into the query string.
  For other methods the body is JSON- or multipart-encoded depending on
  the `content-type` header.
  """
  @spec prepare_request(String.t(), String.t(), Headers.t(), Payload.t()) :: {String.t(), map()}
  def prepare_request(method, api_path, headers \\ %{}, params \\ %{}) do
    url = URI.merge(default_config()["endpoint"], api_path)
    method = String.upcase(method)

    merged_headers =
      build_headers()
      |> Map.merge(headers)
      |> maybe_add_fallback_cookie()

    options = %{
      method: method,
      headers: merged_headers,
      credentials: "include",
      body: Jason.encode!(%{})
    }

    if method == "GET" do
      query_string = URI.encode_query(flatten(params))
      {to_string(url) <> "?" <> query_string, options}
    else
      options =
        case merged_headers["content-type"] do
          "application/json" ->
            Map.put(options, :body, Jason.encode!(params))

          "multipart/form-data" ->
            Map.put(options, :body, {:multipart, process_payload(params)})

          _ ->
            options
        end

      {to_string(url), options}
    end
  end

  # ---------------------------------------------------------------------------
  # HTTP call
  # ---------------------------------------------------------------------------

  @doc """
  Makes a synchronous HTTP call and returns `{:ok, result}` or raises
  `AppwriteException` on network or server errors.

  ## Parameters
  - `method`: HTTP verb string (e.g. `"get"`, `"post"`).
  - `api_path`: Path relative to the configured endpoint (must start with `/`).
  - `headers`: Extra request headers merged on top of defaults.
  - `params`: Query parameters (GET) or body parameters (other methods).
  - `response_type`: `"json"` (default), `"arrayBuffer"`, or any other value.
  """
  @spec call(String.t(), String.t(), Headers.t(), Payload.t(), String.t()) :: any()
  def call(method, api_path, headers \\ %{}, params \\ %{}, response_type \\ "json") do
    {uri, options} = prepare_request(method, api_path, headers, params)
    http_method = String.to_atom(String.downcase(method))

    case HTTPoison.request(http_method, uri, options[:body], options[:headers],
           recv_timeout: :timer.hours(1)
         ) do
      {:ok, %HTTPoison.Response{status_code: code, body: body, headers: response_headers}} ->
        handle_response(code, body, response_headers, response_type)

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
  Uploads a file, splitting it into 5 MB chunks if it exceeds the chunk size.

  ## Parameters
  - `method`: HTTP verb string (e.g. `"post"`).
  - `url`: Path relative to the configured endpoint.
  - `headers`: Extra request headers.
  - `payload`: Map that must include a `"file"` key with file metadata.
  - `on_progress`: Optional 1-arity function called with `UploadProgress.t()`
    after each chunk.
  """
  @spec chunked_upload(
          String.t(),
          String.t(),
          Headers.t(),
          Payload.t(),
          (UploadProgress.t() ->
             any())
          | nil
        ) :: any()
  def chunked_upload(method, url, headers \\ %{}, payload \\ %{}, on_progress \\ nil) do
    file = payload["file"]

    if file["size"] <= @chunk_size do
      call(method, url, headers, payload)
    else
      chunked_upload_process(method, url, headers, payload, file, on_progress)
    end
  end

  # ---------------------------------------------------------------------------
  # flatten/2 — public because service modules use it directly
  # ---------------------------------------------------------------------------

  @doc """
  Flattens a nested map or list into a single-level map with bracket-notation keys,
  suitable for URI query encoding.

  ## Examples

      iex> Client.flatten(%{"key" => %{"nested" => "value"}})
      %{"key[nested]" => "value"}

      iex> Client.flatten(%{"list" => ["a", "b"]})
      %{"list[0]" => "a", "list[1]" => "b"}

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
  # Private helpers
  # ---------------------------------------------------------------------------

  @spec handle_response(integer(), binary(), list(), String.t()) :: any()

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

  defp handle_response(_code, body, _headers, _), do: %{"message" => body}

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

  @spec process_payload(map()) :: list()
  defp process_payload(payload) do
    Enum.reduce(payload, [], fn {key, value}, acc ->
      case key do
        "file" when is_map(value) ->
          binary_content = Base.decode64!(value["data"])

          entry = {
            "file",
            binary_content,
            {"form-data", [{"name", "file"}, {"filename", value["name"]}]},
            [{"Content-Type", value["type"]}]
          }

          [entry | acc]

        _ ->
          [{"#{key}", "#{value}"} | acc]
      end
    end)
    |> Enum.reverse()
  end

  @spec chunked_upload_process(
          String.t(),
          String.t(),
          Headers.t(),
          Payload.t(),
          map(),
          (UploadProgress.t() -> any()) | nil
        ) :: any()
  defp chunked_upload_process(method, url, headers, payload, file, on_progress) do
    Stream.iterate(0, &(&1 + @chunk_size))
    |> Stream.take_while(fn start -> start < file["size"] end)
    |> Enum.reduce({nil, headers}, fn start, {_response, current_headers} ->
      end_byte = min(start + @chunk_size, file["size"])

      chunk_headers =
        Map.put(
          current_headers,
          "content-range",
          "bytes #{start}-#{end_byte - 1}/#{file["size"]}"
        )

      chunk = :binary.part(Base.decode64!(file["data"]), start, end_byte - start)

      updated_payload =
        Map.put(payload, "file", %{
          "data" => Base.encode64(chunk),
          "name" => file["name"],
          "size" => file["size"],
          "type" => file["type"],
          "lastModified" => DateTime.utc_now()
        })

      response = call(method, url, chunk_headers, updated_payload)

      if on_progress do
        on_progress.(%UploadProgress{
          id: Map.get(response, "$id"),
          progress: round(end_byte / file["size"] * 100),
          size_uploaded: end_byte,
          chunks_total: div(file["size"], @chunk_size) + 1,
          chunks_uploaded: div(end_byte, @chunk_size)
        })
      end

      next_headers =
        if response && response["$id"] do
          Map.put(chunk_headers, "x-appwrite-id", response["$id"])
        else
          chunk_headers
        end

      {response, next_headers}
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

  @spec get_project_id() :: String.t()
  defp get_project_id do
    case Application.get_env(:appwrite, :project_id) do
      nil -> raise Appwrite.MissingProjectIdError
      project_id -> project_id
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
