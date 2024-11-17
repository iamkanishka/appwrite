defmodule Appwrite.Types.PhoneList do
  @moduledoc """
  Represents a list of phones.

  ## Fields

    - `total` (`integer`): Total number of phones that matched the query.
    - `phones` (`[Appwrite.Types.Phone.t]`): List of phones.
  """

  @type t :: %__MODULE__{
          total: integer(),
          phones: [Appwrite.Types.Phone.t()]
        }

  defstruct [:total, :phones]
end
