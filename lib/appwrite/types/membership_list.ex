defmodule Appwrite.Types.MembershipList do
  @moduledoc """
  Represents a list of memberships.

  ## Fields

    * `total` - Total number of memberships that matched the query.
    * `memberships` - List of memberships.
  """

  @derive Jason.Encoder
  @type t :: %__MODULE__{
          total: non_neg_integer(),
          memberships: [Appwrite.Types.Membership.t()]
        }

  defstruct total: 0, memberships: []
end
