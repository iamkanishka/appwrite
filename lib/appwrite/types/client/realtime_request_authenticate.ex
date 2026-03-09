defmodule Appwrite.Types.Client.RealtimeRequestAuthenticate do
  @moduledoc """
  Payload for a Realtime authentication request.

  Sent as the `data` field of a `RealtimeRequest` when the client needs
  to authenticate an existing session over the WebSocket connection.

  ## Fields

    - `session` (`String.t()`) — The session secret used to authenticate
      the WebSocket connection.
  """

  @derive Jason.Encoder

  @type t :: %__MODULE__{
          session: String.t()
        }

  defstruct [:session]
end
