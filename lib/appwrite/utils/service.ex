defmodule Appwrite.Utils.Service do
  @moduledoc """
  Utility functions shared across Appwrite service modules.

  ## Note on `flatten/2`

  `flatten/2` delegates to `Appwrite.Utils.Client.flatten/2` to ensure a
  single, consistent implementation throughout the SDK. Callers should prefer
  `Client.flatten/2` directly; this function exists as a convenience alias.
  """

  alias Appwrite.Types.Client.Payload
  alias Appwrite.Utils.Client

  @chunk_size 5 * 1_024 * 1_024

  @doc """
  Returns the maximum chunk size (in bytes) used for file uploads.

  ## Examples

      iex> Appwrite.Utils.Service.chunk_size()
      5_242_880

  """
  @spec chunk_size() :: non_neg_integer()
  def chunk_size, do: @chunk_size

  @doc """
  Flattens a nested map or indexed list into a single-level string-keyed map
  using bracket notation, suitable for URI query encoding.

  Delegates to `Appwrite.Utils.Client.flatten/2` to avoid duplicating logic.

  ## Examples

      iex> Appwrite.Utils.Service.flatten(%{"a" => %{"b" => "v"}})
      %{"a[b]" => "v"}

      iex> Appwrite.Utils.Service.flatten(%{"list" => ["x", "y"]})
      %{"list[0]" => "x", "list[1]" => "y"}

      iex> Appwrite.Utils.Service.flatten([\"a\", \"b\"], "items")
      %{"items[0]" => "a", "items[1]" => "b"}

  """
  @spec flatten(Payload.t(), String.t()) :: map()
  def flatten(data, prefix \\ ""), do: Client.flatten(data, prefix)

  @doc """
  Returns `data` unchanged, or raises `ArgumentError` if `data` is `nil`.

  Prefer inline `is_nil/1` checks and `{:error, ...}` tuples in service
  functions. This helper is useful for validating values in pipeline-heavy
  code where raising is acceptable.

  ## Examples

      iex> Appwrite.Utils.Service.ensure_not_nil("hello")
      "hello"

      iex> Appwrite.Utils.Service.ensure_not_nil(nil)
      ** (ArgumentError) Input cannot be nil

  """
  @spec ensure_not_nil(any()) :: any()
  def ensure_not_nil(nil), do: raise(ArgumentError, "Input cannot be nil")
  def ensure_not_nil(data), do: data
end
