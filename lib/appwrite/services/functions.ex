defmodule Appwrite.Services.Functions do
  @moduledoc """
  The Functions service allows you to create custom behaviour that can be
  triggered by any supported Appwrite system events or by a predefined schedule.

  """

  use Appwrite.Services.Base

  @doc """
  List all executions for a given function.

  ## Parameters
  - `function_id` (required)
  - `queries` (optional)
  - `search` (optional)
  - `total` (optional) – when `false`, skips count calculation
  """
  @spec list_executions(String.t(), [String.t()] | nil, String.t() | nil, boolean() | nil) ::
          {:ok, map()} | {:error, any()}
  def list_executions(function_id, queries \\ nil, search \\ nil, total \\ nil) do
    with :ok <- require_all(function_id: function_id) do
      payload =
        %{}
        |> maybe_put("queries", queries)
        |> maybe_put("search", search)
        |> maybe_put("total", total)

      json_call("get", "/v1/functions/#{function_id}/executions", payload)
    end
  end

  @doc """
  Create (trigger) a new function execution.

  ## Parameters
  - `function_id` (required)
  - `body` (optional) – custom execution payload
  - `xasync` (optional) – when `true`, runs the execution asynchronously
  - `path` (optional) – custom path for the HTTP trigger
  - `method` (optional) – HTTP method for the trigger (GET, POST, etc.)
  - `headers` (optional) – map of custom request headers
  - `scheduled_at` (optional) – ISO 8601 date string for scheduled execution
  """
  @spec create_execution(
          String.t(),
          String.t() | nil,
          boolean() | nil,
          String.t() | nil,
          String.t() | nil,
          map() | nil,
          String.t() | nil
        ) :: {:ok, map()} | {:error, any()}
  def create_execution(
        function_id,
        body \\ nil,
        xasync \\ nil,
        path \\ nil,
        method \\ nil,
        headers \\ nil,
        scheduled_at \\ nil
      ) do
    with :ok <- require_all(function_id: function_id) do
      payload =
        %{}
        |> maybe_put("body", body)
        |> maybe_put("async", xasync)
        |> maybe_put("path", path)
        |> maybe_put("method", method)
        |> maybe_put("headers", headers)
        |> maybe_put("scheduledAt", scheduled_at)

      json_call("post", "/v1/functions/#{function_id}/executions", payload)
    end
  end

  @doc """
  Get an execution by its unique ID.

  ## Parameters
  - `function_id` (required)
  - `execution_id` (required)
  """
  @spec get_execution(String.t(), String.t()) :: {:ok, map()} | {:error, any()}
  def get_execution(function_id, execution_id) do
    with :ok <- require_all(function_id: function_id, execution_id: execution_id) do
      json_call("get", "/v1/functions/#{function_id}/executions/#{execution_id}", %{})
    end
  end
end
