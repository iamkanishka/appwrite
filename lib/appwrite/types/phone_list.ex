defmodule Appwrite.Types.PhoneList do
  @moduledoc """
  Represents a list of phone dialling codes.

  ## Fields

    - `total` (`non_neg_integer()`): Total number of phones that matched the query.
    - `phones` (`[Appwrite.Types.Phone.t()]`): List of phones.
  """

  @derive Jason.Encoder

  @type t :: %__MODULE__{
          total: non_neg_integer(),
          phones: [Appwrite.Types.Phone.t()]
        }

  defstruct [:total, :phones]
end
