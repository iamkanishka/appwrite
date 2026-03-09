defmodule Appwrite.Types.Client.RealtimeResponse do
  @moduledoc """
  A message received from the Appwrite Realtime WebSocket server.

  The `type` atom identifies the kind of message; `data` holds the
  corresponding typed payload struct.

  | `type`          | `data` type                                  |
  |-----------------|----------------------------------------------|
  | `:connected`    | `RealtimeResponseConnected.t()`              |
  | `:event`        | `RealtimeResponseEvent.t()`                  |
  | `:response`     | `RealtimeResponseAuthenticated.t()`          |
  | `:error`        | `RealtimeResponseError.t()`                  |

  ## Fields

    - `type` (`:connected | :event | :response | :error`) — Message type tag.
    - `data` — Type-specific payload. See table above.
  """

  @derive Jason.Encoder

  @type t :: %__MODULE__{
          type: :connected | :event | :response | :error,
          data:
            Appwrite.Types.Client.RealtimeResponseConnected.t()
            | Appwrite.Types.Client.RealtimeResponseEvent.t()
            | Appwrite.Types.Client.RealtimeResponseAuthenticated.t()
            | Appwrite.Types.Client.RealtimeResponseError.t()
        }

  defstruct [:type, :data]
end
