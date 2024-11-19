defmodule Appwrite.Types.Client.RealtimeResponseAuthenticated do
  @moduledoc """
  Realtime response structure for authenticated connections.
  """
  defstruct [:to, :success, :user]

  @type t :: %__MODULE__{
          to: String.t(),
          success: boolean(),
          user: map()
        }
end
