defmodule Appwrite.Types.Client.RealtimeResponseError do
  @moduledoc """
  Realtime response structure for errors.
  """
  defstruct [:code, :message]

  @type t :: %__MODULE__{
          code: non_neg_integer(),
          message: String.t()
        }
end
