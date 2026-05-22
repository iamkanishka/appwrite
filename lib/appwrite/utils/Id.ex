defmodule Appwrite.Utils.Id do
  @moduledoc """
  Helpers for generating resource ID strings compatible with Appwrite's ID format.

  ## Usage

      alias Appwrite.Utils.Id

      Id.unique()           # "67a3f1b20001f3a4b5"  — timestamp + random padding
      Id.unique(10)         # longer padding
      Id.custom("myId")     # pass-through a caller-supplied ID

  """

  @doc """
  Returns the provided custom ID unchanged.

  Use this when you want to supply your own ID rather than having one generated.

  ## Examples

      iex> Appwrite.Utils.Id.custom("my-custom-id")
      "my-custom-id"

  """
  @spec custom(String.t()) :: String.t()
  def custom(id) when is_binary(id), do: id

  @doc """
  Generates a unique ID by combining a hex-encoded timestamp with
  cryptographically-random hex padding.

  The timestamp portion mirrors PHP's `uniqid()` (seconds + millisecond
  fraction, both hex-encoded). Random padding uses `:crypto.strong_rand_bytes/1`
  so successive IDs generated in the same millisecond are still unguessable.

  ## Parameters

  - `padding` — extra random hex bytes appended after the timestamp.
    Default `7`. Each byte produces two hex characters, so `padding: 7`
    adds 14 hex characters.

  ## Examples

      iex> id = Appwrite.Utils.Id.unique()
      iex> is_binary(id) and byte_size(id) > 0
      true

      iex> String.length(Appwrite.Utils.Id.unique(10)) > String.length(Appwrite.Utils.Id.unique(3))
      true

  """
  @spec unique(pos_integer()) :: String.t()
  def unique(padding \\ 7) when is_integer(padding) and padding > 0 do
    hex_timestamp() <> random_hex(padding)
  end

  # ---------------------------------------------------------------------------
  # Private helpers
  # ---------------------------------------------------------------------------

  # Builds the timestamp portion matching PHP's uniqid():
  #   hex(seconds) <> zero-padded hex(milliseconds within current second)
  #
  # NOTE: The correct Erlang time-unit atoms are `:second` and `:millisecond`
  # (singular). The original package used `:seconds` / `:milli_seconds` which
  # are INVALID atoms and raise `badarg` at runtime — this has been corrected.
  @spec hex_timestamp() :: String.t()
  defp hex_timestamp do
    now_sec = :os.system_time(:second)
    now_msec = :os.system_time(:millisecond)
    msec_part = now_msec - now_sec * 1_000

    Integer.to_string(now_sec, 16) <>
      String.pad_leading(Integer.to_string(msec_part, 16), 5, "0")
  end

  # Generates `n` random bytes and hex-encodes them.
  # Using :crypto.strong_rand_bytes/1 instead of :rand.uniform/1 for
  # cryptographically-secure randomness (avoids birthday collisions when
  # many IDs are generated in rapid succession).
  @spec random_hex(pos_integer()) :: String.t()
  defp random_hex(n) do
    n
    |> :crypto.strong_rand_bytes()
    |> Base.encode16(case: :lower)
  end
end
