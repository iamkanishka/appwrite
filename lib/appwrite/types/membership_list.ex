defmodule Appwrite.Types.MembershipList do
  @moduledoc """
  Represents a list of memberships.

  ## Fields

    - `total` (`integer`): Total number of memberships that matched the query.
    - `memberships` (`[Appwrite.Types.Membership.t]`): List of memberships.
  """

  @type t :: %__MODULE__{
          total: integer(),
          memberships: [Appwrite.Types.Membership.t()]
        }

  defstruct [:total, :memberships]
end
