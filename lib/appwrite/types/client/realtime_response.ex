
defmodule Appwrite.Types.Client.RealtimeResponse do
  @moduledoc """
  Realtime response structure with different response types.
  """
  defstruct [:type, :data]

  @type t ::
          %__MODULE__{
            type: :error | :event | :connected | :response,
            data:
              Appwrite.Types.Client.RealtimeResponseAuthenticated.t()
              | Appwrite.Types.Client.RealtimeResponseConnected.t()
              | Appwrite.Types.Client.RealtimeResponseError.t()
              | Appwrite.Types.Client.RealtimeResponseEvent.t()
          }
end
