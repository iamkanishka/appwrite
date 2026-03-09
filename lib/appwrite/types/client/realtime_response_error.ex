defmodule Appwrite.Types.Client.RealtimeResponseError do
  @moduledoc """
  Data payload for a Realtime `"error"` message.

  Sent by the server when a protocol or application-level error occurs
  on the WebSocket connection.

  ## Fields

    - `code` (`non_neg_integer()`) — Numeric error code (mirrors HTTP status
      codes where applicable, e.g. `401`, `1008`).
    - `message` (`String.t()`) — Human-readable error description.
  """

  @derive Jason.Encoder

  @type t :: %__MODULE__{
          code: non_neg_integer(),
          message: String.t()
        }

  defstruct [:code, :message]
end
