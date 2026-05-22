defmodule Appwrite.Services.Base do
  @moduledoc false
  # Injects common private helpers into every Appwrite service module via `use`.
  #
  # Injected helpers:
  #   - `json_call/3`    — executes an authenticated JSON request via Client
  #   - `require_all/1`  — returns :ok or {:error, AppwriteException} for nil params
  #   - `maybe_put/3`    — adds a key to a map only when value is non-nil
  #
  # Also injects:
  #   - `alias Appwrite.Exceptions.AppwriteException`
  #   - `alias Appwrite.Utils.Client`
  #   - `@dialyzer :no_contracts` — suppresses spec-vs-success-type mismatches
  #     that arise because `Client.call/5` returns `any()` at the type level.

  defmacro __using__(_opts) do
    quote do
      alias Appwrite.Exceptions.AppwriteException
      alias Appwrite.Utils.Client

      @dialyzer :no_contracts

      @spec json_call(String.t(), String.t(), map()) ::
              {:ok, map() | nil | binary()} | {:error, any()}
      defp json_call(method, path, payload) do
        try do
          {:ok, Client.call(method, path, %{"content-type" => "application/json"}, payload)}
        rescue
          e -> {:error, e}
        end
      end

      @spec require_all(keyword()) :: :ok | {:error, AppwriteException.t()}
      defp require_all(params) do
        case Enum.find(params, fn {_, v} -> is_nil(v) end) do
          nil ->
            :ok

          {key, _} ->
            {:error, %AppwriteException{message: "Missing required parameter: #{key}"}}
        end
      end

      defp maybe_put(map, _key, nil), do: map
      defp maybe_put(map, key, value), do: Map.put(map, key, value)

      defoverridable json_call: 3, require_all: 1
    end
  end
end
