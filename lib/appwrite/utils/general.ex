defmodule Appwrite.Utils.General do
  @moduledoc """
  General-purpose utilities used across the Appwrite SDK.

  Provides unique ID generation (UUID v4 via `:crypto`) and human-readable
  byte formatting.
  """

  @doc """
  Generates a random UUID v4 string.

  Uses Erlang's `:crypto.strong_rand_bytes/1` — no external dependency required.

  ## Examples

      iex> uuid = Appwrite.Utils.General.generate_unique_id()
      iex> String.match?(uuid, ~r/^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/)
      true

  """
  @spec generate_unique_id() :: String.t()
  def generate_unique_id do
    <<a::48, _::4, b::12, _::2, c::62>> = :crypto.strong_rand_bytes(16)

    <<a::48, 4::4, b::12, 2::2, c::62>>
    |> Base.encode16(case: :lower)
    |> then(fn hex ->
      <<p1::binary-8, p2::binary-4, p3::binary-4, p4::binary-4, p5::binary-12>> = hex
      "#{p1}-#{p2}-#{p3}-#{p4}-#{p5}"
    end)
  end

  # Backward-compat alias (original code had a typo: generate_uniqe_id).
  @doc false
  @spec generate_uniqe_id() :: String.t()
  def generate_uniqe_id, do: generate_unique_id()

  @doc """
  Converts a byte count into a human-readable string.

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
  def bytes_to_human_readable(bytes) when bytes < 1_024, do: "#{bytes} Bytes"

  def bytes_to_human_readable(bytes) when bytes < 1_024 * 1_024,
    do: "#{Float.round(bytes / 1_024, 2)} KB"

  def bytes_to_human_readable(bytes) when bytes < 1_024 * 1_024 * 1_024,
    do: "#{Float.round(bytes / (1_024 * 1_024), 2)} MB"

  def bytes_to_human_readable(bytes),
    do: "#{Float.round(bytes / (1_024 * 1_024 * 1_024), 2)} GB"
end
