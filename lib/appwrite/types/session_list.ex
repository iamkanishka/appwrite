
defmodule Appwrite.Types.SessionList do
  @moduledoc """
  Represents a list of sessions.

  ## Fields

    - `total` (`integer`): Total number of sessions that matched the query.
    - `sessions` (`[Appwrite.Types.Session.t]`): List of sessions.
  """

  @type t :: %__MODULE__{
          total: integer(),
          sessions: [Appwrite.Types.Session.t()]
        }

  defstruct [:total, :sessions]
end
