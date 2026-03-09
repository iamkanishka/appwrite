defmodule Appwrite.Types.Client.Realtime do
  @moduledoc """
  Struct representing the state of an Appwrite Realtime WebSocket connection.

  Holds all mutable state needed to manage the connection lifecycle:
  the underlying socket, subscribed channels, active subscriber callbacks,
  reconnection bookkeeping, and the last received server message.

  ## Fields

    - `socket` (`:gen_tcp.socket() | nil`) — The active WebSocket socket,
      or `nil` when disconnected.
    - `timeout` (`non_neg_integer() | nil`) — Operation timeout in milliseconds.
      Defaults to `5_000` when `nil`.
    - `url` (`String.t() | nil`) — WebSocket endpoint URL, or `nil` before
      the client is configured.
    - `last_message` (`Appwrite.Types.Client.RealtimeResponse.t() | nil`) —
      The most recent message received from the server.
    - `channels` (`MapSet.t(String.t())`) — Set of channel names the client
      is currently subscribed to.
    - `subscriptions` (`%{required(non_neg_integer()) => subscription()}`) —
      Map of subscription ID to subscription descriptor. Each descriptor
      holds the channel list and the event callback.
    - `subscriptions_counter` (`non_neg_integer()`) — Monotonically increasing
      counter used to generate unique subscription IDs.
    - `reconnect` (`boolean()`) — Whether the client should attempt to
      reconnect automatically after a disconnection.
    - `reconnect_attempts` (`non_neg_integer()`) — Number of reconnection
      attempts made since the last successful connection.

  ## Subscription descriptor shape

      %{
        channels: [String.t()],
        callback: (Appwrite.Types.Client.RealtimeResponseEvent.t() -> any())
      }
  """

  @type subscription :: %{
          channels: [String.t()],
          callback: (Appwrite.Types.Client.RealtimeResponseEvent.t() -> any())
        }

  @type t :: %__MODULE__{
          socket: :gen_tcp.socket() | nil,
          timeout: non_neg_integer() | nil,
          url: String.t() | nil,
          last_message: Appwrite.Types.Client.RealtimeResponse.t() | nil,
          channels: MapSet.t(String.t()),
          subscriptions: %{required(non_neg_integer()) => subscription()},
          subscriptions_counter: non_neg_integer(),
          reconnect: boolean(),
          reconnect_attempts: non_neg_integer()
        }

  # @derive Jason.Encoder is intentionally omitted: this struct holds
  # a MapSet (channels) and function-value callbacks (subscriptions) that
  # cannot be JSON-serialised. It is internal connection state only.
  defstruct [
    :socket,
    :timeout,
    :url,
    :last_message,
    :channels,
    :subscriptions,
    :subscriptions_counter,
    :reconnect,
    :reconnect_attempts
  ]

  @doc """
  Returns a new `Realtime` struct with default values.

  Optionally accepts a keyword list or map of field overrides. Only known
  struct keys are accepted; unknown keys raise a `KeyError`.

  ## Examples

      iex> Appwrite.Types.Client.Realtime.new()
      %Appwrite.Types.Client.Realtime{channels: MapSet.new(), ...}

      iex> Appwrite.Types.Client.Realtime.new(url: "wss://cloud.appwrite.io/v1/realtime")
      %Appwrite.Types.Client.Realtime{url: "wss://...", ...}
  """
  @spec new(Enum.t()) :: t()
  def new(attrs \\ []) do
    struct!(
      %__MODULE__{
        socket: nil,
        timeout: nil,
        url: nil,
        last_message: nil,
        channels: MapSet.new(),
        subscriptions: %{},
        subscriptions_counter: 0,
        reconnect: false,
        reconnect_attempts: 0
      },
      attrs
    )
  end

  @doc """
  Returns the configured timeout in milliseconds.

  Falls back to `5_000` ms when `timeout` is `nil`.

  ## Examples

      iex> Realtime.get_timeout(%Realtime{timeout: nil})
      5000

      iex> Realtime.get_timeout(%Realtime{timeout: 10_000})
      10000
  """
  @spec get_timeout(t()) :: non_neg_integer()
  def get_timeout(%__MODULE__{timeout: nil}), do: 5_000
  def get_timeout(%__MODULE__{timeout: timeout}), do: timeout

  @doc """
  Removes the given channels from the struct's channel set.

  Does not close any WebSocket connection or notify the server; callers
  are responsible for resubscribing if needed.

  ## Examples

      iex> rt = Realtime.new(channels: MapSet.new(["files", "documents"]))
      iex> Realtime.clean_up(rt, ["files"])
      %Realtime{channels: MapSet.new(["documents"]), ...}
  """
  @spec clean_up(t(), [String.t()]) :: t()
  def clean_up(%__MODULE__{} = realtime, channels) when is_list(channels) do
    updated = MapSet.difference(realtime.channels, MapSet.new(channels))
    %{realtime | channels: updated}
  end
end
