defmodule Appwrite.Utils.Client do
  @moduledoc """
  Client module for handling requests to Appwrite.
  """
  alias Appwrite.Utils.General
  alias Appwrite.Types.Client.{Config, Payload, Headers, UploadProgress}
  alias Appwrite.Exceptions.AppwriteException

  @chunk_size 1024 * 1024 * 5

  @headers %{
    "x-sdk-name" => "Web",
    "x-sdk-platform" => "client",
    "x-sdk-language" => "web",
    "x-sdk-version" => "16.0.2",
    "X-Appwrite-Response-Format" => "1.6.0",
    "X-Appwrite-Session" => ""
  }

  @config %{
    endpoint: "https://cloud.appwrite.io/v1",
    endpoint_realtime: "wss://cloud.appwrite.io/v1",
    project: nil,
    jwt: nil,
    locale: nil,
    session: nil
  }

  @type response_type :: String.t()
  @type response :: {:ok, any()} | {:error, any()}

  @doc """
  Sets the Project.

  ## Parameters

    - `project`: The Project Name.

  ## Returns
    - Updated Config map.
  """
  @spec set_project(String.t()) :: Config.t()
  def set_project(project) when is_binary(project) do
    Map.put(default_config(), "project", project)
  end

  @doc """
  Sets the JWT.

  ## Parameters

    - `jwt`: The JSON Web Token.

  ## Returns
    - Updated Header map.
  """
  @spec set_locale(String.t()) :: Headers.t()
  def set_jwt(jwt) when is_binary(jwt) do
    Map.put(default_headers(), "X-Appwrite-JWT", jwt)
  end

  @doc """
  Sets the locale.

  ## Parameters
    - `client`: The current client instance.
    - `locale`: The locale string.

  ## Returns
    - Updated client instance.
  """
  @spec set_locale(String.t()) :: Headers.t()
  def set_locale(locale) when is_binary(locale) do
    Map.put(default_headers(), "X-Appwrite-Locale", locale)
  end

  @doc """
  Sets the session.

  ## Parameters
    - `client`: The current client instance.
    - `session`: The session string.

  ## Returns
    - Updated client instance.
  """
  @spec set_session(String.t()) :: Headers.t()
  def set_session(session) when is_binary(session) do
    Map.put(default_headers(), "X-Appwrite-Session", session)
  end

  @doc """
  Prepares an HTTP request with the specified method, URL, headers, and parameters.

  ## Parameters
    - `method`: HTTP method as a string (e.g., "GET", "POST").
    - `url`: Base URL as a string.
    - `headers`: Map of headers (default: `%{}`).
    - `params`: Map of query or body parameters (default: `%{}`).

  ## Returns
    - Tuple containing the URI and options for the request.
  """
  @spec prepare_request(String.t(), String.t(), Headers.t(), Payload.t()) :: {String.t(), map()}
  def prepare_request(method, api_path, headers \\ %{}, params \\ %{}) do
    url = URI.merge(default_config()["endpoint"], api_path)
    method = String.upcase(method)

    headers =
      Map.merge(default_headers(), headers)
      |> maybe_add_fallback_cookie()

    options = %{
      method: method,
      headers: headers,
      credentials: "include",
      body: %{} |> Jason.encode!()
    }

    {uri, options} =
      if method == "GET" do
        # IO.inspect(method, label: "method")

        # query = URI.encode_query(params)
        # {url <> "?" <> query, options}

        # flattened_params = flatten(params)
        # IO.inspect(flattened_params, label: "flattened_params")

        # Append each key-value pair to the URL's query string
        query_string = URI.encode_query(flatten(params))
        {to_string(url) <> "?" <> query_string, options}

        # if query_string != "" and Map.keys(options) != [] do
        #   {to_string(url) <> "?" <> query_string, options}
        # else
        #   {to_string(url)}
        # end
      else
        options =
          case headers["content-type"] do
            "application/json" ->
              Map.put(options, :body, Jason.encode!(params))

            "multipart/form-data" ->
              multipart_data =
                {:multipart, process_payload(params)}

              Map.put(options, :body, multipart_data)

            _ ->
              options
          end

        {to_string(url), options}
      end

    {uri, options}
  end

  @doc """
  Processes a payload map into a list of tuples formatted for HTTP multipart requests.

  ## Parameters

    - `payload` (map): A map containing key-value pairs to be processed. The map can include a special `"file"` key with a nested map for file metadata.

  ## Returns

    - A list of tuples representing the processed payload:
      - For the `"file"` key:
        ```elixir
        {"file", binary_content,
          {"form-data", [{"name", "file"}, {"filename", file_name}]},
          [{"Content-Type", file_type}]}
        ```
      - For all other keys:
        ```elixir
        {"key", "value"}
        ```

  ## Examples

      iex> payload = %{
      ...>   "fileId" => "12345",
      ...>   "file" => %{"content" => "binary_content", "name" => "example.txt", "type" => "text/plain"},
      ...>   "permissions" => "read-only"
      ...> }
      iex> PayloadProcessor.process_payload(payload)
      [
        {"fileId", "12345"},
        {"file", "binary_content",
         {"form-data", [{"name", "file"}, {"filename", "example.txt"}]},
         [{"Content-Type", "text/plain"}]},
        {"permissions", "read-only"}
      ]

  """

  defp process_payload(payload) do
    Enum.reduce(payload, [], fn {key, value}, acc ->
      case key do
        "file" ->
          # Extract file information if the key is "file"
          file_data = value

          if is_map(file_data) do
            binary_content = Base.decode64!(file_data["data"])

            [
              {"file", binary_content,
               {"form-data", [{"name", "file"}, {"filename", file_data["name"]}]},
               [{"Content-Type", file_data["type"]}]}
              | acc
            ]
          else
            acc
          end

        _ ->
          # Add other key-value pairs as {"key", "value"}
          # if(is_list(value)) do
          #   [{"#{key}", value} | acc]
          # else
          #   [{"#{key}", "#{value}"} | acc]
          # end
          [{"#{key}", "#{value}"} | acc]
      end
    end)
    |> Enum.reverse()
  end

  @doc """
  Makes an HTTP call using the given method, URL, headers, and parameters.

  ## Parameters
    - `method`: HTTP method.
    - `url`: Target URL.
    - `headers`: Map of headers.
    - `params`: Parameters for the request.
    - `response_type`: Type of response expected (default: `"json"`).

  ## Returns
    - Response data or raises an `AppwriteException` on error.
  """
  @spec call(String.t(), String.t(), Headers.t(), Payload.t(), String.t()) :: response()

  def call(method, api_path, headers \\ %{}, params \\ %{}, response_type \\ "json") do
    try do
      {uri, options} = prepare_request(method, api_path, headers, params)
      method = String.to_atom(method)

      case HTTPoison.request(method, uri, options[:body], options[:headers],
             recv_timeout: :timer.hours(1)
           ) do
        {:ok, %HTTPoison.Response{status_code: code, body: body, headers: response_headers}} ->
          handle_response(code, body, response_headers, response_type)

        {:error, %HTTPoison.Error{reason: reason}} ->
          raise AppwriteException,
            message: reason,
            code: 500,
            type: response_type,
            response: nil
      end
    rescue
      error ->
        raise AppwriteException,
          message: error
    end
  end

  @spec handle_response(integer(), binary(), Headers.t(), String.t()) :: any()

  defp handle_response(code, body, _headers, response_type) when code >= 400 do
    data = if response_type == "json", do: Jason.decode!(body), else: %{"message" => body}

    raise AppwriteException,
      message: data["message"],
      code: code,
      type: response_type,
      response: nil
  end

  defp handle_response(_code, body, _headers, "arrayBuffer"), do: body
  defp handle_response(_code, body, _headers, "json"), do: Jason.decode!(body)
  defp handle_response(_code, body, _headers, _), do: %{"message" => body}

  @spec maybe_add_fallback_cookie(Headers.t()) :: Headers.t()
  defp maybe_add_fallback_cookie(headers) do
    case System.get_env("FALLBACK_COOKIE") do
      nil -> headers
      cookie -> Map.put(headers, "X-Fallback-Cookies", cookie)
    end
  end

  @spec default_headers() :: Headers.t()
  defp default_headers() do
    Map.put(@headers, "X-Appwrite-Project", get_project_id())
    |> Map.put("X-Appwrite-Key", get_secret())
  end

  @spec default_config() :: any()
  defp default_config() do
    Map.put(@config, "endpoint", get_root_uri())
  end

  @doc """
  Handles chunked uploads for large files.

  ## Parameters
    - `method`: HTTP method (e.g., "POST").
    - `url`: Target URL.
    - `headers`: Map of headers.
    - `payload`: Original payload with file details.
    - `on_progress`: Function to call with progress updates.

  ## Returns
    - Response from the final chunk.
  """
  @spec chunked_upload(String.t(), String.t(), Headers.t(), Payload.t(), (UploadProgress.t() ->
                                                                            any())) :: any()
  def chunked_upload(method, url, headers \\ %{}, payload \\ %{}, on_progress \\ nil) do
    file = payload["file"]

    if file["size"] <= @chunk_size do
      call(method, url, headers, payload)
    else
      chunked_upload_process(method, url, headers, payload, file, on_progress)
    end
  end

  @spec chunked_upload_process(
          String.t(),
          String.t(),
          Headers.t(),
          Payload.t(),
          map(),
          (UploadProgress.t() -> any())
        ) ::
          any()
  defp chunked_upload_process(method, url, headers, payload, file, on_progress) do
    try do
      Stream.iterate(0, &(&1 + @chunk_size))
      |> Stream.take_while(fn start -> start < file["size"] end)
      |> Enum.reduce(nil, fn start, _response ->
        end_byte = min(start + @chunk_size, file["size"])

        headers =
          Map.put(headers, "content-range", "bytes #{start}-#{end_byte - 1}/#{file["size"]}")

        chunk = :binary.part(Base.decode64!(file["data"]), start, end_byte - start)

        updated_payload =
          Map.put(payload, "file", %{
            "data" => Base.encode64(chunk),
            "name" => file["name"],
            "size" => file["size"],
            "type" => file["type"],
            "lastModified" => DateTime.utc_now()
          })

        # Map.put(updated_payload, "fileId", payload.fileId)

        # if payload.permissions != nil do
        #   Map.put(updated_payload, "permissions", payload.permissions)
        # end

        # IO.inspect(updated_payload, label: "Updated Payload")
        response = call(method, url, headers, updated_payload)
        chunks_total = response["chunksTotal"]
        chunks_uploaded = response["chunksUploaded"]
        size_original = response["sizeOriginal"]

        # Calculate percentage uploaded and size uploaded
        percentage_uploaded = chunks_uploaded / chunks_total * 100
        size_uploaded = chunks_uploaded / chunks_total * size_original

        # Display the results
        # IO.puts("Percentage Uploaded: #{percentage_uploaded}%")
        # IO.puts("Size Uploaded: #{size_uploaded} bytes")

        # IO.ANSI.format([:green, "Percentage Uploaded: #{percentage_uploaded}%"])
        # IO.ANSI.format([:blue, "Size Uploaded: #{size_uploaded} / #{size_original} bytes"])

        IO.puts(IO.ANSI.format([:green, "Percentage Uploaded: #{percentage_uploaded}%"]))

        IO.puts(
          IO.ANSI.format([
            :blue,
            "Size Uploaded: #{General.bytes_to_human_readable(size_uploaded)} / #{General.bytes_to_human_readable(size_original)}"
          ])
        )

        # IO.write(IO.ANSI.cursor_up(2))
        # IO.write(IO.ANSI.clear_line())

        if on_progress do
          on_progress.(%UploadProgress{
            id: Map.get(response, "$id"),
            progress: round(end_byte / file["size"] * 100),
            size_uploaded: end_byte,
            chunks_total: div(file["size"], @chunk_size) + 1,
            chunks_uploaded: div(end_byte, @chunk_size)
          })
        end

        if response && response["$id"] do
          Map.put(headers, "x-appwrite-id", response["$id"])
        end

        response
      end)
    catch
      exception ->
        IO.puts("Error: #{exception.message}")
        IO.inspect(__STACKTRACE__, label: "Stacktrace")
    end
  end

  defp get_project_id() do
    case Application.get_env(get_app_name(), :appwrite_project_id) do
      nil ->
        raise Appwrite.MissingProjectIdError

      project_id ->
        project_id
    end
  end

  defp get_secret() do
    case Application.get_env(get_app_name(), :appwrite_secret) do
      nil ->
        raise Appwrite.MissingSecretError
        ""

      secret ->
        secret
    end
  end

  defp get_root_uri() do
    case Application.get_env(get_app_name(), :appwrite_root_uri) do
      nil ->
        raise Appwrite.MissingRootUriError

      project_id ->
        project_id
    end
  end

  @doc """
  Flattens a nested map or list into a single-level map with prefixed keys.

  ## Examples

      iex> Client.flatten(%{"key1" => %{"key2" => "value"}}, "prefix")
      %{"prefix[key1][key2]" => "value"}

      iex> Client.flatten(%{"key1" => ["a", "b"]}, "prefix")
      %{"prefix[key1][0]" => "a", "prefix[key1][1]" => "b"}

  """
  def flatten(data, prefix \\ "") do
    cond do
      is_map(data) ->
        Enum.reduce(data, %{}, fn {key, value}, acc ->
          final_key = if prefix == "", do: to_string(key), else: "#{prefix}[#{key}]"
          Map.merge(acc, flatten(value, final_key))
        end)

      is_list(data) ->
        data
        |> Enum.with_index()
        |> Enum.reduce(%{}, fn {value, index}, acc ->
          final_key = "#{prefix}[#{index}]"
          Map.merge(acc, flatten(value, final_key))
        end)

      true ->
        %{"#{prefix}" => data}
    end
  end

  def get_app_name do
    Mix.Project.config()[:app]
  end

  defp extract_meta(%{meta: meta}) when is_function(meta, 0), do: meta.()
  defp extract_meta(_), do: nil
end
