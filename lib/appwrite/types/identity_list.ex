defmodule Appwrite.Types.IdentityList do
  @moduledoc """
  Represents a list of identities.

  ## Fields

    - `total` (`non_neg_integer()`): Total number of identities that matched the query.
    - `identities` (`[Appwrite.Types.Identity.t()]`): List of identities.
  """

  @derive Jason.Encoder

  @type t :: %__MODULE__{
          total: non_neg_integer(),
          identities: [Appwrite.Types.Identity.t()]
        }

  defstruct [:total, :identities]
end
