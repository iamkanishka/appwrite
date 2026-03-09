defmodule Appwrite.Types.Client.RealtimeRequest do
  @moduledoc """
  A message sent by the client to the Appwrite Realtime WebSocket server.

  Currently only the `:authentication` type is defined by the Appwrite
  Realtime protocol. The `data` field carries the type-specific payload.

  ## Fields

    - `type` (`:authentication`) — Message type tag. Always `:authentication`
      for client-originated requests.
    - `data` (`Appwrite.Types.Client.RealtimeRequestAuthenticate.t()`) —
      Authentication payload containing the session secret.
  """

  @derive Jason.Encoder

  @type t :: %__MODULE__{
          type: :authentication,
          data: Appwrite.Types.Client.RealtimeRequestAuthenticate.t()
        }

  defstruct [:type, :data]
end
