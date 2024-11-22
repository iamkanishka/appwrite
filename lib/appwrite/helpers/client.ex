defmodule Appwrite.Helpers.Client do
  @moduledoc """
  Client module for handling requests to Appwrite.
  """

  alias Appwrite.Exceptions.AppwriteException
  alias Appwrite.Types.Client.UploadProgress


  @chunk_size 1024 * 1024 * 5

  defstruct [
    :endpoint,
    :endpoint_realtime,
    :project,
    :jwt,
    :locale,
    :session,
    headers: %{
      "x-sdk-name" => "Web",
      "x-sdk-platform" => "client",
      "x-sdk-language" => "web",
      "x-sdk-version" => "16.0.2",
      "X-Appwrite-Response-Format" => "1.6.0"
    }
  ]

  @type t :: %__MODULE__{
          endpoint: String.t() | nil,
          endpoint_realtime: String.t() | nil,
          project: String.t() | nil,
          jwt: String.t() | nil,
          locale: String.t() | nil,
          session: String.t() | nil,
          headers: %{String.t() => String.t()}
        }

  @doc """
  Creates a new client instance with default configuration.
  """
  def new() do
    %__MODULE__{
      endpoint: "https://cloud.appwrite.io/v1",
      endpoint_realtime: nil,
      project: nil,
      jwt: nil,
      locale: nil,
      session: nil
    }
  end

  @doc """
  Sets the API endpoint.

  ## Parameters
    - `client`: The current client instance.
    - `endpoint`: The API endpoint.

  ## Returns
    - Updated client instance.
  """
  def set_endpoint(%__MODULE__{} = client, endpoint) when is_binary(endpoint) do
    endpoint_realtime =
      client.endpoint_realtime ||
        endpoint
        |> String.replace("https://", "wss://")
        |> String.replace("http://", "ws://")

    %{client | endpoint: endpoint, endpoint_realtime: endpoint_realtime}
  end

  @doc """
  Sets the realtime endpoint.

  ## Parameters
    - `client`: The current client instance.
    - `endpoint_realtime`: The realtime endpoint.

  ## Returns
    - Updated client instance.
  """
  def set_endpoint_realtime(%__MODULE__{} = client, endpoint_realtime) when is_binary(endpoint_realtime) do
    %{client | endpoint_realtime: endpoint_realtime}
  end

  @doc """
  Sets the project ID.

  ## Parameters
    - `client`: The current client instance.
    - `project`: The project ID.

  ## Returns
    - Updated client instance.
  """
  def set_project(%__MODULE__{} = client, project) when is_binary(project) do
    headers = Map.put(client.headers, "X-Appwrite-Project", project)
    %{client | project: project, headers: headers}
  end

  @doc """
  Sets the JWT.

  ## Parameters
    - `client`: The current client instance.
    - `jwt`: The JSON Web Token.

  ## Returns
    - Updated client instance.
  """
  def set_jwt(%__MODULE__{} = client, jwt) when is_binary(jwt) do
    headers = Map.put(client.headers, "X-Appwrite-JWT", jwt)
    %{client | jwt: jwt, headers: headers}
  end

  @doc """
  Sets the locale.

  ## Parameters
    - `client`: The current client instance.
    - `locale`: The locale string.

  ## Returns
    - Updated client instance.
  """
  def set_locale(%__MODULE__{} = client, locale) when is_binary(locale) do
    headers = Map.put(client.headers, "X-Appwrite-Locale", locale)
    %{client | locale: locale, headers: headers}
  end

  @doc """
  Sets the session.

  ## Parameters
    - `client`: The current client instance.
    - `session`: The session string.

  ## Returns
    - Updated client instance.
  """
  def set_session(%__MODULE__{} = client, session) when is_binary(session) do
    headers = Map.put(client.headers, "X-Appwrite-Session", session)
    %{client | session: session, headers: headers}
  end




  @type method :: String.t()
  @type url :: String.t()
  @type headers :: %{optional(String.t()) => String.t()}
  @type params :: %{optional(String.t()) => any()}
  @type response_type :: String.t()
  @type response :: {:ok, any()} | {:error, any()}

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
  @spec prepare_request(method, url, headers, params) :: {String.t(), map()}
  def prepare_request(method, url, headers \\ %{}, params \\ %{}) do
    method = String.upcase(method)

    headers =
      Map.merge(default_headers(), headers)
      |> maybe_add_fallback_cookie()

    options = %{
      method: method,
      headers: headers,
      hackney: [cookie: :default]
    }

    {uri, options} =
      if method == "GET" do
        query = URI.encode_query(params)
        {url <> "?" <> query, options}
      else
        options =
          case Map.get(headers, "content-type") do
            "application/json" ->
              Map.put(options, :body, Jason.encode!(params))

            "multipart/form-data" ->
              {headers, body} = build_multipart_form(params, headers)
              {headers, Map.put(options, :body, body)}

            _ ->
              options
          end

        {url, options}
      end

    {uri, options}
  end

  @spec maybe_add_fallback_cookie(headers) :: headers
  defp maybe_add_fallback_cookie(headers) do
    case System.get_env("FALLBACK_COOKIE") do
      nil -> headers
      cookie -> Map.put(headers, "X-Fallback-Cookies", cookie)
    end
  end

  @spec default_headers() :: headers
  defp default_headers do
    %{
      "x-sdk-name" => "Web",
      "x-sdk-platform" => "client",
      "x-sdk-language" => "elixir",
      "x-sdk-version" => "16.0.2",
      "X-Appwrite-Response-Format" => "1.6.0"
    }
  end

  @spec build_multipart_form(params, headers) :: {headers, any()}
  defp build_multipart_form(params, headers) do
    form_data =
      params
      |> Enum.reduce([], fn {key, value}, acc ->
        cond do
          is_binary(value) -> [{key, value} | acc]
          true -> acc
        end
      end)

      %{"content-type" => "multipart/form-data", "form-data" => form_data}
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
  @spec chunked_upload(method, url, headers, params, (UploadProgress.t() -> any())) :: any()
  def chunked_upload(method, url, headers \\ %{}, payload \\ %{}, on_progress \\ nil) do
    file = Enum.find(payload, fn {_, value} -> is_map(value) and Map.has_key?(value, :size) end)
    |> elem(1)

    if file.size <= @chunk_size do
      call(method, url, headers, payload)
    else
      chunked_upload_process(method, url, headers, payload, file, on_progress)
    end
  end

  @spec chunked_upload_process(method, url, headers, params, map(), (UploadProgress.t() -> any())) :: any()
  defp chunked_upload_process(method, url, headers, payload, file, on_progress) do
    Stream.iterate(0, &(&1 + @chunk_size))
    |> Stream.take_while(fn start -> start < file.size end)
    |> Enum.reduce(nil, fn start, _response ->
      end_byte = min(start + @chunk_size, file.size)

      headers = Map.put(headers, "content-range", "bytes #{start}-#{end_byte - 1}/#{file.size}")
      chunk = :binary.part(file.content, start, end_byte - start)
      updated_payload = Map.put(payload, :file, %{content: chunk, name: file.name})

      response = call(method, url, headers, updated_payload)

      if on_progress do
        on_progress.(
          %UploadProgress{
            id: Map.get(response, "$id"),
            progress: round((end_byte / file.size) * 100),
            size_uploaded: end_byte,
            chunks_total: div(file.size, @chunk_size) + 1,
            chunks_uploaded: div(end_byte, @chunk_size)
          }
        )
      end

      response
    end)
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
  @spec call(method, url, headers, params, response_type) :: any()
  def call(method, url, headers \\ %{}, params \\ %{}, response_type \\ "json") do
    {uri, options} = prepare_request(method, url, headers, params)

    case HTTPoison.request(method, uri, options[:body], options[:headers], options[:hackney]) do
      {:ok, %HTTPoison.Response{status_code: code, body: body, headers: response_headers}} ->
        handle_response(code, body, response_headers, response_type)

      {:error, %HTTPoison.Error{reason: reason}} ->
        raise AppwriteException, message: inspect(reason), code: 500
    end
  end

  @spec handle_response(integer(), binary(), headers, response_type) :: any()
  defp handle_response(code, body, headers, response_type) when code >= 400 do
    data = if response_type == "json", do: Jason.decode!(body), else: %{"message" => body}
    raise AppwriteException, message: data["message"], code: code, type: data["type"]
  end

  defp handle_response(_code, body, _headers, "arrayBuffer"), do: body
  defp handle_response(_code, body, _headers, "json"), do: Jason.decode!(body)
  defp handle_response(_code, body, _headers, _), do: %{"message" => body}




  defp get_base_url(config) do
    case config[:root_uri] || Application.get_env(:appwrite, :root_uri) do
      nil ->
        raise Appwrite.MissingRootUriError

      root_uri ->
        root_uri
    end
  end

  defp get_project_id(config) do
    case config[:project_id] || Application.get_env(:appwrite, :project_id) do
      nil ->
        raise Appwrite.MissingProjectIdError

      project_id ->
        project_id
    end
  end

  defp get_secret(config) do
    case config[:secret] || Application.get_env(:appwrite, :secret) do
      nil ->
        raise Appwrite.MissingSecretError

      secret ->
        secret
    end
  end







end
