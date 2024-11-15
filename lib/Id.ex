defmodule ID do
  @moduledoc """
  Helper module to generate ID strings for resources. This module provides functions
  to generate unique ID strings, either based on a timestamp or with custom or Appwrite-like generation methods.
  """

  @doc """
  Generates a hexadecimal ID based on the current timestamp.

  This method recreates the behavior of PHP's `uniqid()` function by combining
  the current time in seconds and milliseconds, and converting it to hexadecimal.

  ## Examples

      iex> ID.hex_timestamp()
      "1a3b5f9"

  """
  @spec hex_timestamp() :: String.t()
  defp hex_timestamp do
    now = :os.system_time(:seconds)
    msec = :os.system_time(:milli_seconds) - (now * 1000)

    # Convert to hexadecimal
    hex_timestamp = Integer.to_string(now, 16) <> String.pad_leading(Integer.to_string(msec, 16), 5, "0")
    hex_timestamp
  end

  @doc """
  Returns the provided custom ID.

  ## Examples

      iex> ID.custom("custom_id")
      "custom_id"

  """
  @spec custom(String.t()) :: String.t()
  def custom(id) when is_binary(id) do
    id
  end

  @doc """
  Generates a unique ID by combining a hex timestamp and a random hex padding.

  The padding defaults to 7 hex digits but can be modified.

  ## Examples

      iex> ID.unique()
      "1a3b5f9cdb013f703"

      iex> ID.unique(10)
      "1a3b5f9cdb013f703f70388"

  """
  @spec unique(non_neg_integer()) :: String.t()
  def unique(padding \\ 7) when is_integer(padding) and padding > 0 do
    base_id = hex_timestamp()

    random_padding =
      for _ <- 1..padding do
        # Generate random hex digit
        Integer.to_string(:rand.uniform(16) - 1, 16)
      end
      |> Enum.join()

    base_id <> random_padding
  end
end
