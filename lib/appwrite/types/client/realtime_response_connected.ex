defmodule Appwrite.Types.Client.RealtimeResponseConnected do
  @moduledoc """
  Data payload for a Realtime `"connected"` message.

  Sent by the server immediately after the WebSocket handshake succeeds.
  It confirms which channels the client is subscribed to and, if the
  connection is authenticated, includes a partial user object.

  ## Fields

    - `channels` (`[String.t()]`) — List of channel names the client is
      currently subscribed to.
    - `user` (`map() | nil`) — Partial user object if the connection is
      authenticated, or `nil` for guest connections.
  """

  @derive Jason.Encoder

  @type t :: %__MODULE__{
          channels: [String.t()],
          user: map() | nil
        }

  defstruct [:channels, :user]
end
