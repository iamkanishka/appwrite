defmodule Appwrite.Types.SessionList do
  @moduledoc """
  Represents a list of sessions.

  ## Fields

    - `total` (`non_neg_integer()`): Total number of sessions that matched the query.
    - `sessions` (`[Appwrite.Types.Session.t()]`): List of sessions.
  """

  @derive Jason.Encoder

  @type t :: %__MODULE__{
          total: non_neg_integer(),
          sessions: [Appwrite.Types.Session.t()]
        }

  defstruct [:total, :sessions]
end
