
defmodule Appwrite.Types.IdentityList do
  @moduledoc """
  Represents a list of identities.

  ## Fields

    - `total` (`integer`): Total number of identities that matched the query.
    - `identities` (`[Appwrite.Types.Identity.t]`): List of identities.
  """

  @type t :: %__MODULE__{
          total: integer(),
          identities: [Appwrite.Types.Identity.t()]
        }

  defstruct [:total, :identities]
end
