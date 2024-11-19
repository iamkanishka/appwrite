defmodule Appwrite.Types.Client.RealtimeRequestAuthenticate do
  @moduledoc """
  Realtime request structure for authentication.
  """
  defstruct [:session]

  @type t :: %__MODULE__{
          session: String.t()
        }
end
