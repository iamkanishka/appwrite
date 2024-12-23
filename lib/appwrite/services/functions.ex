defmodule Appwrite.Services.Functions do
  @moduledoc """
  The Functions service allows you to create custom behaviour that can be triggered
  by any supported Appwrite system events or by a predefined schedule.

  Appwrite Cloud Functions lets you automatically run backend code in response to events triggered by Appwrite
  or by setting it to be executed in a predefined schedule.
  Your code is stored in a secure way on your Appwrite instance and is executed in an isolated environment.
  """

  alias Appwrite.Utils.Client
  alias Appwrite.Consts.ExecutionMethod
  alias Appwrite.Types.{Execution, ExecutionList}

  @doc """
  Lists all executions for a given function.

  ## Parameters

    - `function_id` (`String.t()`): The function ID.
    - `queries` (`[String.t()]`): Optional query parameters.
    - `search` (`String.t()`): Optional search keyword.

  ## Returns

    - `{:ok, %ExecutionList{}}` on success.
    - `{:error, reason}` on failure.
  """
  @spec list_executions(String.t(), [String.t()] | nil, String.t() | nil) ::
          {:ok, ExecutionList.t()} | {:error, any()}
  def list_executions(function_id, queries \\ nil, search \\ nil) do
    with :ok <- validate_not_nil(function_id, "function_id") do
      api_path = "/v1/functions/#{function_id}/executions"

      payload = %{
        queries: queries,
        search: search
      }

      api_header = %{"content-type" => "application/json"}

      Task.async(fn ->
        try do
          executions = Client.call("get", api_path, api_header, payload)
          {:ok, executions}
        rescue
          error -> {:error, error}
        end
      end)
      |> Task.await()
    else
      {:error, reason} -> {:error, reason}
    end
  end

  @doc """
  Creates a function execution.

  ## Parameters

    - `function_id` (`String.t()`): The function ID.
    - `body` (`String.t()`): Optional execution body.
    - `async` (`boolean()`): Optional async flag.
    - `xpath` (`String.t()`): Optional execution path.
    - `method` (`String.t()`): Optional HTTP method.
    - `headers` (`map()`): Optional HTTP headers.
    - `scheduled_at` (`String.t()`): Optional scheduled time.

  ## Returns

    - `{:ok, %Execution{}}` on success.
    - `{:error, reason}` on failure.
  """
  @spec create_execution(
          String.t(),
          String.t() | nil,
          boolean() | nil,
          String.t() | nil,
          String.t() | nil,
          map() | nil,
          String.t() | nil
        ) :: {:ok, Execution.t()} | {:error, any()}
  def create_execution(
        function_id,
        body \\ nil,
        async \\ nil,
        xpath \\ nil,
        method \\ nil,
        headers \\ nil,
        scheduled_at \\ nil
      ) do
    with :ok <- validate_not_nil(function_id, "function_id"),
         :ok <- validate_method(method) do
      api_path = "/v1/functions/#{function_id}/executions"

      payload = %{
        body: body,
        async: async,
        path: xpath,
        method: method,
        headers: headers,
        scheduledAt: scheduled_at
      }

      api_header = %{"content-type" => "application/json"}

      Task.async(fn ->
        try do
          execution = Client.call("post", api_path, api_header, payload)
          {:ok, execution}
        rescue
          error -> {:error, error}
        end
      end)
      |> Task.await()
    else
      {:error, reason} -> {:error, reason}
    end
  end

  @doc """
  Fetches a specific function execution by its ID.

  ## Parameters

    - `function_id` (`String.t()`): The function ID.
    - `execution_id` (`String.t()`): The execution ID.

  ## Returns

    - `{:ok, %Execution{}}` on success.
    - `{:error, reason}` on failure.
  """
  @spec get_execution(String.t(), String.t()) ::
          {:ok, Execution.t()} | {:error, any()}
  def get_execution(function_id, execution_id) do
    with :ok <- validate_not_nil(function_id, "function_id"),
         :ok <- validate_not_nil(execution_id, "execution_id") do
      api_path = "/v1/functions/#{function_id}/executions/#{execution_id}"

      payload = %{}

      api_header = %{"content-type" => "application/json"}

      Task.async(fn ->
        try do
          execution = Client.call("get", api_path, api_header, payload)
          {:ok, execution}
        rescue
          error -> {:error, error}
        end
      end)
      |> Task.await()
    else
      {:error, reason} -> {:error, reason}
    end
  end

  # Helper functions
  defp validate_not_nil(value, name) do
    if is_nil(value), do: {:error, "#{name} cannot be nil"}, else: :ok
  end

  defp validate_method(nil), do: :ok

  defp validate_method(method) do
    case ExecutionMethod.validate_method(method) do
      {:ok, _} -> :ok
      {:error, _} -> {:error, "Invalid HTTP method: #{method}"}
    end
  end

  defp handle_response({:ok, body}, module) do
    {:ok, struct(module, body)}
  end

  defp handle_response({:error, reason}, _module), do: {:error, reason}
end
