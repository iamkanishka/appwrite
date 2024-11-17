defmodule Appwrite.Types.LocaleCodeList do
  @moduledoc """
  Represents a list of locale codes.

  ## Fields

    - `total` (`integer`): Total number of locale codes that matched the query.
    - `locale_codes` (`[Appwrite.Types.LocaleCode.t]`): List of locale codes.
  """

  @type t :: %__MODULE__{
          total: integer(),
          locale_codes: [Appwrite.Types.LocaleCode.t()]
        }

  defstruct [:total, :locale_codes]
end
