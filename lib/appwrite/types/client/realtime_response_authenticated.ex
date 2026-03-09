defmodule Appwrite.Types.Client.RealtimeResponseAuthenticated do
  @moduledoc """
  Data payload for a Realtime `"response"` (authentication result) message.

  Received when the server processes a client authentication request. The
  `success` flag indicates whether the session was accepted.

  ## Fields

    - `to` (`String.t()`) — The session ID the authentication applies to.
    - `success` (`boolean()`) — Whether the authentication succeeded.
    - `user` (`map()`) — Partial user object returned by the server on
      successful authentication. Shape matches the Appwrite user resource.
  """

  @derive Jason.Encoder

  @type t :: %__MODULE__{
          to: String.t(),
          success: boolean(),
          user: map()
        }

  defstruct [:to, :success, :user]
end
