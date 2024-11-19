defmodule Appwrite.Types.Client.RealtimeResponseConnected do
  @moduledoc """
  Realtime response structure for a successful connection.
  """
  defstruct [:channels, :user]

  @type t :: %__MODULE__{
          channels: [String.t()],
          user: map() | nil
        }
end
