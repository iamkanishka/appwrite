defmodule Appwrite.Types.LanguageList do
  @moduledoc """
  Represents a list of languages.

  ## Fields

    - `total` (`non_neg_integer()`): Total number of languages that matched the query.
    - `languages` (`[Appwrite.Types.Language.t()]`): List of languages.
  """

  @derive Jason.Encoder

  @type t :: %__MODULE__{
          total: non_neg_integer(),
          languages: [Appwrite.Types.Language.t()]
        }

  defstruct [:total, :languages]
end
