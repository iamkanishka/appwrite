defmodule Appwrite.Utils.Service do
  @moduledoc """
  Utility functions shared across Appwrite service modules.

  Provides payload flattening (for building query strings) and basic
  nil-validation helpers.

  > #### Note {: .info}
  > `flatten/2` in this module is intentionally consistent with
  > `Appwrite.Utils.Client.flatten/2` — both produce bracket-notation keys
  > and handle nested maps and indexed lists identically.
  """

  alias Appwrite.Types.Client.Payload

  @chunk_size 5 * 1_024 * 1_024

  @doc """
  Returns the maximum chunk size (in bytes) used for file uploads.

  ## Examples

      iex> Appwrite.Utils.Service.chunk_size()
      5242880

  """
  @spec chunk_size() :: non_neg_integer()
  def chunk_size, do: @chunk_size

  @doc """
  Flattens a nested map or indexed list into a single-level string-keyed map
  using bracket notation, suitable for URI query encoding.

  ## Parameters
  - `data` — the map or list to flatten.
  - `prefix` — key prefix for nested keys (default `""`).

  ## Examples

      iex> Appwrite.Utils.Service.flatten(%{"a" => %{"b" => "v"}})
      %{"a[b]" => "v"}

      iex> Appwrite.Utils.Service.flatten(%{"list" => ["x", "y"]})
      %{"list[0]" => "x", "list[1]" => "y"}

      iex> Appwrite.Utils.Service.flatten(["a", "b"], "items")
      %{"items[0]" => "a", "items[1]" => "b"}

  """
  @spec flatten(Payload.t(), String.t()) :: map()
  def flatten(data, prefix \\ "")

  # Map branch — enumerate as {key, value} pairs
  def flatten(data, prefix) when is_map(data) do
    Enum.reduce(data, %{}, fn {key, value}, acc ->
      final_key = if prefix == "", do: to_string(key), else: "#{prefix}[#{key}]"

      if is_map(value) or is_list(value) do
        Map.merge(acc, flatten(value, final_key))
      else
        Map.put(acc, final_key, value)
      end
    end)
  end

  # FIX: The original implementation had a single-clause guard
  # `when is_map(data) or is_list(data)` but then pattern-matched
  # `fn {key, value}, acc ->` inside Enum.reduce — which crashes for lists
  # because list elements are plain values, NOT {key, value} tuples.
  # Lists must be enumerated with Enum.with_index to build indexed keys.
  def flatten(data, prefix) when is_list(data) do
    data
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {value, index}, acc ->
      final_key = if prefix == "", do: to_string(index), else: "#{prefix}[#{index}]"

      if is_map(value) or is_list(value) do
        Map.merge(acc, flatten(value, final_key))
      else
        Map.put(acc, final_key, value)
      end
    end)
  end

  @doc """
  Returns `data` unchanged, or raises `ArgumentError` if `data` is `nil`.

  Use this for asserting that a required value is present before sending a
  request. For API-boundary validation that should return `{:error, ...}`,
  use inline `is_nil/1` guards in the service function directly.

  ## Examples

      iex> Appwrite.Utils.Service.ensure_not_nil("hello")
      "hello"

      iex> Appwrite.Utils.Service.ensure_not_nil(nil)
      ** (ArgumentError) Input cannot be nil

  """
  @spec ensure_not_nil(any()) :: any()
  def ensure_not_nil(data) do
    if is_nil(data) do
      raise ArgumentError, "Input cannot be nil"
    else
      data
    end
  end
end
