defmodule Appwrite.Types.Client.RealtimeRequest do
  @moduledoc """
  Realtime request structure for authentication.
  """
  defstruct [:type, :data]

  @type t :: %__MODULE__{
          type: :authentication,
          data: Appwrite.Types.Client.RealtimeRequestAuthenticate.t()
        }
end
