defmodule Appwrite.Utils.Id do
  @moduledoc """
  Helpers for generating resource ID strings compatible with Appwrite's ID format.

  ## Usage

      alias Appwrite.Utils.Id

      Id.unique()        # "67a3f1b2c0d4e5f6a" — timestamp + random padding
      Id.unique(10)      # longer padding
      Id.custom("myId")  # pass through a caller-supplied ID

  """

  @doc """
  Returns the provided custom ID unchanged.

  Use this when you want to supply your own ID instead of generating one.

  ## Examples

      iex> Appwrite.Utils.Id.custom("my-custom-id")
      "my-custom-id"

  """
  @spec custom(String.t()) :: String.t()
  def custom(id) when is_binary(id), do: id

  @doc """
  Generates a unique ID by combining a hex-encoded timestamp with random
  hex padding.

  The timestamp portion replicates PHP's `uniqid()` behaviour (seconds +
  millisecond fraction, both hex-encoded). The random padding reduces the
  chance of collision when multiple IDs are generated within the same
  millisecond.

  ## Parameters
  - `padding` — number of additional random hex digits appended after the
    timestamp (default: `7`, minimum: `1`).

  ## Examples

      iex> Appwrite.Utils.Id.unique()
      # => something like "67a3f1b2c0001f3a4b5"  (length varies with time)

      iex> String.length(Appwrite.Utils.Id.unique(10)) > String.length(Appwrite.Utils.Id.unique(5))
      true

  """
  @spec unique(pos_integer()) :: String.t()
  def unique(padding \\ 7) when is_integer(padding) and padding > 0 do
    hex_timestamp() <> random_hex(padding)
  end

  # ---------------------------------------------------------------------------
  # Private helpers
  # ---------------------------------------------------------------------------

  # Builds a hex timestamp string that mirrors PHP's uniqid():
  #   hex(seconds) <> left-padded hex(milliseconds within current second)
  #
  # FIX: The original code used :os.system_time(:seconds) and
  # :os.system_time(:milli_seconds) — both are INVALID Erlang atoms and raise
  # `badarg` at runtime.  The correct singular atoms are :second and
  # :millisecond.
  @spec hex_timestamp() :: String.t()
  defp hex_timestamp do
    now_sec  = :os.system_time(:second)
    now_msec = :os.system_time(:millisecond)
    msec_part = now_msec - now_sec * 1_000

    Integer.to_string(now_sec, 16) <>
      String.pad_leading(Integer.to_string(msec_part, 16), 5, "0")
  end

  # Generates `n` random hex characters.
  @spec random_hex(pos_integer()) :: String.t()
  defp random_hex(n) do
    for _ <- 1..n, into: "" do
      # :rand.uniform(16) returns 1..16; subtract 1 for 0..15
      Integer.to_string(:rand.uniform(16) - 1, 16)
    end
  end
end
