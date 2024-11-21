defmodule Appwrite.Helpers.Service do
  @moduledoc """
  A service utility module for operations like chunked uploads and payload flattening.
  """

  alias Appwrite.Types.Client.Payload

  @chunk_size 5 * 1024 * 1024
  @doc """
  Returns the size for chunked uploads in bytes.

  ## Examples

      iex> Appwrite.Service.chunk_size()
      5242880
  """
  @spec chunk_size() :: non_neg_integer()
  def chunk_size, do: @chunk_size

  @doc """
  Flattens a nested map or list structure into a key-value map with prefixed keys.

  ## Parameters

    - `data` (`Payload.t`): The nested map or list to flatten.
    - `prefix` (`String.t`): The prefix for keys (default: `""`).

  ## Returns

    - A flattened map with keys prefixed appropriately.

  ## Examples

      iex> Appwrite.Service.flatten(%{"key1" => %{"key2" => "value"}}, "prefix")
      %{"prefix[key1][key2]" => "value"}

      iex> Appwrite.Service.flatten(%{"key1" => ["value1", "value2"]})
      %{"key1[0]" => "value1", "key1[1]" => "value2"}
  """
  @spec flatten(Payload.t(), String.t()) :: Payload.t()
  def flatten(data, prefix \\ "") when is_map(data) or is_list(data) do
    try do
      data
      |> Enum.reduce(%{}, fn {key, value}, acc ->
        final_key =
          if prefix == "" do
            key
          else
            "#{prefix}[#{key}]"
          end

        if is_map(value) or is_list(value) do
          Map.merge(acc, flatten(value, final_key))
        else
          Map.put(acc, final_key, value)
        end
      end)
    rescue
      _e ->
        raise ArgumentError, "Invalid data type: `data` must be a map or a list."
    end
  end

  @doc """
  Validates that the given data is not `nil`.

  ## Parameters

    - `data` (`any`): The data to check.

  ## Returns

    - The data itself if it is valid.

  ## Raises

    - `ArgumentError` if the data is `nil`.

  ## Examples

      iex> Appwrite.Service.ensure_not_nil(%{})
      %{}

      iex> Appwrite.Service.ensure_not_nil(nil)
      ** (ArgumentError) Input cannot be nil
  """
  @spec ensure_not_nil(any()) :: any()
  def ensure_not_nil(data) do
    if data == nil do
      raise ArgumentError, "Input cannot be nil"
    else
      data
    end
  end
end
