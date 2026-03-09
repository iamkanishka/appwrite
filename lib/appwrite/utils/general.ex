defmodule Appwrite.Utils.General do
  @moduledoc """
  General-purpose utilities used across the Appwrite SDK.

  Provides unique ID generation (UUID v4) and human-readable byte formatting.
  """

  @doc """
  Generates a unique ID using a version 4 UUID.

  The returned string is suitable for use as a resource identifier across
  all Appwrite services.

  ## Examples

      iex> Appwrite.Utils.General.generate_unique_id()
      "550e8400-e29b-41d4-a716-446655440000"

  ## Notes
  - The UUID follows the v4 standard, ensuring cryptographic randomness.
  """
  @spec generate_unique_id() :: String.t()
  def generate_unique_id do
    UUID.uuid4()
  end

  # Keep the old misspelled name as a delegating alias so existing callers
  # compiled against the old API continue to work without changes.
  @doc false
  @spec generate_uniqe_id() :: String.t()
  def generate_uniqe_id, do: generate_unique_id()

  @doc """
  Converts a byte count into a human-readable string.

  Automatically selects the most appropriate unit (Bytes, KB, MB, or GB)
  and rounds fractional values to two decimal places.

  ## Examples

      iex> Appwrite.Utils.General.bytes_to_human_readable(512)
      "512 Bytes"

      iex> Appwrite.Utils.General.bytes_to_human_readable(2048)
      "2.0 KB"

      iex> Appwrite.Utils.General.bytes_to_human_readable(1_500_000)
      "1.43 MB"

      iex> Appwrite.Utils.General.bytes_to_human_readable(2_000_000_000)
      "1.86 GB"

  """
  @spec bytes_to_human_readable(number()) :: String.t()
  def bytes_to_human_readable(bytes) do
    cond do
      bytes < 1_024 ->
        "#{bytes} Bytes"

      bytes < 1_024 * 1_024 ->
        "#{Float.round(bytes / 1_024, 2)} KB"

      bytes < 1_024 * 1_024 * 1_024 ->
        "#{Float.round(bytes / (1_024 * 1_024), 2)} MB"

      true ->
        "#{Float.round(bytes / (1_024 * 1_024 * 1_024), 2)} GB"
    end
  end
end
