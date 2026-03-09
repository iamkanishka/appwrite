defmodule Appwrite.Types.Client.RealtimeResponseEvent do
  @moduledoc """
  Data payload for a Realtime `"event"` message.

  Dispatched by the server whenever a resource that the client is
  subscribed to changes. Subscriber callbacks receive a value of this
  type.

  ## Fields

    - `events` (`[String.t()]`) — List of Appwrite event names that
      triggered this message (e.g. `["databases.*.collections.*.documents.*"]`).
    - `channels` (`[String.t()]`) — List of subscribed channel names that
      matched the event.
    - `timestamp` (`non_neg_integer()`) — Unix timestamp (milliseconds) of
      when the event was generated on the server.
    - `payload` (`Appwrite.Types.Client.Payload.t()`) — Resource snapshot
      at the time of the event, structured as a string-keyed map.
  """

  @derive Jason.Encoder

  @type t :: %__MODULE__{
          events: [String.t()],
          channels: [String.t()],
          timestamp: non_neg_integer(),
          payload: Appwrite.Types.Client.Payload.t()
        }

  defstruct [:events, :channels, :timestamp, :payload]
end
