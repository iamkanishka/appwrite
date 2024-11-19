defmodule Appwrite.Types.Client.RealtimeResponseEvent do
  @moduledoc """
  Realtime event response structure with a generic payload type.
  """
  defstruct [:events, :channels, :timestamp, :payload]

  @type t :: %__MODULE__{
          events: [String.t()],
          channels: [String.t()],
          timestamp: non_neg_integer(),
          payload: Appwrite.Types.Client.Payload
        }
end
