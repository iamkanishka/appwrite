defmodule Appwrite.Types.LocaleCodeList do
  @moduledoc """
  Represents a list of locale codes.

  ## Fields

    - `total` (`non_neg_integer()`): Total number of locale codes that matched the query.
    - `locale_codes` (`[Appwrite.Types.LocaleCode.t()]`): List of locale codes.
  """

  @derive Jason.Encoder

  @type t :: %__MODULE__{
          total: non_neg_integer(),
          locale_codes: [Appwrite.Types.LocaleCode.t()]
        }

  defstruct [:total, :locale_codes]
end
